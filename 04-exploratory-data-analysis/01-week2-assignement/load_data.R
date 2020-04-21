require(dplyr)
require(readr)

# R Script to tidy data from UCI Machine Learning Repository - Human Activity Recognition Using Smartphones Data Set
# as part of [Getting and Cleaning Data by Johns Hopkins University](https://www.coursera.org/learn/data-cleaning)

############################
## Set some variables ##
############################

load_data <- function() {
  DATA_URL <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  
  RAW_DIR_PATH <- file.path(".", "_raw-data")
  ZIP_FILE_PATH <- file.path(RAW_DIR_PATH, "raw_data.zip")
  RAW_FILE_PATH = file.path(RAW_DIR_PATH, "household_power_consumption.txt")
  
  ######################
  ## Get the data ##
  ######################
  
  if (!file.exists(RAW_DIR_PATH)) {
    dir.create(RAW_DIR_PATH)
  }
  
  if (!file.exists(RAW_FILE_PATH)) {
    download.file(DATA_URL, ZIP_FILE_PATH)
    unzip(ZIP_FILE_PATH, exdir = RAW_DIR_PATH, overwrite = FALSE)
    file.remove(ZIP_FILE_PATH)
  }
  
  data <-
    read_delim(
      RAW_FILE_PATH,
      delim = ";",
      na = c("?"),
      col_types = "ccddddddd"
    )
  data <- data %>%
    mutate(DateTime = dmy_hms(paste(Date, Time, " "))) %>%
    filter(date(DateTime) == ymd("2007/02/01") | date(DateTime) == ymd("2007/02/02"))
  data
}