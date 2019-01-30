Getting and Cleaning Data - Week 4 Assignment

Data Description
The project taps into the area of wearable computing, where a number of big brands compete to develop clever algorithms. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Further information on the Dataset and the variables collected can be found in the file CodeBook.md

Dataset

•	'README.txt'

•	'features_info.txt': Shows information about the variables used on the feature vector.

•	'features.txt': List of all features.

•	'activity_labels.txt': Links the class labels with their activity name.

•	'train/X_train.txt': Training set.

•	'train/y_train.txt': Training labels.

•	'test/X_test.txt': Test set.

•	'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
•	'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

•	'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

•	'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

•	'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

Transformations carried out to move from the Raw Data to the Tidy data: 
1. First step was to load any required packages
o	library(dplyr)
o	library(data.table)
o	library(tidyr)

2. Next step was to Download all of the data outlined above from the link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The following code was used to do this:
	
#Download the zipped dataset
		filename <- "Coursera_DS3_Final.zip"
	# Check if archive already exists.
	if (!file.exists(filename)){
  		fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  		download.file(fileURL, filename)
		}  
	# Check if folder exists
		if (!file.exists("UCI HAR Dataset")) { 
		  unzip(filename) 
		}

3. I then imported and assigned all of the various data tables and named them accordingly
# Code to import and assign all of the tables
	features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
	activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
	test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
	train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
	x_test <- read.table("UCI HAR Dataset/test/x_test.txt")
	colnames(x_test) <- (features$features)
	y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
	x_train <- read.table("UCI HAR Dataset/train/x_train.txt")
	colnames(x_train) <- (features$features)
	y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


4. The next step was to merge the training and test databases, and combine all 3 of the data sets into one. 
•	x_data - contains all of the various different readings from the sensor signals (accelerometer and gyroscope) for the train and test data
•	y-data - is the list of activity codes in each row corresponding to each of the measurements in x_data
•	subject_data - is the list of subjects in each row corresponding to the activity code and each of the measurements in x_data
#code  to merge all of the data
	x_data <- rbind(x_train, x_test)
	y_data <- rbind(y_train, y_test)
	subject_data <- rbind(test, train)

	Combined_data <- cbind(subject_data, y_data, x_data)

When all are combined in Combined_data we have a data set with for each subject and each activity a corresponding 561 different measurements relating to inertial signals

5.  The next part of the code extracts only the measurements on the mean and standard deviation for each measurement.
•	From the list of all variables measured, took any feature where the name includes either mean or std.
•	Then from the Combined_data set created above, extract only the columns that are on this list of having either mean or std
#extract only the mean and standard deviation for each measurement	
DatawithMeanSD <- grep("mean\\(\\)|std\\(\\)",features$features,value=TRUE) #list of variables that contain mean and Std Dev
TidyData <- Combined_data[,c("subject","code", DatawithMeanSD)] #take the subset of variables that contain mean and std dev along with subject and activity code


6. Using the activity description names - merged these on to the data set so we know what each of the activity codes refers to.

#add on the Activity information to the data so we know if its walking, running etc..
TidyData <- merge(TidyData, activities, by = "code") 
TidyData <- TidyData[,c("subject","code", "activity", DatawithMeanSD)] #reorder the columns so that activity description is to the front of the dataset

7.Need to appropriately label the dataset with descriptive variable names. First view the contents of the data set in order to determine how we should adjust the names
	
	head(str(TidyData),2)

This shows us the following information...
 
data.frame':	10299 obs. of  69 variables:
 $ subject                    : int  12 10 12 8 12 12 18 12 25 18 ...
 $ code                       : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity                   : Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
 $ tBodyAcc-mean()-X          : num  0.302 0.343 0.27 0.268 0.314 ...
 $ tBodyAcc-mean()-Y          : num  -0.02688 -0.00343 0.01091 -0.01273 -0.0087 ...
 $ tBodyAcc-mean()-Z          : num  -0.0958 -0.1015 -0.0749 -0.0937 -0.1246 ...
 $ tBodyAcc-std()-X           : num  -0.38 -0.201 -0.337 -0.384 -0.356 ...
 $ tBodyAcc-std()-Y           : num  -0.191 0.133 0.146 -0.204 -0.166 ...
 $ tBodyAcc-std()-Z           : num  0.341 -0.318 -0.446 0.148 0.407 ...
 $ tGravityAcc-mean()-X       : num  0.902 0.965 0.96 0.944 0.892 ...
 $ tGravityAcc-mean()-Y       : num  -0.137 -0.145 -0.214 -0.159 -0.147 ...
 $ tGravityAcc-mean()-Z       : num  -0.3428 0.0285 0.0505 -0.1425 -0.3414 ...
 $ tGravityAcc-std()-X        : num  -0.953 -0.984 -0.965 -0.981 -0.98 ...
 $ tGravityAcc-std()-Y        : num  -0.937 -0.953 -0.939 -0.973 -0.961 ...
 $ tGravityAcc-std()-Z        : num  -0.921 -0.99 -0.946 -0.966 -0.941 ...
 $ tBodyAccJerk-mean()-X      : num  0.1505 -0.1351 0.1262 -0.0358 -0.2256 ...
 $ tBodyAccJerk-mean()-Y      : num  -0.2391 -0.0637 0.2083 -0.0136 -0.0699 ...
 $ tBodyAccJerk-mean()-Z      : num  -0.1533 -0.2631 0.0773 0.2511 -0.0937 ...
 $ tBodyAccJerk-std()-X       : num  -0.472 -0.197 -0.159 -0.333 -0.453 ...
 $ tBodyAccJerk-std()-Y       : num  -0.1607 -0.0446 0.0551 -0.2088 -0.1215 ...
 $ tBodyAccJerk-std()-Z       : num  -0.06331 -0.44016 -0.47746 -0.05011 -0.00443 ...
 $ tBodyGyro-mean()-X         : num  0.2139 -0.0277 -0.0484 -0.0117 0.0334 ...
 $ tBodyGyro-mean()-Y         : num  -0.049 -0.1253 -0.1036 -0.0135 -0.0969 ...
 $ tBodyGyro-mean()-Z         : num  -0.24527 0.12289 0.08692 0.15683 -0.00968 ...
 $ tBodyGyro-std()-X          : num  -0.512 -0.448 -0.407 -0.501 -0.536 ...
 $ tBodyGyro-std()-Y          : num  -0.254 -0.394 -0.208 0.178 -0.239 ...
 $ tBodyGyro-std()-Z          : num  -0.404 -0.311 -0.288 -0.305 -0.362 ...
 $ tBodyGyroJerk-mean()-X     : num  -0.0634 0.0756 0.047 -0.1203 -0.203 ...
 $ tBodyGyroJerk-mean()-Y     : num  0.03158 -0.05686 -0.09651 -0.00423 -0.16378 ...
 $ tBodyGyroJerk-mean()-Z     : num  -0.0112 0.14377 0.00215 -0.18785 0.05743 ...
 $ tBodyGyroJerk-std()-X      : num  -0.228 -0.3 -0.148 -0.411 -0.235 ...
 $ tBodyGyroJerk-std()-Y      : num  -0.293 -0.454 -0.211 0.173 -0.279 ...
 $ tBodyGyroJerk-std()-Z      : num  -0.56075 -0.09672 -0.00331 -0.44637 -0.55917 ...



And as a result we can deduce the following: 
•	A leading t or f is based on time or frequency measurements.
•	Body = related to body movement.
•	Gravity = acceleration of gravity
•	Acc = accelerometer measurement
•	Gyro = gyroscopic measurements
•	Jerk = sudden movement acceleration
•	Mag = magnitude of movement
•	mean and SD are calculated for each subject for each activity for each mean and SD measurements. 
Hence from the above, the following code was written in order to adjust the variable names we have to make them more understandable
# tidy up and rename so they are more descriptive and understandable.
	names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
	names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
	names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
	names(TidyData)<-gsub("mean..", "MEAN", names(TidyData))		
	names(TidyData)<-gsub("std..", "SD", names(TidyData))
	names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
	names(TidyData)<-gsub("^f", "Frequency", names(TidyData),ignore.case = TRUE)
	names(TidyData)<-gsub("^t", "Time", names(TidyData),ignore.case = TRUE)
	names(TidyData)<-gsub("subject", "Subject", names(TidyData))
	names(TidyData)<-gsub("activity", "ActivityName", names(TidyData))
	names(TidyData)<-gsub("code", "ActivityNum", names(TidyData),ignore.case = TRUE)

8. From the tidy data set then need to create a second independent data set with the average of each variable for each activity and each subject. This summarises the data by subject and activity and calculates the mean for each of the measured variables that we have carried through.

SummarisedData <- (TidyData %>% group_by(Subject, ActivityName) %>% summarise_all(funs(mean), na.rm = TRUE))

The final step is just to check the contents of the final dataset and output to a .txt file for upload
write.table(SummarisedData, "F:/R Training/Course 3 - Getting and Cleaning Data/Week 4 Assignment/SummarisedData.txt", row.name=FALSE)



The tidy data set a set of variables for each activity and each subject. 10299 instances are split into 180 groups (30 subjects and 6 activities) and 66 mean and standard deviation features are averaged for each group. The resulting Summarised data table has 180 rows and 69 columns – 33 Mean variables + 33 Standard deviation variables + 1 Subject( 1 of of the 30 test subjects) + ActivityName + ActivityNum . The tidy data set’s first row is the header containing the names for each colu
