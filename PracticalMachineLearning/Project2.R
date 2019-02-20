

# ## Executive Summary
# 
# Based on a dataset provide by HAR [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har) we will try to train a predictive model to predict what exercise was performed using a dataset with 159 features
# 
# 
# 
# We'll take the following steps:
# 
# - Process the data, for use of this project
# - Explore the data, especially focussing on the two paramaters we are interested in 
# - Model selection, where we try different models to help us answer our questions
# - Model examination, to see wether our best model holds up to our standards
# - A Conclusion where we answer the questions based on the data
# - Predicting the classification of the model on test set
# 
# ## Processing
# 
# First change 'am' to  factor (0 = automatic, 1 = manual)
# And make cylinders a factor as well (since it is not continious)

my_path <- getwd()
remote_url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
downloaded_file = "pml-training.csv"
download.file(remote_url, file.path(my_path, downloaded_file))


remote_url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
downloaded_file = "pml-testing.csv"
download.file(remote_url, file.path(my_path, downloaded_file))

library(Rmisc)
library(ggplot2)
library(caret)
library(randomForest)
library(lattice)
library(plyr)

set.seed(13019)

trainingOrig <- read.csv("pml-training.csv")
testingOrig <- read.csv("pml-testing.csv")

## Preprocessing

# Data contains 160 columns and 19622 rows. So we have ideally 160-1 predictors
dim(trainingOrig)
#head(trainingOrig)
#str(trainingOrig)

# We convert 2 columns with factors to number format - user_name, new_window
trainingOrig$user_name <- as.numeric(as.character(trainingOrig$user_name))
trainingOrig$new_window <- as.numeric(as.character(trainingOrig$new_window))

# With head() function we saw many columns have NA. So we are removing all columns which has more than 10% NAs
# We have decided not to impute any Imputing data
NA_percent = 10
ColNA_percent <- nrow(trainingOrig) / 100 * NA_percent
removeColumns <- which(colSums(is.na(trainingOrig) | trainingOrig=="") > ColNA_percent)
trainingFinal <- trainingOrig[,-removeColumns]
testingFinal <- testingOrig[,-removeColumns]
# summary(trainingStep1)
# Now we have 58 - 1, columns now to chose predictor from
dim(trainingFinal)

# We have 3 columns related to time, raw_timestamp_part_1, raw_timestamp_part_2, cvtd_timestamp and 
removeColumns <- grep("timestamp", names(trainingFinal))
trainingFinal <- trainingFinal[,-c(1, removeColumns )]
testingFinal <- testingFinal[,-c(1, removeColumns )]
# Now we have 54 - 1, columns now to chose predictor from
dim(trainingFinal)

# ## Exploratory data analyses 

# Since the test set provided is the the ultimate validation set, 
# we will split the current training in a test (validation) and train set to work with.

classeIndex <- which(names(trainingFinal) == "classe")
partition <- createDataPartition(y=trainingFinal$classe, p=0.75, list=FALSE)
trainSet <- trainingFinal[partition, ]
validationSet <- trainingFinal[-partition, ]
rbind(dim(trainSet),dim(validationSet))

# What are some fields that have high correlations with the classe?
# To huge to draw this
# featurePlot(x=trainSet[, -classeIndex],y=as.numeric(trainSet$classe),plot="pairs")

correlations <- cor(trainSet[, -classeIndex], as.numeric(trainSet$classe))
tail(sort(correlations),5)

# Now, let us check if any of the columns are related to each other, if so, we will remove them
# top 2 correlations are -  magnet_arm_x, pitch_forearm

# Fig 1 - Density plot of these columns with "classe" column
p1 <- qplot(pitch_forearm,color=classe,data=trainSet,geom="density")
p2 <- qplot(magnet_arm_x,color=classe,data=trainSet,geom="density")
multiplot(p1,p2,cols=2)

# We cannot see clearly any relationship with these 2 highly related columns
# Probably we cannot select our columns by just seeing these columns correlation individually

## Model selection 

# # Let's identify variables with high correlations amongst each other in our set, so we can possibly exclude them from the pca or training.
# # We will check afterwards if these modifications to the dataset make the model more accurate (and perhaps even faster)
# 
# 
# library(corrplot)
# correlationMatrix <- cor(trainSet[, -classeIndex])
# highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.9, exact=TRUE)
# excludeColumns <- c(highlyCorrelated, classeIndex)
# corrplot(correlationMatrix, method="color", type="lower", order="hclust", tl.cex=0.70, tl.col="black", tl.srt = 45, diag = FALSE)

# Let us use PCA to reduce the number of columns
pcaPProc <- preProcess(trainSet[, -classeIndex], method = "pca", thresh = 0.99)
trainPCA <- predict(pcaPProc, trainSet[, -classeIndex])
dim(trainPCA)
validationPCA <- predict(pcaPProc, validationSet[, -classeIndex])
testPCA <- predict(pcaPProc, testingFinal[, -classeIndex])


# Random Forest training.
# We are using different number of trees 30,60,90,120 on testSet without PCA and testSet with PCA 
# and checking the accuracy.

PCAAccuracyTable<-c()
for (ntree in seq(30, 60, by = 30))
{
rfFinal <- randomForest(
    x=trainSet[, -classeIndex], 
    y=trainSet$classe,
    xtest=validationSet[, -classeIndex], 
    ytest=validationSet$classe, 
    ntree=ntree,
    keep.forest=TRUE,
    proximity=TRUE)

rfFinalTrainAcc <- round(1-sum(rfFinal$confusion[, 'class.error']),3)
print(paste0("Accuracy on trainsEt(Without PCA) with Trees- ",ntree," is: ",rfFinalTrainAcc))
rfFinalTestAcc <- round(1-sum(rfFinal$test$confusion[, 'class.error']),3)
print(paste0("Accuracy on testsEt(Without PCA) with Trees- ",ntree," is: ",rfFinalTestAcc))

rfFinalPCA <- randomForest(
    x=trainPCA,
    y=trainSet$classe,
    xtest=validationPCA,
    ytest=validationSet$classe,
    ntree=ntree,
    keep.forest=TRUE,
    proximity=TRUE)
rfFinalPCATrainAcc <- round(1-sum(rfFinalPCA$confusion[, 'class.error']),3)
print(paste0("Accuracy on trainsEt(with PCA) with Trees- ",ntree," is: ",rfFinalPCATrainAcc))
rfFinalPCATestAcc <- round(1-sum(rfFinalPCA$test$confusion[, 'class.error']),3)
print(paste0("Accuracy on testsEt(with PCA) with Trees- ",ntree," is: ",rfFinalPCATestAcc))

PCAAccuracyTable <- rbind(PCAAccuracyTable,c(ntree,rfFinalTrainAcc,rfFinalTestAcc,rfFinalPCATrainAcc,rfFinalPCATestAcc))
}
colnames(PCAAccuracyTable) <- c("# of tress","Test Accuracy(Non PCA)", "Train Accuracy(Non PCA)","Test Accuracy(PCA)", "Train Accuracy(PCA)")
PCAAccuracyTable

# ## Model selection
# 
# Based on the list of accuracy, we can say that PCA is not helping us much in this, except for reducing
# number of components. Also, with trees=60 gives us the best accuracy for test as well as train set. Increasing further is not increasing the accuracy.
# So we select a model without PCA and with number of trees = 60

ntree <- 60
rfFinal <- randomForest(
    x=trainSet[, -classeIndex], 
    y=trainSet$classe,
    xtest=validationSet[, -classeIndex], 
    ytest=validationSet$classe, 
    ntree=ntree,
    keep.forest=TRUE,
    proximity=TRUE) #do.trace=TRUE

rfFinalPCA <- randomForest(
    x=trainPCA,
    y=trainSet$classe,
    xtest=validationPCA,
    ytest=validationSet$classe,
    ntree=ntree,
    keep.forest=TRUE,
    proximity=TRUE) 

rfFinalTrainAcc <- round(1-sum(rfFinal$confusion[, 'class.error']),3)
print(paste0("Accuracy on trainsEt(Without PCA) with Trees- ",ntree," is: ",rfFinalTrainAcc))
rfFinalTestAcc <- round(1-sum(rfFinal$test$confusion[, 'class.error']),3)
print(paste0("Accuracy on testsEt(Without PCA) with Trees- ",ntree," is: ",rfFinalTestAcc))
rfFinal
# ## Conclusion
# 
# This concludes that nor PCA s not helping us much in this, except for reducing
# number of components. So we will select model without PCA and with number of trees = 60 which has a test accuracy of
# 0.989 and train accuracy of 0.982 and OOB estimate of  error rate: 0.34%
# 

# Before doing the final prediction we will examine the chosen model more in depth using some plots


par(mfrow=c(1,2)) 
varImpPlot(rfFinal, cex=0.7, pch=16, main='Variable Importance Plot: rfFinal')
plot(rfFinal,cex=0.7, main='Error vs No. of trees plot')
par(mfrow=c(1,1)) 

# Test results
# 
# Although we've chosen the `rfFinal` it's still nice to see what the model with PCA would predict on the final test set.
# Let's look at predictions for all models on the final test set. 

cleaned=as.data.frame(predict(rfFinal, testingFinal), optional=TRUE)
pcaAll=as.data.frame(predict(rfFinalPCA, testPCA), optional=TRUE)
predictions <- t(cbind(
    cleaned=as.data.frame(predict(rfFinal, testingFinal), optional=TRUE),
    pcaAll=as.data.frame(predict(rfFinalPCA, testPCA), optional=TRUE)
))
predictions

# The predictions don't really change a lot with each model, but since we have most faith in the `rfFinal`, we'll keep that as final answer. 

