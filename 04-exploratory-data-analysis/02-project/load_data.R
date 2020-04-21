require(dplyr)

# R Script to download and load data from [National Emissions Inventory (NEI)] (http://www.epa.gov/ttn/chief/eiinformation.html)
# as part of [Exploratory Data Analysis by Johns Hopkins University](https://www.coursera.org/learn/exploratory-data-analysis)

############################
## Set some variables ##
############################

load_data <- function() {
  DATA_URL <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  
  RAW_DIR_PATH <- file.path(".", "_raw-data")
  ZIP_FILE_PATH <- file.path(RAW_DIR_PATH, "exdata_data_NEI_data.zip")
  RAW_FILE_PATH = file.path(RAW_DIR_PATH, "summarySCC_PM25.rds")
  
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

  NEI <- readRDS(file.path(RAW_DIR_PATH, "summarySCC_PM25.rds"))
  SCC <- readRDS(file.path(RAW_DIR_PATH, "Source_Classification_Code.rds"))
  list(NEI=NEI, SCC=SCC)
}
