library(plyr)
filename<-'UCIHARdata.zip'
data_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dir<-'UCI HAR Dataset'
  
if(!file.exists(dir)){
  download.file(data_url,filename, mode = 'wb')
  unzip("UCIdata.zip", files = NULL, exdir=".")
}

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")  

##1)Merging
df<-rbind(X_train, X_test)

##2)Mean and Std
mean_std <- grep("mean()|std()", features[, 2]) 
df<-df[, mean_std]

##3,4)Clean
clean_names <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(df) <- features[mean_std,2]

subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'
df <- cbind(subject,activity, df)

activity <- factor(df$activity)
levels(activity) <- activity_labels[,2]
df$activity <- act_group

##5)new data
average<-ddply(df, c("subject","activity"), numcolwise(mean))
               
