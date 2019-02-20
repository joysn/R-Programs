library(lattice)
library(ggplot2)
library(plyr)
library(randomForest)


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
str(trainingFinal)

# We have 3 columns related to time, raw_timestamp_part_1, raw_timestamp_part_2, cvtd_timestamp and 
removeColumns <- grep("timestamp", names(trainingStep1))
trainingFinal <- trainingFinal[,-c(1, removeColumns )]
testingFinal <- testingFinal[,-c(1, removeColumns )]
# Now we have 54 - 1, columns now to chose predictor from
str(trainingFinal)

# # We convert 2 columns with factors to number format - user_name, new_window
# classeLevels <- levels(trainingStep2$classe)
# trainingStep3 <- data.frame(data.matrix(trainingStep2))
# trainingStep3$classe <- factor(trainingStep3$classe, labels=classeLevels)
# testingStep3 <- data.frame(data.matrix(testingStep2))
# str(trainingStep3)

# Finally set the dataset to be explored
#trainingFinal <- trainingStep1
testingFinal <- testingStep1

# ## Exploratory data analyses 

# Since the test set provided is the the ultimate validation set, 
# we will split the current training in a test (validation) and train set to work with.

set.seed(19791108)
library(caret)
classeIndex <- which(names(trainingFinal) == "classe")
partition <- createDataPartition(y=trainingFinal$classe, p=0.75, list=FALSE)
training.subSetTrain <- trainingFinal[partition, ]
training.subSetTest <- trainingFinal[-partition, ]

# What are some fields that have high correlations with the classe?

# To huge to draw this
# featurePlot(x=training.subSetTrain[, -classeIndex],y=as.numeric(training.subSetTrain$classe),plot="pairs")

correlations <- cor(training.subSetTrain[, -classeIndex], as.numeric(training.subSetTrain$classe))
bestCorrelations <- subset(as.data.frame(as.table(correlations)), abs(Freq)>0.3)
bestCorrelations

# Even the best correlations with classe are hardly above 0.3 ( magnet_arm_x, pitch_forearm )
# Let's check visually if there is indeed hard to use these 2 as possible simple linear predictors.

library(Rmisc)
library(ggplot2)
# p1 <- ggplot(training.subSetTrain, aes(classe,pitch_forearm)) + 
#     geom_boxplot(aes(fill=classe))
# p2 <- ggplot(training.subSetTrain, aes(classe, magnet_arm_x)) + 
#     geom_boxplot(aes(fill=classe))
# multiplot(p1,p2,cols=2)

p1 <- qplot(pitch_forearm,color=classe,data=training.subSetTrain,geom="density")
p2 <- qplot(magnet_arm_x,color=classe,data=training.subSetTrain,geom="density")
multiplot(p1,p2,cols=2)

# Clearly there is no hard seperation of classes possible using only these 'highly' correlated features.
# Let's train some models to get closer to a way of predicting these classe's

## Model selection 

# Let's identify variables with high correlations amongst each other in our set, so we can possibly exclude them from the pca or training. 
# We will check afterwards if these modifications to the dataset make the model more accurate (and perhaps even faster)


library(corrplot)
correlationMatrix <- cor(training.subSetTrain[, -classeIndex])
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.9, exact=TRUE)
excludeColumns <- c(highlyCorrelated, classeIndex)
corrplot(correlationMatrix, method="color", type="lower", order="hclust", tl.cex=0.70, tl.col="black", tl.srt = 45, diag = FALSE)

# We see that there are some features that aree quite correlated with each other.
# We will have a model with these excluded. Also we'll try and reduce the features by running PCA 
# on all and the excluded subset of the features


pcaPreProcess.all <- preProcess(training.subSetTrain[, -classeIndex], method = "pca", thresh = 0.99)
training.subSetTrain.pca.all <- predict(pcaPreProcess.all, training.subSetTrain[, -classeIndex])
training.subSetTest.pca.all <- predict(pcaPreProcess.all, training.subSetTest[, -classeIndex])
testing.pca.all <- predict(pcaPreProcess.all, testingFinal[, -classeIndex])

# Since PCA takes care of this part, we will not perform this part
pcaPreProcess.subset <- preProcess(training.subSetTrain[, -excludeColumns], method = "pca", thresh = 0.99)
training.subSetTrain.pca.subset <- predict(pcaPreProcess.subset, training.subSetTrain[, -excludeColumns])
training.subSetTest.pca.subset <- predict(pcaPreProcess.subset, training.subSetTest[, -excludeColumns])
testing.pca.subset <- predict(pcaPreProcess.subset, testingFinal[, -classeIndex])

# Now we'll do some actual Random Forest training.
# We'll use 200 trees, because I've already seen that the error rate doesn't decline a lot after say 50 trees,
# # but we still want to be thorough.
# Also we will time each of the 4 random forest models to see if when all else is equal one pops out as the faster one.



library(randomForest)
ntree <- 200 #This is enough for great accuracy (trust me, I'm an engineer). 
start <- proc.time()
rfMod.cleaned <- randomForest(
    x=training.subSetTrain[, -classeIndex], 
    y=training.subSetTrain$classe,
    xtest=training.subSetTest[, -classeIndex], 
    ytest=training.subSetTest$classe, 
    ntree=ntree,
    keep.forest=TRUE,
    proximity=TRUE) #do.trace=TRUE
proc.time() - start
# start <- proc.time()
# rfMod.exclude <- randomForest(
#     x=training.subSetTrain[, -excludeColumns], 
#     y=training.subSetTrain$classe,
#     xtest=training.subSetTest[, -excludeColumns], 
#     ytest=training.subSetTest$classe, 
#     ntree=ntree,
#     keep.forest=TRUE,
#     proximity=TRUE) #do.trace=TRUE
proc.time() - start
start <- proc.time()
rfMod.pca.all <- randomForest(
    x=training.subSetTrain.pca.all, 
    y=training.subSetTrain$classe,
    xtest=training.subSetTest.pca.all, 
    ytest=training.subSetTest$classe, 
    ntree=ntree,
    keep.forest=TRUE,
    proximity=TRUE) #do.trace=TRUE
proc.time() - start
start <- proc.time()
rfMod.pca.subset <- randomForest(
    x=training.subSetTrain.pca.subset, 
    y=training.subSetTrain$classe,
    xtest=training.subSetTest.pca.subset, 
    ytest=training.subSetTest$classe, 
    ntree=ntree,
    keep.forest=TRUE,
    proximity=TRUE) #do.trace=TRUE
proc.time() - start

# ## Model examination
# 
# Now that we have 4 trained models, we will check the accuracies of each.
# (There probably is a better way, but this still works good)

rfMod.cleaned
rfMod.cleaned.training.acc <- round(1-sum(rfMod.cleaned$confusion[, 'class.error']),3)
paste0("Accuracy on training: ",rfMod.cleaned.training.acc)
rfMod.cleaned.testing.acc <- round(1-sum(rfMod.cleaned$test$confusion[, 'class.error']),3)
paste0("Accuracy on testing: ",rfMod.cleaned.testing.acc)
# rfMod.exclude
# rfMod.exclude.training.acc <- round(1-sum(rfMod.exclude$confusion[, 'class.error']),3)
# paste0("Accuracy on training: ",rfMod.exclude.training.acc)
# rfMod.exclude.testing.acc <- round(1-sum(rfMod.exclude$test$confusion[, 'class.error']),3)
# paste0("Accuracy on testing: ",rfMod.exclude.testing.acc)
rfMod.pca.all
rfMod.pca.all.training.acc <- round(1-sum(rfMod.pca.all$confusion[, 'class.error']),3)
paste0("Accuracy on training: ",rfMod.pca.all.training.acc)
rfMod.pca.all.testing.acc <- round(1-sum(rfMod.pca.all$test$confusion[, 'class.error']),3)
paste0("Accuracy on testing: ",rfMod.pca.all.testing.acc)
rfMod.pca.subset
rfMod.pca.subset.training.acc <- round(1-sum(rfMod.pca.subset$confusion[, 'class.error']),3)
paste0("Accuracy on training: ",rfMod.pca.subset.training.acc)
rfMod.pca.subset.testing.acc <- round(1-sum(rfMod.pca.subset$test$confusion[, 'class.error']),3)
paste0("Accuracy on testing: ",rfMod.pca.subset.testing.acc)


# ## Conclusion
# 
# This concludes that nor PCA doesn't have a positive of the accuracy (or the process time for that matter)
# The `rfMod.exclude` perform's slightly better then the 'rfMod.cleaned'
# 
# We'll stick with the `rfMod.exclude` model as the best model to use for predicting the test set.
# Because with an accuracy of 98.7% and an estimated OOB error rate of 0.23% this is the best model.
# 
# 
# Before doing the final prediction we will examine the chosen model more in depth using some plots


par(mfrow=c(1,2)) 
varImpPlot(rfMod.exclude, cex=0.7, pch=16, main='Variable Importance Plot: rfMod.exclude')
plot(rfMod.exclude,cex=0.7, main='Error vs No. of trees plot')
par(mfrow=c(1,1)) 

# To really look in depth at the distances between predictions we can use MDSplot and cluster predictiosn and results

start <- proc.time()
library(RColorBrewer)
palette <- brewer.pal(length(classeLevels), "Set1")
rfMod.mds <- MDSplot(rfMod.exclude, as.factor(classeLevels), k=2, pch=20, palette=palette)
library(cluster)
rfMod.pam <- pam(1 - rfMod.exclude$proximity, k=length(classeLevels), diss=TRUE)
plot(
    rfMod.mds$points[, 1], 
    rfMod.mds$points[, 2], 
    pch=rfMod.pam$clustering+14, 
    col=alpha(palette[as.numeric(training.subSetTrain$classe)],0.5), 
    bg=alpha(palette[as.numeric(training.subSetTrain$classe)],0.2), 
    cex=0.5,
    xlab="x", ylab="y")
legend("bottomleft", legend=unique(rfMod.pam$clustering), pch=seq(15,14+length(classeLevels)), title = "PAM cluster")
legend("topleft", legend=classeLevels, pch = 16, col=palette, title = "Classification")
proc.time() - start

# # Test results
# 
# Although we've chosen the `rfMod.exclude` it's still nice to see what the other 3 models would predict on the final test set.
# Let's look at predictions for all models on the final test set. 

predictions <- t(cbind(
    #exclude=as.data.frame(predict(rfMod.exclude, testingFinal[, -excludeColumns]), optional=TRUE),
    cleaned=as.data.frame(predict(rfMod.cleaned, testingFinal), optional=TRUE),
    pcaAll=as.data.frame(predict(rfMod.pca.all, testing.pca.all), optional=TRUE),
    pcaExclude=as.data.frame(predict(rfMod.pca.subset, testing.pca.subset), optional=TRUE)
))
predictions

# The predictions don't really change a lot with each model, but since we have most faith in the `rfMod.exclude`, we'll keep that as final answer. 

