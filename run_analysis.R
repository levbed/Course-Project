## Load the dplyr package
library(dplyr)

## First, I read all the data into R
subject_test<-read.table(file = "./test/subject_test.txt", col.names = "subject")
X_test<-read.table(file = "./test/X_test.txt")
y_test<-read.table(file = "./test/y_test.txt", col.names = "activity")
subject_train<-read.table(file = "./train/subject_train.txt", col.names = "subject")
X_train<-read.table(file = "./train/X_train.txt")
y_train<-read.table(file = "./train/y_train.txt", col.names = "activity")

## Then, the subject and the activity data is added to both test and training data, and after that they are joined
test_data<-cbind(X_test, subject_test, y_test)
train_data<-cbind(X_train, subject_train, y_train)
data<-rbind(test_data, train_data)

## Read the feature file in order to find the needed columns
features<-read.table(file = "./features.txt", stringsAsFactors = TRUE)
names <- as.character(features[ ,2])
## Find the column names with "std"
std_col<-grep("std", names, value = FALSE, ignore.case = TRUE)
## Find the column names with "mean"
mean_col<-grep("mean", names, value = FALSE, ignore.case = TRUE)
## Collect the needed indices together
indices<-c(std_col, mean_col)
## Sort them ascending
indices<-sort(indices, decreasing = FALSE)
## Subset the data based on the indices
data_sub<-select(data, indices, subject, activity)

## Read the activity information, then add it to the data_sub
activity_labels<-read.table(file = "./activity_labels.txt", stringsAsFactors=TRUE)
activity<-as.character(activity_labels[,2])
for (i in seq(nrow(activity_labels))) {data_sub[data_sub$activity == i, "activity"] <- activity[[i]]}

## Add the desriptive column names to data_sub
## First, lets get the names
features<-read.table(file = "./features.txt", stringsAsFactors = TRUE)
names <- as.character(features[ ,2])
## Then, subset the ones we need for our dataset ("mean" and "std")
names<-names[indices]
## Let's make these names a bit more beautiful
names<-gsub("\\()", "", names)
names<-gsub("\\-", "_", names)
## Add the names for the subject and activity columns
names<-c(names, "subject", "activity")
## Now we can finally add them to the data_sub
names(data_sub)<-names

## Tidy the data, create the wide form of it
tidy_data <- aggregate(. ~ subject + activity, data = data_sub, mean)
tidy_data<-arrange(tidy_data, subject, activity)
