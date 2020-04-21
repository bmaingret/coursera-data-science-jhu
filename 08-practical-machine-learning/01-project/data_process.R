source("data-import.R")

training <- import_data("train")

info_features_col <- c("user_name", "classe","num_window")
sensors <- c("arm","forearm","belt","dumbbell")
features <- c("kurtosis", "skewness", "max", "min", "amplitude","avg","stddev","var") "total"
features_col <- unlist(lapply(features, function(x) colnames(training)[grepl(x,colnames(training))]))

training <- training %>% 
  filter(new_window=="yes") %>%
  select(c(features_col, info_features_col))

training <- training %>%
  mutate_all(as.numeric) %>%
  mutate_at(info_features_col, as.factor)

# From the order of the other columns we can assume that skewness_roll_belt.1 is in fact the skewness_pitch_belt
training <- training %>%
  mutate(skewness_picth_belt = skewness_roll_belt.1)

# training <- training %>%
#   group_by("user_name", "classe")

my_plot <- function(feature){
  tmp <- training %>% select(contains(feature), info_features_col)%>%pivot_longer(cols=contains(feature))
  qplot(x=value, data=tmp, colour=classe,  geom="density") + facet_grid(name~user_name, scales = "free") +
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank())
}

my_plot("skewness")

drop_columns <- c("kurtosis_yaw_forearm", "kurtosis_yaw_belt", "kurtosis_yaw_dumbbell",
                  "skewness_yaw_forearm", "skewness_yaw_belt", "skewness_yaw_dumbbell", "skewness_roll_belt.1" )