# getdata-031-project
Getting and Cleaning Data Course Project

1. Merges the training and the test sets to create one data set.

First, read downloaded files into R using read.table() command. 

test1 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/test/X_test.txt")
test2 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/test/y_test.txt")
test3 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/test/subject_test.txt")
train1 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/train/X_train.txt")
train2 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/train/y_train.txt")
train3 <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/train/subject_train.txt")

Attach the columns containing Activity and to the relevant data using the cbind() command. 

testdata <- cbind(test1, test2, test3)
traindata <- cbind(train1, train2, train3)

Then combine the test and train data to form one dataset using rbind() command. 

alldata <- rbind(testdata, traindata)

2. Extracts only the measurements on the mean and standard deviation for each measurement.

First, I loaded the feature data into R using the read.table command.
Then I renamed the columns of the alldata dataframe using the variable names from the features.txt file.
features <- read.table("/Users/elsahou/Documents/R Programming/data/UCI HAR Dataset/features.txt")
columns <- as.vector(features$V2) 
colnames(alldata) <- c(columns, "Activity", "Subject")

Using the grep command, I identified the features that included a mean or standard deviation.  I included fixed = TRUE to make sure that only exact matches were included.
matchesmean <- grep("mean()", features$V2, fixed = TRUE)
matchesstd <- grep("std()", features$V2, fixed = TRUE)

Then I subsetted the features dataframe to include only columns with measurements on mean and standard deviation. 
meanextracts <- features[matchesmean, ]
stdextracts <- features[matchesstd, ]

I combined the data into one dataset named allextracts. 
This is a dataframe with the column names that match mean or standard deviation measurements
allextracts <- rbind(meanextracts, stdextracts)

I created a new dataframe called extracted that is a subset of the alldata dataframe.
I subset the columns to only include columns that were named in the allextracts dataframe. 
I kept the Activity and Subject columns from alldata as well. 
extracted <- alldata[, c(as.vector(allextracts$V1), 562, 563)]

3. Uses descriptive activity names to name the activities in the data set

Using the information in activity_labels.txt, I replaced the numeric Activity value with descriptive names.

extracted$Activity[extracted$Activity == 1] <- "Walking"
extracted$Activity[extracted$Activity == 2] <- "WalkingUpstairs"
extracted$Activity[extracted$Activity == 3] <- "WalkingDownstairs"
extracted$Activity[extracted$Activity == 4] <- "Sitting"
extracted$Activity[extracted$Activity == 5] <- "Standing"
extracted$Activity[extracted$Activity == 6] <- "Laying"

4. Appropriately labels the data set with descriptive variable names.

I removed all "-" from the variable names. 
Using information from the features_info.txt file, I updated the variable names as follows to be more readable:
replaced variables with names starting with "t" to say "Time" 
replaced variables with names starting with "f" to say "Frequency"
replaced variables with names including mean() to say "MeanValue"
replaced variables with names including std() to say "StandardDeviation"
removed "(" and ")" from all variable names. 

colnames(extracted) <- gsub("-", "", names(extracted))
colnames(extracted) <- sub("^t", "Time", names(extracted))
colnames(extracted) <- sub("^f", "Frequency", names(extracted))
colnames(extracted) <- sub("mean()", "MeanValue", names(extracted))
colnames(extracted) <- sub("std()", "StandardDeviation", names(extracted))
colnames(extracted) <- sub("\\(", "", names(extracted))
colnames(extracted) <- sub("\\)", "", names(extracted))

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
First I extracted the names of the columns that I want to group the data by as a list and assigned the list to variable grp_cols.
Then I changed the class of that list to symbol and assigned the new list to the variable dots.
I created a new dataframe called tidydata from the extracted dataframe by using group_by_ and summarise_each commands. 
The tidydata datafram includes only the means of each variable grouped by both Activity and Subject.
I created a file of called tidydata using write.table().

grp_cols <- names(extracted)[67:68]
dots <- lapply(grp_cols, as.symbol)
tidydata <- extracted %>% group_by_(.dots = dots) %>% summarise_each(funs(mean))
write.table(tidydata, file = "./data/UCI HAR Dataset/tidydata.txt")
