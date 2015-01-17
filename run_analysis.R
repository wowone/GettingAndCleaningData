# loading the data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=F)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header=F)
s_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=F)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header=F)
s_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F)

# merging activities (vector y), subjects (vector s) and features (data frame X)
y <- c(y_train$V1, y_test$V1)
s <- c(s_train$V1, s_test$V1)
X <- rbind(X_train, X_test)

# reading names of the features
feat_names <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=F)$V2

# keeping only the names which contain either "mean()" or "std()"
keep_ind <- grep("mean\\(\\)|std\\(\\)", feat_names)

# filtering the selected names in feat_names and the corresponing columns in X
X <- X[,keep_ind]
feat_names <- feat_names[keep_ind]

# binding subjects and activities vectors to data frame X
data <- cbind(X, data.frame(s,y))

# removing illegal characters in feat_names and adjusting "BodyBody" typo.
feat_names <- gsub("-", ".", feat_names)
feat_names <- gsub("[\\(\\)]", "", feat_names)
feat_names <- gsub("BodyBody", "Body", feat_names)

# assigning correct column names to the data
colnames(data) <- c(feat_names,"subject", "activity")

# aggregating mean values of the columns groupped by subject and activity
data2 <- aggregate(data, by=list(data$subject, data$activity), FUN=mean)

# adjusting names of the first two columns which were used as group variables
colnames(data2)[c(1,2)] = c("subject", "activity")

# writting down the outcome data
write.table(data2, "aggregated_data", sep="\t", quote=F, row.names=F)
