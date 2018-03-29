# load reshape2 package
library(reshape2)
## Step 1: Merge the training and test data sets to create a final data set

# using data frames to read the data
subject_train <- read.table("subject_train.txt")
subject_text <- read.table("subject_text.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

# column names for subject file
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# column names for lable files
names(y_train) <- "activity"
names(y_test) <- "activity"

# add column names for measurement files
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

## Step 2:Extracts only the measurements on the mean and standard deviation for each measurement.

meanstdcols <- grepl("mean\\(\\)", names(combined)) |  
grepl("std\\(\\)", names(combined))
meanstdcols[1:2] <- TRUE
combined <- combined[, meanstdcols]

## STEP 3: Uses descriptive activity names to name the activities
## STEP 4: Appropriately labels the data set with descriptive activity names. 
combined$activity <- factor(combined$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

## STEP 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)
write.csv(tidy, "tidy.csv", row.names=FALSE)
