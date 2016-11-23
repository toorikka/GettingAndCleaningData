# Getting and Cleaning Data Project Assignment 
### Week 4

## About this project

This project is about collecting, manipulating and cleaning a data set created by Smartlab. The goal of this assignment is to prepare tidy data from a large data set for later analysis. 
The original data set description can be found in http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names



## Collection of the raw data

It is assumed that the Samsung data is in your working directory before running the script.  
The files can be obtained by manually downloading and unzipping from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Or for example by the following method (you can use the file names and structures of your choise):
 ```{r}
if(!file.exists("./GettingAndCleaningData")) dir.create("./GettingAndCleaningData")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Samsungdata.zip")
listZip <- unzip("./Samsungdata.zip", exdir = "./GettingAndCleaningData")

## And then for working with the script and the data, set your working directory appropriately, e.g.:
setwd("./GettingAndCleaningData/UCI HAR Dataset")  ## or path of your choise
 ```

## Description of the original data

The original dataset consists of multiple txt files. After the unzipping, the file structure is as follows:  
- UCI HAR Dataset (dir)
	+ activity_labels.txt
	+ features.txt
	+ feature_info.txt
	+ Test (dir)
		+ subject_test.txt
		+ X_test.txt
		+ Y_test.txt
		+ Inertia Signals (dir)
			Several files which are not of importance in this assingment
	+ Train (dir)
		+ subject_train.txt
		+ X_train.txt
		+ Y_train.txt
		+ Inertia Signals (dir)
			Several files which are not of importance in this assingment


For this assignment, we use the following files:   
**activity_labels.txt**: contains the numeric and textual values for each activity performed by the test subjects (1- WALKING, 2- WALKING_UPSTAIRS, 3- WALKING_DOWNSTAIRS, 4- SITTING, 5- STANDING, 6- LAYING).  
**features.txt**: contains the names of each feature variable. There are 561 features.  

**subject_test.txt**: contains an id for each person/subject used in the experiment. With unique() we can see that there are 9 subjects in this set (of total 30).  
**X_test.txt**: the actual data/observations of each feature. There are 561 features and this table has a separate column for each feature/variable observation outcome (for all measured subjects and activities).    
**Y_test.txt**: the activities performed by each subject. This table has 2947 observations/rows. Each row represent an activity measurement performed by each test group subject and the same activity is performed multiple times by one person. 

**subject_train.txt**: contains an id for each person/subject used in the experiment.  With unique() we can see that there are 21 subjects in this set(of total 30).   
**X_train.txt**: the actual data/observations of each feature. There are 561 features and this table has a separate column for each feature/variable observation outcome (for all measured subjects and activities).    
**Y_train.txt**: the activities performed by each subject. This table has 7352 observations/rows. Each row represents an activity measurement performed by each train group subject (multiple times per one person). 

The ids range from 1 to 30, so there are 30 different persons in the test and train group together.  
According to the instructions by Dave Hood, the Inertia folder data is not needed (reference: https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/)  
We don't need to manipulate the source data further (no missing/strange values), or decompose the variables (see above reference) so we can work with them as they are.  

## Data manipulation tasks performed on the raw data

The following steps were performed to tidy the data up in the order logical to me.   
See the README.md document for the explanation of how the steps/script works, with some visualization examples.

1. First we read all the above mentioned files into R and studied their content.

2. Then we combined test & train subject, -activity and -feature data pieces together, keeping test and train data order the same in all merges to keep the data values and their order intact.
```{r}
> dim(allsubjects)
[1] 10299     1
> dim(allactivities)
[1] 10299     1
> dim(alldata)
[1] 10299   561
```

3. We extracted the 561 different features from the 'featurenames' into a character vector for column naming purposes.

4. We added these descriptive feature variable names to the datafile (alldata) to make the feature column names understandable, to tell what each column measure is about.
(The data set description below gives more in depth information on the functionality of each feature variable).

5. We combined the subject and activity information with the 'alldata' data set to create one set.
In tidy data, fixed variables should come first, followed by measured variables, hence added subject and activity information into the beginning.

6. Labelled also the fixed data columns (SubjectID & Activity) with descriptive variable names.
```{r}
> comb[1:2, 1:3]
  SubjectID Activity tBodyAcc-mean()-X
1         2        5         0.2571778
2         2        5         0.2860267
```


7. Extracted the data so that only the observations of the mean() and std() were subsetted from the original data set. 
We conciously narrowed the feature measurements down to mean() and std() measurements leaving meanFreq() and the angle(xxxgravityMean) measurements out. 
(As per discussions, it is not clear whether they should be in or not so we decided not to include them for this assignment).  
Hence we ended up having 66 different feature variables in the processed data set + subject and activity.
```{r}
> dim(subdata)
[1] 10299    68
```


8. Added descriptive activity names for the activities in the 'Activity' column in the data set (see variable description below for values).

9. From the subsetted data set, we created a second, independent tidy data set with the average of each variable _for each activity and each subject_.  
In the new tidy data set created for our project, each subject has now only one activity for which each feature average is calculated.  
The processed data set contains now 180 rows and 68 columns.
```{r}
> dim(meandata)
[1] 180  68
```

10. Finally we wrote the outcome into a new tidy data set text file which can be used for later data analysis.

## Processed Data Set description

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity.
The features/measurement variables selected for this dataset come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. 

Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (prefix 'f' to indicate frequency domain signals). 
  
These signals were used to estimate variables of the feature vector for each pattern: '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
  
***
In the resulting, processed data set we provide the average measurement value of all mean (excluding meanFrequency and angle mean calculations) and standard deviation calculations of the features for each subject and for each activity they performed.
  
The tidy data text file has 180 observations and 68 columns, each column representing a unique variable and each row representing a single observation.
There are also headings in the text file to identify the columns.

You can read the tidy data file into R by: 
 ```{r}
 read.table("tidyDataSet.txt", header=TRUE, check.names = FALSE)
  ```

## Description of the variables in the processed data set

### Units

- The units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2).
- The gyroscope units are rad/sec.
- The subject units are numbers between 1-30
- The activity units
 are Walking, Walking_Upstairs, Walking_Downstairs, Sitting, Standing, Laying


### Variables

 Variable                          | Unit/class                   | Explanation                                                   
---------------------------------- | ---------------------------- | -------------  
[1] SubjectID       		   | integer			  | The ID of a subject participating in the experiment. Unit is an integer between 1-30.  
[2] Activity                 	   | character string		  | The activity performed by each subject. Activities performed are Walking, Walking_Upstairs, Walking_Downstairs, Sitting, Standing, Laying
  				   |  				  |  
[3] tBodyAcc-mean()-X              | numeric, floating point unit | Mean value of body acceleration signals in time domain for X axis
[4] tBodyAcc-mean()-Y		   | numeric, floating point unit | Mean value of body acceleration signals in time domain for Y axis
[5] tBodyAcc-mean()-Z 	           | numeric, floating point unit | Mean value of body acceleration signals in time domain for Z axis  
[6] tBodyAcc-std()-X     	   | numeric, floating point unit | Standard deviation of body acceleration signals in time domain for X axis  
[7] tBodyAcc-std()-Y        	   | numeric, floating point unit | Standard deviation of body acceleration signals in time domain for Y axis  
[8] tBodyAcc-std()-Z        	   | numeric, floating point unit | Standard deviation of body acceleration signals in time domain for Z axis  
				   |  				  |    			
[9] tGravityAcc-mean()-X           | numeric, floating point unit | Mean value of gravity acceleration signals in time domain for X axis  
[10] tGravityAcc-mean()-Y          | numeric, floating point unit | Mean value of gravity acceleration signals in time domain for Y axis  
[11] tGravityAcc-mean()-Z          | numeric, floating point unit | Mean value of gravity acceleration signals in time domain for Z axis  
[12] tGravityAcc-std()-X           | numeric, floating point unit | Standard deviation of gravity acceleration signals in time domain for X axis 
[13] tGravityAcc-std()-Y           | numeric, floating point unit | Standard deviation of gravity acceleration signals in time domain for Y axis 
[14] tGravityAcc-std()-Z           | numeric, floating point unit | Standard deviation of gravity acceleration signals in time domain for Z axis 
				   |  				  |   		
[15] tBodyAccJerk-mean()-X         | numeric, floating point unit | Mean value of body acceleration jerk signals in time domain for X axis  
[16] tBodyAccJerk-mean()-Y         | numeric, floating point unit | Mean value of body acceleration jerk signals in time domain for Y axis  
[17] tBodyAccJerk-mean()-Z         | numeric, floating point unit | Mean value of body acceleration jerk signals in time domain for Z axis  
[18] tBodyAccJerk-std()-X          | numeric, floating point unit | Standard deviation body acceleration jerk signals in time domain for X axis  
[19] tBodyAccJerk-std()-Y          | numeric, floating point unit | Standard deviation body acceleration jerk signals in time domain for Y axis  
[20] tBodyAccJerk-std()-Z          | numeric, floating point unit | Standard deviation body acceleration jerk signals in time domain for Z axis  
				   |  				  |  
[21] tBodyGyro-mean()-X  	   | numeric, floating point unit | Mean value of body gyroscopic angular velocity signals in time domain for X axis  
[22] tBodyGyro-mean()-Y  	   | numeric, floating point unit | Mean value of body gyroscopic angular velocity signals in time domain for Y axis 
[23] tBodyGyro-mean()-Z            | numeric, floating point unit | Mean value of body gyroscopic angular velocity signals in time domain for Z axis  
[24] tBodyGyro-std()-X             | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity signals in time domain for X axis 
[25] tBodyGyro-std()-Y             | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity signals in time domain for Y axis  
[26] tBodyGyro-std()-Z             | numeric, floating point unit | Standard deviation of body gyroscopic signals in time domain for Z axis  
				   |  				  |    
[27] tBodyGyroJerk-mean()-X        | numeric, floating point unit | Mean value of body gyroscopic angular velocity jerk signals in time domain for X axis  
[28] tBodyGyroJerk-mean()-Y        | numeric, floating point unit | Mean value of body gyroscopic angular velocity jerk signals in time domain for Y axis  
[29] tBodyGyroJerk-mean()-Z        | numeric, floating point unit | Mean value of body gyroscopic angular velocity jerk signals in time domain for Z axis  
[30] tBodyGyroJerk-std()-X         | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity jerk signals in time domain for X axis 
[31] tBodyGyroJerk-std()-Y         | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity jerk signals in time domain for Y axis
[32] tBodyGyroJerk-std()-Z         | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity jerk signals in time domain for Z axis
  				   |  				  |    
[33] tBodyAccMag-mean()            | numeric, floating point unit | Mean value of body acceleration signal magnitude in time domain
[34] tBodyAccMag-std()             | numeric, floating point unit | Standard deviation of body acceleration signal magnitude in time domain
  				   |  				  |    
[35] tGravityAccMag-mean()         | numeric, floating point unit | Mean value of gravity acceleration Jerk signal magnitude in time domain
[36] tGravityAccMag-std()          | numeric, floating point unit | Standard deviation of gravity acceleration Jerk signal magnitude in time domain
  				   |  				  |    
[37] tBodyAccJerkMag-mean()        | numeric, floating point unit | Mean value of body acceleration jerk signal magnitude in time domain  
[38] tBodyAccJerkMag-std()         | numeric, floating point unit | Standard deviation of body acceleration jerk signal magnitude in time domain  
				   |  				  |   
[39] tBodyGyroMag-mean()           | numeric, floating point unit | Mean value of body gyroscopic angular velocity signal magnitude in time domain  
[40] tBodyGyroMag-std()            | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity signal magnitude in time domain  
				   |  				  |    
[41] tBodyGyroJerkMag-mean()       | numeric, floating point unit | Mean value of body gyroscopic angular velocity jerk signal magnitude in time domain  
[42] tBodyGyroJerkMag-std()        | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity jerk signal magnitude in time domain 
 				   | 				  |   
[43] fBodyAcc-mean()-X             | numeric, floating point unit | Mean value of body acceleration in frequency domain for X axis  
[44] fBodyAcc-mean()-Y             | numeric, floating point unit | Mean value of body acceleration in frequency domain for Y axis  
[45] fBodyAcc-mean()-Z             | numeric, floating point unit | Mean value of body acceleration in frequency domain for Z axis  
[46] fBodyAcc-std()-X              | numeric, floating point unit | Standard deviation of body acceleration in frequency domain for X axis  
[47] fBodyAcc-std()-Y        	   | numeric, floating point unit | Standard deviation of body acceleration in frequency domain for Y axis  
[48] fBodyAcc-std()-Z              | numeric, floating point unit | Standard deviation of body acceleration in frequency domain for Z axis  
				   |  				  |    
[49] fBodyAccJerk-mean()-X         | numeric, floating point unit | Mean value of body acceleration jerk in frequency domain for X axis  
[50] fBodyAccJerk-mean()-Y         | numeric, floating point unit | Mean value of body acceleration jerk in frequency domain for Y axis  
[51] fBodyAccJerk-mean()-Z   	   | numeric, floating point unit | Mean value of body acceleration jerk in frequency domain for Z axis  
[52] fBodyAccJerk-std()-X          | numeric, floating point unit | Standard deviation of body acceleration jerk in frequency domain for X axis  
[53] fBodyAccJerk-std()-Y          | numeric, floating point unit | Standard deviation of body acceleration jerk in frequency domain for Y axis  
[54] fBodyAccJerk-std()-Z          | numeric, floating point unit | Standard deviation of body acceleration jerk in frequency domain for Z axis  
				   |  				  |    
[55] fBodyGyro-mean()-X            | numeric, floating point unit | Mean value of body gyroscopic angular velocity signals in frequency domain for X axis  
[56] fBodyGyro-mean()-Y            | numeric, floating point unit | Mean value of body gyroscopic angular velocity signals in frequency domain for Y axis  
[57] fBodyGyro-mean()-Z            | numeric, floating point unit | Mean value of body gyroscopic angular velocity signals in frequency domain for Z axis  
[58] fBodyGyro-std()-X             | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity signals in frequency domain for X axis  
[59] fBodyGyro-std()-Y             | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity signals in frequency domain for Y axis  
[60] fBodyGyro-std()-Z             | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity signals in frequency domain for Z axis  
				   |  				  |    
[61] fBodyAccMag-mean()            | numeric, floating point unit | Mean value of body acceleration magnitude in frequency domain  
[62] fBodyAccMag-std()             | numeric, floating point unit | Standard deviation of body acceleration magnitude in frequency domain  
				   |  				  |   
[63] fBodyBodyAccJerkMag-mean()    | numeric, floating point unit | Mean value of body acceleration jerk signal magnitude in frequency domain  
[64] fBodyBodyAccJerkMag-std()     | numeric, floating point unit | Standard deviation of body acceleration jerk signal magnitude in frequency domain  
				   |  				  |    
[65] fBodyBodyGyroMag-mean()       | numeric, floating point unit | Mean value of body gyroscopic angular velocity signal magnitude in frequency domain  
[66] fBodyBodyGyroMag-std()        | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity signal magnitude in frequency domain 
 				   |  				  |    
[67] fBodyBodyGyroJerkMag-mean()   | numeric, floating point unit | Mean value of body gyroscopic angular velocity jerk signal magnitude in frequency domain  
[68] fBodyBodyGyroJerkMag-std()    | numeric, floating point unit | Standard deviation of body gyroscopic angular velocity jerk signal magnitude in frequency domain  



## Source and more information on the project:

The source of the data and more details on the project, on which this data set was based, can be found from:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

For further detailed referece, see http://www.tdx.cat/bitstream/handle/10803/284725/TJLRO1de1.pdf?sequence=1&isAllowed=y)

Instructions for the assingment project: https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/