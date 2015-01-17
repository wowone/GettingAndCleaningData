

Getting and Cleaning Data Course Project
==================

First, we read the data. `X`, `y` and `s` variables stand for features data frame, activities vector and subject vector correspondingly. Depending on the origin of the data, their names end with "_train" or "_test" suffixes.

```r
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=F)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header=F)
s_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=F)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header=F)
s_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
```

Merging the train and the test data together.

```r
X <- rbind(X_train, X_test)
y <- c(y_train$V1, y_test$V1)
s <- c(s_train$V1, s_test$V1)
```

Reading the feature names and keeping only those which contain "mean()" or "std()". Note, that we do not need such features as "angle(X,gravityMean)" even they contain keywords "mean", because, actually, they are angles, but not averaged values.

```r
feat_names <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=F)$V2
keep_ind <- grep("mean\\(\\)|std\\(\\)", feat_names)
X <- X[,keep_ind]
feat_names <- feat_names[keep_ind]
```

Binding variables `X`, `s`, `y` in one data frame `data`. 

```r
data <- cbind(X, data.frame(s,y))
```

Preparing appropriate column names (removing illegal characters and typos) and assigning them to columns of dataframe `data`.

```r
feat_names <- gsub("-", ".", feat_names)
feat_names <- gsub("[\\(\\)]", "", feat_names)
feat_names <- gsub("BodyBody", "Body", feat_names)
colnames(data) <- c(feat_names,"subject", "activity")
```

Creating a new dataframe `data2` with the aggregated statistics groupped by `sudject` and `activity` columns.

```r
data2 <- aggregate(data, by=list(data$subject, data$activity), FUN=mean)
```

Now, we need to adjust names of the first two columns of the output data frame `data2`, because after the aggregating they are just "Group.1" and "Group.2".

```r
colnames(data2)[c(1,2)] = c("subject", "activity")
```

Writting down the aggregated data.

```r
write.table(data2, "aggregated_data", sep="\t", quote=F, row.names=F)
```

Thus, we have obtained cleaned up and aggregated data set which is described as follows.

Ordinal variables
======

- subject: id of a volunteer who took participation in the experiment, an integer number between 1 and 30.
- activity: id of one of the following types of activity: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.


Continuous variables
======

The other variables are averaged over subject and activity. Since the original values are normalized and bounded within [-1,1], the averaged values do not have units as well. Their names are organized in the following way:
```
[t|f]original_observation_variable.[mean|std][.X|.Y|.Z]
```

`f` indicates that the variable was derived from the variable with the same name, but with `t` prefix, using Fast Fourier Transform. `mean` or `std` mean that the variable were obviously estimated (mean or standard deviation were applied) from the corresponding `original_observation_variable`.

The original observation name could be one of the follows:

- BodyAcc
- GravityAcc
- BodyAccJerk
- BodyGyro
- BodyGyroJerk
- BodyAccMag
- GravityAccMag
- BodyAccJerkMag
- BodyGyroMag
- BodyGyroJerkMag

If an original observation variable is a 3-dimensional variable, it falls into three correspondind variables with `.X`, `.Y` and `.Z` suffixies.
