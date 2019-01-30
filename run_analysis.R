library(dplyr)

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

#Assign all of the files to different tables with an intuitive name

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


#Merge the training and test datasets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(test, train)


#then combine all 3 datasets in one
Combined_data <- cbind(subject_data, y_data, x_data)

#extract only the mean and standard deviation for each measurement

DatawithMeanSD <- grep("mean\\(\\)|std\\(\\)",features$features,value=TRUE) #list of variables that contain mean and Std Dev

TidyData <- Combined_data[,c("subject","code", DatawithMeanSD)] #take the subset of variables that contain mean and std dev along with subject and activity code

TidyData <- merge(TidyData, activities, by = "code") #add on the Activity information to the data so we know if its walking, running etc..

TidyData <- TidyData[,c("subject","code", "activity", DatawithMeanSD)] #reorder the columns so that activity description is to the front of the dataset

head(str(TidyData),2)

#run head() on the data set to see all the names, then tidy up and rename so they are more descriptive and understandable.
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

SummarisedData <- (TidyData %>% group_by(Subject, ActivityName) %>% summarise_all(funs(mean), na.rm = TRUE))

