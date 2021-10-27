rm(list = ls())
##CLear the R environment

getwd()
##Identify the current working directory

if (!file.exists(filename))
{fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename, method="curl")
}
##Checking if archive already exists.

unzip("getdata_projectfiles_UCI HAR Dataset.zip",exdir="Documents/Coursera/datasciencecoursera")
##Extract folder from the zip file


features <- read.table("Documents/Coursera/datasciencecoursera/UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
##Extract features.txt, rename file to "features", and rename column names "n" and "functions", 561 rows, 2 columns
## List of all features.

activities <- read.table("Documents/Coursera/datasciencecoursera/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
##Extract activity_labels.txt, rename file to "activities", and rename column names "code" and "activity", 6 rows, 2 columns
##Links the class labels with their activity name.

subject_test <- read.table("Documents/Coursera/datasciencecoursera/UCI HAR Dataset/test/subject_test.txt", col.names = "subjects")
##Extract subject_test.txt, rename file to "subject_test", and rename column names "subjects", 2947 rows, 1 column
##Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

Test_labels <- read.table("Documents/Coursera/datasciencecoursera/UCI HAR Dataset/test/y_test.txt", col.names = "code")
##Extract y_test.txt and rename the file Test_labels

Test_set <- read.table("Documents/Coursera/datasciencecoursera/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
##Extract X_test.txt and rename the file Test_set

subject_train <- read.table("Documents/Coursera/datasciencecoursera/UCI HAR Dataset/train/subject_train.txt", col.names = "subjects")
##Extract subject_train.txt and rename subject_train
##Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

Train_labels <- read.table("Documents/Coursera/datasciencecoursera/UCI HAR Dataset/train/y_train.txt", col.names = "code")
##Extract y_train.txt and rename Train_labels

Train_set <- read.table("Documents/Coursera/datasciencecoursera/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
##Extract X_train.txt and rename Train_set


X <- rbind(Train_set, Test_set)
##Merge the train_set and test_set

Y <- rbind(Train_labels, Test_labels)
##Merge the train_labels and Test_labels

Subjects <- rbind(subject_train, subject_test)
##Merge the subject_train and subject_test

MergeDataSet <- cbind(Subjects, Y, X)
##Merge all data into one single table


TidyData <- MergeDataSet %>% select(subjects, code, contains("mean"), contains("std"))
##Extract only the measurements that contains "mean" and "std" on their column name


TidyData$code <- activities[TidyData$code, 2]
##Use descriptive activity names to name the activities in the dataset TidyData


names(TidyData)[2] = "activity"

names(TidyData) <- gsub("Acc", "Acceleration", names(TidyData))
names(TidyData) <- gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData) <- gsub("BodyBody", "Body", names(TidyData))
names(TidyData) <- gsub("Mag", "Magnitude", names(TidyData))
names(TidyData) <- gsub("^t", "Time", names(TidyData))
names(TidyData) <- gsub("^f", "Frequency", names(TidyData))
names(TidyData) <- gsub("tBody", "TimeBody", names(TidyData))
names(TidyData) <- gsub("-mean()", "Mean", names(TidyData))
names(TidyData) <- gsub("-std()", "STD", names(TidyData))
names(TidyData) <- gsub("-freq()", "Frequency", names(TidyData))
names(TidyData) <- gsub("angle", "Angle", names(TidyData))
names(TidyData) <- gsub("gravity", "Gravity", names(TidyData))
##Replace strings to create a more descriptive variable names


FinalData <- TidyData %>% 
  group_by(subjects, activity) %>%
  summarise_all(funs(mean))
##Create a second, independent tidy data set

write.table(FinalData, "FinalData.txt", row.name = FALSE)
##Save as txt