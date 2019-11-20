## Getting the data

library(jsonlite)
library(geojsonio)

RAW_PATH = "./data/raw"
PROCESSED_PATH = "./data"

if (!(file.exists(file.path(PROCESSED_PATH, "birth_data.rds")))){
  # Data downloaded from [INSEE.FR](https://www.insee.fr/fr/statistiques/series/102928992).
  
  zip_files <- list.files(RAW_PATH, full.names = TRUE, pattern = "*.zip")
  zip_dir <- tools::file_path_sans_ext(zip_files)
  sapply(zip_dir, dir.create)
  sapply(zip_files, function(x) unzip(x, exdir = tools::file_path_sans_ext(x), junkpaths = TRUE))
  
  get_region <- function(path){
    tmp <- read.csv2(file.path(path, "caract.csv"), encoding = "UTF-8", nrows = 2, as.is = TRUE)
    tmp[1, "Zone.géographique"]
  }
  
  format_data <- function(path){
    tmp <- read.csv2(file.path(path, "valeurs_annuelles.csv"), encoding = "UTF-8", col.names = c("year", "value", "code"), skip = 3, header=FALSE)
    tmp["region"] <- get_region(path)
    tmp
  }
  
  data <- lapply(zip_dir, format_data)
  data <- do.call(rbind.data.frame, data)
  data <- data[, -3]
  saveRDS(data, file.path(PROCESSED_PATH, "birth_data.rds"))
  }

if (!(file.exists(file.path(PROCESSED_PATH, "geojson.rds")))){
  
  regions <- geojson_read("https://raw.githubusercontent.com/gregoiredavid/france-geojson/master/regions-version-simplifiee.geojson", what="sp")
  saveRDS(regions, file.path(PROCESSED_PATH, "geojson.rds"))
}