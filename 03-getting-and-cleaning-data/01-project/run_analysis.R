require(dplyr)

# R Script to tidy data from UCI Machine Learning Repository - Human Activity Recognition Using Smartphones Data Set
# as part of [Getting and Cleaning Data by Johns Hopkins University](https://www.coursera.org/learn/data-cleaning)

############################
## Set some variables ##
############################

DATA_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
RAW_DIR_PATH <- file.path(".", "_raw-data")
ZIP_FILE_PATH <- file.path(RAW_DIR_PATH, "raw_data.zip")
ZIP_DIR = "UCI HAR Dataset"
RAW_DATA_PATH = file.path(RAW_DIR_PATH, ZIP_DIR)
TIDY_FILE_PATH <- file.path(".", "UCI_HAR_Dataset-tidy.txt")


######################
## Get the data ##
######################

if (!file.exists(RAW_DIR_PATH)){
  dir.create(RAW_DIR_PATH)
}

if (!file.exists(RAW_DATA_PATH)){
  download.file(DATA_URL, ZIP_FILE_PATH)
  unzip(ZIP_FILE_PATH, exdir = RAW_DIR_PATH, overwrite = FALSE)
  file.remove(ZIP_FILE_PATH)
}


######################################################################
## 1. Merge all the data from test and train sets ####################
#### and #############################################################
## 4. Rename variable names with descriptive and appropriate labels ##
######################################################################

# Merge each training/test set together and do a first renaming according to features.txt for X
# ! Pay attention to bind rows in the same order for training, test and subject sets

X_test <- read.table(file.path(RAW_DATA_PATH, "test", "X_test.txt"))
X_train <- read.table(file.path(RAW_DATA_PATH, "train", "X_train.txt"))
features <- read.table(file.path(RAW_DATA_PATH, "features.txt"), stringsAsFactors = FALSE)

feature_names <- paste("V",features$V1, sep ="") # Creating a feature names vector for easy renaming
names(feature_names) <- features$V2

X <- X_test %>%
  bind_rows(X_train) %>%
  rename(!!feature_names)

rm(X_test, X_train)


y_test <- read.table(file.path(RAW_DATA_PATH, "test", "y_test.txt"))
y_train <- read.table(file.path(RAW_DATA_PATH, "train", "y_train.txt"))

y <- y_test %>%
  bind_rows(y_train) %>%
  rename(activity = V1)

rm(y_test, y_train)


subject_test <- read.table(file.path(RAW_DATA_PATH, "test", "subject_test.txt"))
subject_train <- read.table(file.path(RAW_DATA_PATH, "train", "subject_train.txt"))

subject <- subject_test %>% 
  bind_rows(subject_train) %>%
  rename(subject = V1)

rm(subject_test, subject_train)

#  Merge X, y and subject
data <- y %>%
    bind_cols(subject) %>%
    bind_cols(X)

rm(X, y, subject)

################################################################
## 2. Extract measurements on the mean and standard deviation ##
################################################################

data <- select(data, subject, activity, matches("-mean\\(\\)|-std\\(\\)|-meanFreq\\(\\)"))


#################################################
## 3. Rename activities with descriptive names ##
#################################################

activity_labels <- read.table(file.path(RAW_DATA_PATH, "activity_labels.txt"))
data <- data %>%
  mutate(activity = factor(activity, levels=activity_labels$V1, labels=activity_labels$V2))


##########################################################################
## 4. Appropriately labels the data set with descriptive variable names ##
##########################################################################

# Also already renamed according to features.txt, removing unwanted characters for better export/import
names(data) <- gsub("\\(\\)", "", names(data))
names(data) <- gsub("-", "_", names(data))


############################################################
## 5. Create an additional tidy data set with the average ##
## of each variable for each activity and each subject #####
############################################################

tidy_data <- data %>%
  mutate(subject = factor(subject)) %>%
  group_by(subject, activity) %>%
  summarise_each(list(mean=mean))

write.table(tidy_data, TIDY_FILE_PATH, row.name=FALSE)
