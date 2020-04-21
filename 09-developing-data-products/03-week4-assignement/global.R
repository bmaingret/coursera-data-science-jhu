
library(tidyr)
library(dplyr)

source("./data_process.R")

data <- readRDS(file.path("data", "birth_data.rds"))
regions <- readRDS(file.path("data", "geojson.rds"))
tmp <- data %>% pivot_wider(names_from = year, names_prefix = "y", values_from = value)
regions@data <- regions@data %>% inner_join(tmp, by = c("nom"= "region"))