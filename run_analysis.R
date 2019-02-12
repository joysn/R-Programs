#####################################################################################
# Course 3, Week 4:- Peer-graded Assignment: Getting and Cleaning Data Course Project
#####################################################################################


#######################
# Step 0: Load Packages
#######################
# install.packages("data.table")
library("data.table")
# install.packages("reshape2")
library("reshape2")


########################################
# Step 1: Download and unzip the dataset
########################################
my_path <- getwd()
remote_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
downloaded_zip_file = "accelerometer_samsung.zip"
download.file(remote_url, file.path(my_path, downloaded_zip_file))
unzip(zipfile = downloaded_zip_file)


####################################################
# Step 2: Get the wanted feature list and its labels
####################################################
# 2.a) Load activity labels & features
features <- read.table(file.path(my_path, "UCI HAR Dataset/features.txt"), col.names = c("index", "featureNames"))
activityLabels <- read.table(file.path(my_path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("classLabels", "activityName"))
# 2.b) Get the list(index) of features which has only mean/std in it
finalFeatureIdx <- grep("(mean|std)\\(\\)", features$featureNames)
# 2.c) Get the names of those wanted features
finalFeatureName <- features[finalFeatureIdx, "featureNames"]
# 2.d) Remove () from the feature names
finalFeatureName <- gsub('[()]', '', finalFeatureName)


###########################
# Step 3: Load Data (TRAIN)
###########################
X_train <- read.table(file.path(my_path, "UCI HAR Dataset/train/X_train.txt"))[, finalFeatureIdx]
setnames(X_train, colnames(X_train), finalFeatureName)
A_train <- read.table(file.path(my_path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity"))
S_train <- read.table(file.path(my_path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("SubjectNum"))
train <- cbind(S_train, A_train, X_train)


##########################
# Step 4: Load Data (TEST)
##########################
X_test <- read.table(file.path(my_path, "UCI HAR Dataset/test/X_test.txt"))[, finalFeatureIdx]
setnames(X_test, colnames(X_test), finalFeatureName)
A_test <- read.table(file.path(my_path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("Activity"))
S_test <- read.table(file.path(my_path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("SubjectNum"))
test <- cbind(S_test, A_test, X_test)


############################
# Step 5: Merge TRAIN & TEST
############################
final_ds <- rbind(train, test)


######################################################################################
# Step 6: Create factors - Activity and Subject 
# Hint - data set with the average of each variable for each activity and each subject
# Hint - descriptive activity names to name the activities
######################################################################################
# 6.a - Rename and factor
final_ds[["Activity"]] <- factor(final_ds[, "Activity"], levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])

final_ds[["SubjectNum"]] <- as.factor(final_ds[, "SubjectNum"])
# 6.b Melt and reshape
final_ds <- reshape2::melt(data = final_ds, id = c("SubjectNum", "Activity"))
final_ds <- reshape2::dcast(data = final_ds, SubjectNum + Activity ~ variable, fun.aggregate = mean)


#######################################
# Step 7: Create the final dataset file
#######################################
write.table(x = final_ds, file = "tidyData4.txt", quote = FALSE,row.names = FALSE)