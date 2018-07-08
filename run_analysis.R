## Load all files
x_test <- read.table("test/X_test.txt")
x_train <- read.table("train/X_train.txt")
y_test <- read.table("test/Y_test.txt")
y_train <- read.table("train/Y_train.txt")
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
features <- read.table("features.txt")

## 1) Merge Test & Train sets
x_all <- rbind(x_test, x_train)
y_all <- rbind(y_test, y_train)
subject_all <- rbind(subject_test, subject_train)


## 2) Extract only Mean & Standard Deviation columns
### Name columns in the data sets
names(x_all) <- features$V2
names(y_all) <- "activityId"
names(subject_all) <- "subjectId"


### Find the "mean()" or "std()" columns
meanstd_cols <- grep("std|mean\\(\\)", names(x_all))

### Get only the columns we need
x_selected <- x_all[,meanstd_cols]


## 3) Convert activityId to descriptive names 
activityNames <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
activity_name <- activityNames[y_all[,1]]


## Combine all data sets
all <- cbind(x_selected, activity_name, subject_all)

## 4) Label the data set appropriately
names(all)<-gsub("^t", "Time", names(all))
names(all)<-gsub("^f", "Frequency", names(all))
names(all)<-gsub("-mean()", "Mean", names(all), ignore.case = TRUE)
names(all)<-gsub("-std()", "STD", names(all), ignore.case = TRUE)
names(all)<-gsub("-freq()", "Frequency", names(all), ignore.case = TRUE)
names(all)<-gsub("BodyBody", "Body", names(all))



## 5) create a tidy data set with the average of each variable for each activity and each subject
all_tidy <- aggregate(. ~subjectId + activity_name, all, mean)

## Write tidy data set to a file
write.table(all_tidy, "tidy.txt", row.name=FALSE)

