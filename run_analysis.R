# To start, be sure you are in the proper working directory with the files "activity_labels.txt" and "features.txt" and "test" and "train" subfolders.

library(reshape2)

# First, we will read all the data into R from the text files using read.table().

activitylabels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
subtest <- read.table("./test/subject_test.txt")
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subtrain <- read.table("./train/subject_train.txt")
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")

# Now that all of the data files have been read into R, let's start combining and cleaning up some of the data sets.
# There are 30 subjects in this test, the 30 were randomly split up into the 2 groups: test and train.
# We will begin with the "test" data set.

# Rename the columns of xtest using the features file that lists each measurement type.

colnames(xtest) <- features[,2]

# Now we will add other columns to this data set that indicate for a given observation the subject I.D. number and the observed activity.
# Add a column to the data set indicating the subject I.D.for the specific observation using the subtest variable.
# Add a column to the data set indicating the observed activity code using the ytest data set.
# We will construct a new data set called "test" for this.

test <- cbind(subtest,ytest,xtest)

# Rename the Subject I.D. and Activity columns in the data set appropriately.

colnames(test)[1:2] <- c("Subject", "Activity")

# Replace the Activity code in the test data set with the corresponding activity label from the activitylabels variable.

test$Activity <- activitylabels[test$Activity,2]

# Now that the test data set is all compiled, we will move on to the train data set and follow the same steps.

# Rename the columns of xtest using the features file that lists each measurement type.

colnames(xtrain) <- features[,2]

# Now we will add other columns to this data set that indicate for a given observation the subject I.D. number and the observed activity.
# Add a column to the data set indicating the subject I.D.for the specific observation using the subtrain variable.
# Add a column to the data set indicating the observed activity code using the ytrain data set.
# We will construct a new data set called "train" for this.

train <- cbind(subtrain,ytrain,xtrain)

# Rename the Subject I.D. and Activity columns in the data set appropriately.

colnames(train)[1:2] <- c("Subject", "Activity")

# Replace the Activity code in the test data set with the corresponding activity label from the activitylabels variable.

train$Activity <- activitylabels[train$Activity,2]

# Now that we have cleaned up both the test and the train data sets, we will combine them together using rbind().

data <- rbind(test,train)

# Next, I will subset the overall data into something a little smaller by looking at a few select variables. I am storing the variables that I chose into a variable called mymeasurements.

mymeasurements <- c("tBodyAcc-mean()-X","tBodyAcc-mean()-Y","tBodyAcc-mean()-Z","tBodyAcc-std()-X","tBodyAcc-std()-Y","tBodyAcc-std()-Z","tBodyGyro-mean()-X","tBodyGyro-mean()-Y","tBodyGyro-mean()-Z","tBodyGyro-std()-X","tBodyGyro-std()-Y","tBodyGyro-std()-Z")

# We will melt the data set extracting only the values that we indicated were important in the mymeasurements variable.

datamelt <- melt(data,id=c("Subject","Activity"),measure.vars=mymeasurements)

# After melting the data frame we will cast it to display average values of the measurements taken sorted by Activity and Subject.
# The result is a data frame called averagedata with the 6 Activities and the average values of the important measurements we selected of each of the Subjects for that activity. It will be 6x30=180 rows.

averagedata <- dcast(datamelt,Activity + Subject ~ variable,mean)

write.table(averagedata,"Tidy_Data.txt", row.names = FALSE)

