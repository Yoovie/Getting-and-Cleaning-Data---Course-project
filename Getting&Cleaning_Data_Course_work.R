#Read Training files
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Read Testing files
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Read features & activities:
features <- read.table('./UCI HAR Dataset/features.txt')
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt')

#Naming
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activityLabels) <- c('activityID','activityType')

#Merge tables
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
fullData <- rbind(merge_train, merge_test)

#Defining and creating the subset with measurements on the mean and standard deviation:
Columns <- colnames(fullData)
Colsub <- (grepl("activityID" , Columns) | 
                   grepl("subjectID" , Columns) | 
                   grepl("mean.." , Columns) | 
                   grepl("std.." , Columns) 
)
DataSub <- fullData[ , Colsub == TRUE]

#Add activity type name to the subset:
FinData <- merge(activityLabels, DataSub, by='activityID',all.x=TRUE)

#Create 2nd data set with average for each variable sorted in Subject ID order:
library(plyr)
Data2<-aggregate(. ~subjectID + activityID +activityType, FinData, mean)
Data2<-Data2[order(Data2$subjectID,Data2$activityID),]

#Create .txt file with 2nd data set:
write.table(Data2, "TidySet.txt", row.name=FALSE)