# Getting and Cleaning Data 
## Week 4 project assignment

This project is about collecting, manipulating and cleaning a data set.
The goal of this assignment is to prepare tidy data set from a large data set (multiple files) for later analysis.

The repo for this project in Github shall contain:
- a tidy data set text file (tidyDataSet.txt) composed as described below 
- a script (run_analysis.R) for performing the analysis 
- codeBook.md that describes the data content, the variables, and the manipulation steps that were performed to clean up the original data
- README.md (this document) that explains how the scripts works


The aim is to create an R script called run_analysis.R that does the following:

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement.
    Uses descriptive activity names to name the activities in the data set.
    Appropriately labels the data set with descriptive variable names.
    Creates a second, independent tidy data set with the average of each variable - for each activity and each subject.


****
**NOTE**: The prerequisite is that the `reshape2` package is installed before running the script!  
This script must be reusable for all users, and since package installation may produce warnings/errors due to different reasons (different R version, non-administrative users, etc.),
we decided not to include the package installation function in the script, after all.

You can check if the package exisits, and install it, for example with the following command:
```{r]
if(!require(reshape2)) install.packages("reshape2")
```
(PS: if you run this command, at the end of the execution, `require` will throw its' warning message of not being able to load the package. The 'run_analysis.R' has the library(reshape2) function to load the package during the script execution.)

***
Original data for the project can be obtained from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

codeBook.md explains how you can download the source files. They are not part of this script because the script must be reproducible in all operating systems/machines/user environments. 


You can dowload my code by cloning my github repo or by simply copying it manually.
The working directory for the scipt will be the data file directory 'UCI HAR Dataset' so remember to `setwd()` your
working directory properly before running the script in R.

You can run the script by storing it into the same folder with the Samsung data (UCI HAR Dataset folder) and running in R the with following command:
```{r]
source("run_analysis.R")
```

## Description of how the run_analysis.R script works

The script reads with `read.table` all the required original files (as listed in the codeBook.md) into R.

There are separate files for variables: subjects performing the test, the activities performed by the subjects, and the measured features in the experiment. In addition there are files for the actual values of the feature measurements.
In the original data, the subjects activities and measurements were divided in two groups, test and train group, so the script combines with `rbind` these test & train subject, -activity and -feature data pieces together.

The script extracts the different features into a character vector for column naming and then adds the names to the measurement data variables to make the feature column names understandable.
The script combines with `cbind` the subject and activity information with the actual measurement data to make one big data frame and labels also the fixed data columns (subject, activity) with descriptive variable names.

From all the features in the combined data set, the script extracts only the measurements on the mean() and std() for each measurement.
The script also adds descriptive activity names for the activities column in the data set.

From the subsetted data set, the script creates a second, independent tidy data set with the average of each variable for each activity and each subject.
The script utilizes functions in `reshape2` package to perform this manipulation: it first uses `melt` function to formulate the data into a narrow form, treating SubjectID and Activity are as keys- the unique variables for which the calculations are done. All the feature coiumns will be stored as a variable column whose value we are eventually averaging.
Then the script uses `dcast` to calculate the average/mean of these feature variable values for each unique SubjectID + Activity pair and converts the feature variable columns back into a wide form data frame.  
In the new tidy data set, each subject has only one activity for which each feature average is calculated:

Finally the script writes the outcome into a new tidy data set text file for later analysis.

***
You can read the dataset back into R using:
```{r]
read.table("tidyDataSet.txt", header=TRUE, check.names = FALSE) 
## check.names=FALSE allows R to keep the parenthesis in the feature variable names also when reading data back
```
***


