require(checkmate)
require(tidyr)
require(readr)

columns_spec_training <- cols(
  X1 = col_skip(),
  user_name = col_factor(),
  raw_timestamp_part_1 = col_double(),
  raw_timestamp_part_2 = col_double(),
  cvtd_timestamp = col_datetime(format= "%d/%m/%Y %H:%M"),
  new_window = col_factor(c("yes","no")),
  classe = col_factor(c("A","B","C","D","E")),
  .default = col_double()
)

columns_spec_testing <- cols(
  X1 = col_skip(),
  user_name = col_factor(),
  raw_timestamp_part_1 = col_double(),
  raw_timestamp_part_2 = col_double(),
  cvtd_timestamp = col_datetime(format= "%d/%m/%Y %H:%M"),
  new_window = col_factor(c("yes","no")),
  problem_id = col_factor(),
  .default = col_double())

nas_specs = c("#DIV/0!", "NA", "")

data_import <- function(case = "all"){
  
  cases <- c("all", "test", "train")
  assertChoice(case, cases)
  
  ######################
  ## Some constants ##
  ######################
  
  URL_TRAIN <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
  URL_TEST <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
  
  FILE_TRAIN <- "pml-training.csv"
  FILE_TEST <- "pml-testing.csv"
  
  DATA_FOLDER <- file.path(".", "data", "raw")
  
  PATH_TRAIN <- file.path(DATA_FOLDER, FILE_TRAIN)
  PATH_TEST <- file.path(DATA_FOLDER, FILE_TEST)
  
  ######################
  ## Get the data ##
  ######################
  data <- list()
  
  # Download data if not already done
  if (case!="test") {
    if (!file.exists(PATH_TRAIN)) {
      download.file(URL_TRAIN, PATH_TRAIN, method="libcurl")
    }
    training <- read_csv(PATH_TRAIN, col_types=columns_spec_training, na = nas_specs)
    data[["training"]] <- training
  }
  
  if (case!="train"){
    if (!file.exists(PATH_TEST)) {
      download.file(URL_TEST, PATH_TEST, method="libcurl")
    }
    testing <- read_csv(PATH_TEST, col_types=columns_spec_testing, na = nas_specs)
    data[["testing"]] <- testing
  }
  
  if (length(data)==1) {
    data = data[[1]]
  }
  return(data)
}