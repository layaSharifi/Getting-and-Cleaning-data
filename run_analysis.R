
##Question1-Merge the training and the test sets to create one data set.
##Step1-------obtain and Unzip the training and the test sets and merg them to create one data set.----------

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f<-file.path(setwd("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project"),"Dataset.zip")
download.file(url, f , mode="wb") 
unzip (f, exdir = ".")

##Step2-------------------------load data into R-------------------------------------------

test.x<- read.table("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/UCI HAR Dataset/test/y_test.txt")
test.subject<- read.table("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/UCI HAR Dataset/test/subject_test.txt")

train.x<- read.table("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/UCI HAR Dataset/train/y_train.txt")
train.subject

<- read.table("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/UCI HAR Dataset/train/subject_train.txt")
View(train.subject)

##step3-------------------- merge train and test data--------------------------------
trainData <- cbind(train.subject, train.y, train.x)
View(trainData)
testData <- cbind(test.subject, test.y, test.x)
View(testData)
fullData <- rbind(trainData, testData)


##Question2-Extract only the measurements on the mean and standard deviation for each measurement. 
##step 1--------------------------load feature name into R------------------------
featureName <- read.table("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[2]
# featureName
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName$V2)
featureIndex



##Question3-Uses descriptive activity names to name the activities in the data set
##Step1-------load activity data into R---------------------------------

activityName <- read.table("C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/UCI HAR Dataset/activity_labels.txt")

# View(activityName)
colnames(fullData)[1:2]=c('subjectId','activityID')

finalData <- fullData[, c(1, 2, featureIndex+2)]

colnames(finalData) <- c("subject", "activity", featureName$V2[featureIndex])
View(finalData)

finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])
finalData$activity

##Question4-Appropriately labels the data set with descriptive variable names.

names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))


##Question5-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

install.packages("dplyr")
library(dplyr)
groupData <- finalData %>%
  group_by(subjectId, activityID) %>%
  summarise_each(funs(mean))

write.table(groupData, "C:/Users/lsharifi/Desktop/Rot2/coursera/A3-project/CourseProject.txt", row.names = FALSE)


