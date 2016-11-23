## This script reads the raw data files from the Smartlab experiment, combines the files and 
## produces a tidy data set showing the average of each mean() and std() variable for each 
## activity and each subject in the experiment.

## 'reshape2' package should exist before running this script
if(!require(reshape2)){
  stop("*****Please, install reshape2 package before running the script!*****")
}else{

## -----reading data-----##
    
activity <- read.table("activity_labels.txt") ## activity names
featurenames <- read.table("features.txt", stringsAsFactors=FALSE)  ## feature/variable names

testsubject <- read.table("./test/subject_test.txt") ## test group subjects
xtest <- read.table("./test/X_test.txt")  ## test group data
ytest <- read.table("./test/Y_test.txt")  ## test group activities

trainsubject <- read.table("./train/subject_train.txt")  ## train group subjects
xtrain <- read.table("./train/X_train.txt") ## train group data
ytrain <- read.table("./train/Y_train.txt")  ## train group activitities

## Combine test & train sets' subject, activity and feature data together
allsubjects <- rbind(testsubject, trainsubject)
allactivities <- rbind(ytest, ytrain)
alldata <- rbind(xtest, xtrain)

##-----labeling and subsetting-----##

## Extract the features from the 'featurenames' into a character vector for column naming
names = c(featurenames[,2])

## Add descriptive variable names for feature data
colnames(alldata) = names 

## Add the subject (allsubjects) and activity (allactivities) information into the 'alldata' dataset.
comb <- cbind(allsubjects, allactivities, alldata) 

## Label also the fixed variable columns with descriptive names
colnames(comb)[1:2]<-c("SubjectID", "Activity")  

## Extract only the measurements on the mean() and std() for each measurement (keeping SubjectID and Activity)
subdata <- comb[grep('SubjectID|Activity|mean\\(\\)|std\\(\\)', names(comb))]

##-----rename activities-----##

## Add descriptive activity names for the the activities in the data set.
subdata[,2] <- ifelse(subdata[,2] == 1, "Walking", ifelse(subdata[,2] == 2, "Walking_Upstairs", ifelse(subdata[,2] == 3, "Walking_Downstairs", ifelse(subdata[,2] == 4, "Sitting", ifelse(subdata[,2] == 5, "Standing", ifelse(subdata[,2] == 6, "Laying", "not valid activity"))))))

##-----aggregate data-----##

## Create a second, independent tidy data set with the average of each variable for each activity and each subject
library(reshape2)

## Melt the subdata df treating subject and activity as keys variables for which the calculations are done, 
## all the other columns/features will be used as a variable whose mean value we are eventually interested in
tempmelt <- melt(subdata, id=c("SubjectID", "Activity"))

## Calculate the average/mean of these variables for each unique SubjectID + Activity pair
meandata <- dcast(tempmelt, SubjectID+Activity ~ variable, mean)

##-----save tidy data-----##

## Write the outcome into a new tidy dataset for later analysis
write.table(meandata, "tidyDataSet.txt", row.names=FALSE, quote=FALSE)
}




