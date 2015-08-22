## 1. Merges the training and the test sets to create one data set.

## Read downloaded files into R

test1 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/test/X_test.txt")
test2 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/test/y_test.txt")
test3 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/test/subject_test.txt")
train1 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/train/X_train.txt")
train2 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/train/y_train.txt")
train3 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/train/subject_train.txt")

## Merge all the dataframes into one set of data

testdata <- cbind(test1, test2, test3)
traindata <- cbind(train1, train2, train3)

alldata <- rbind(testdata, traindata)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/features.txt")

## Identify which features are a mean or standard deviation
matchesmean <- grep("mean()", features$V2, fixed = TRUE)
matchesstd <- grep("std()", features$V2, fixed = TRUE)

## Subset the columns that match mean or std
meanextracts <- features[matchesmean, ]
stdextracts <- features[matchesstd, ]

allextracts <- rbind(meanextracts, stdextracts)

## Rename columns of the alldata dataframe
columns <- as.vector(features$V2) 
colnames(alldata) <- c(columns, "Activity", "Subject")

## Extract the columns that match mean and std. Keep activity and subject as well. 
extracted <- alldata[, c(as.vector(allextracts$V1), 562, 563)]

## 3. Uses descriptive activity names to name the activities in the data set

extracted$Activity[extracted$Activity == 1] <- "Walking"
extracted$Activity[extracted$Activity == 2] <- "WalkingUpstairs"
extracted$Activity[extracted$Activity == 3] <- "WalkingDownstairs"
extracted$Activity[extracted$Activity == 4] <- "Sitting"
extracted$Activity[extracted$Activity == 5] <- "Standing"
extracted$Activity[extracted$Activity == 6] <- "Laying"

## 4. Appropriately labels the data set with descriptive variable names.

colnames(extracted) <- gsub("-", "", names(extracted))
colnames(extracted) <- sub("^t", "Time", names(extracted))
colnames(extracted) <- sub("^f", "Frequency", names(extracted))
colnames(extracted) <- sub("mean()", "MeanValue", names(extracted))
colnames(extracted) <- sub("std()", "StandardDeviation", names(extracted))
colnames(extracted) <- sub("\\(", "", names(extracted))
colnames(extracted) <- sub("\\)", "", names(extracted))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

grp_cols <- names(extracted)[67:68]
dots <- lapply(grp_cols, as.symbol)
tidydata <- extracted %>% group_by_(.dots = dots) %>% summarise_each(funs(mean))
write.table(tidydata, file = "./data/UCI HAR Dataset/tidydata.txt")


