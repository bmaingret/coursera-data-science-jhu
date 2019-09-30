# Cleaning the Human Activity Recognition Using Smartphone dataset
## Coursera - Data Cleaning Project

As part of the final assignement for [Getting and Cleaning Data courses by Johns Hopkins University, on Coursera](https://www.coursera.org/learn/data-cleaning/), this repository gathers:
* a R script `run_analysis.R` that does the following:
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement.
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names.
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* a code-book `code-book.md` describing the final data set variables
* a readme file `README.md` (a.k.a this file...)

To read in the tidied data set, set you working directory to the root of this repository and:
```
read.table("UCI_HAR_Dataset-tidy.txt")
```

## Details on run_analysis.R

### Versions and requirements

This script requires `dplyr` R library.
Test machine
```
> R.version
            _                           
platform       x86_64-w64-mingw32          
arch           x86_64                      
os             mingw32                     
system         x86_64, mingw32             
status                                     
major          3                           
minor          6.1                         
year           2019                        
month          07                          
day            05                          
svn rev        76782                       
language       R                           
version.string R version 3.6.1 (2019-07-05)
nickname       Action of the Toes          
> sessionInfo()
R version 3.6.1 (2019-07-05)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 17134)

> packageVersion("dplyr")
[1] ‘0.8.3’
```

### Setting some variables
```
DATA_URL: URL to download the data from (specified in the assignement)
RAW_DIR_PATH: dedicated to store the untouched raw data
ZIP_FILE_PATH: helper to specify the target path for the downloaded zip file
ZIP_DIR: top directory of the downloaded zip file, all raw data files are stored inside
TIDY_FILE_PATH: output path for the tidied dataset
```

### Getting the data
Nothing fancy here, we simply download and save the data, checking if it doesn't exist and creating required directories if necessary.

### 1. Merge the training and the test sets and 4. Appropriately label the data set with descriptive variable names
We read every file in a corresponding variable. The following files are used:
* UCI HAR Dataset/test/
  * X_test.txt
  * y_test.txt
  * subject_test.txt
* UCI HAR Dataset/train/
  * X_train.txt
  * y_train.txt
  * subject_train.txt
All files present in the `Inertial Signals/` folders were left out. Those were the raw signals and did not have any features we were interested in.

We bind first by X, y and subject, being carefull to bind rows in the same order for each.

Since we manipulate X, y and subject separetly, and that we will need to work on feature names in next step anyway, we take the opportunity of renaming the variables:
* X features: we follow the `UCI HAR Dataset/features.txt` to match each V*X* feature with the corresponding feature name
* y: `V1` is renamed `activity`
* subject: `V1` is renamed `subject`

We then bind everything together in a single `data` dataframe.

### 2. Extract only the measurements on the mean and standard deviation for each measurement
We select the relevant measurements according to *any* the following rules:
* contains `-mean()`
* contains `-std()`
* contains `-meanFreq()` , although it is a weighted mean we chose to include it in our dataset

### 3. Use descriptive activity names to name the activities in the data set
We use the the activity names indicated in `activity_labels.txt` to not add unneeded differences from the original dataset, and since they were explicit enough.

### 4.  Appropriately label the data set with descriptive variable names
As stated in 1, we used the feature names indicated in `features.txt` to rename the variables for similar reasons as in 3.

We replaced `-` and `()` with `_` for better compatibility in export/import.

### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
This dataset only includes the average of each kept variables for each activity and each subject, and is in the wide format.
This dataset is saved on disk at the path indicated in the variable `TIDY_FILE_PATH` with plain `write.table()`.


## Additional Data Set Information from [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.
>
>Attribute Information:
>
>For each record in the dataset it is provided:
>- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
>- Triaxial Angular velocity from the gyroscope.
>- A 561-feature vector with time and frequency domain variables.
>- Its activity label.
>- An identifier of the subject who carried out the experiment.
>
>### License
>
>Use of this dataset in publications must be acknowledged by referencing the following publication [1] 
>
>[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 
>
>This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
