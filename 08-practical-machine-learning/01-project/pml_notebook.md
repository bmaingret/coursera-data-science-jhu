Practical Machine Learning Assignement
================

``` r
library(caret)

source("./data_import.R")
```

## Importing data

``` r
data <- data_import("all")
training <- as.data.frame(data$training)
testing <- as.data.frame(data$testing)
rm(data)
```

## Selecting features

This project is not very interesting since 20 lines from the original
dataset were randomly selected.

We will simply select the features available to us in the test set and
use these to predict the final label.

``` r
columns_not_na <- colnames(testing)[colSums(is.na(testing))==0]

# Drop the 7 first columns (~metadata) and last column (label)
features <- columns_not_na[8:57]

trainsplit <- createDataPartition(training$classe, p=0.6, list=FALSE)
train.X <- training[trainsplit, features]
train.Y <- training[trainsplit, "classe"]
validation.X <- training[-trainsplit, features]
validation.Y <- training[-trainsplit, "classe"]
test.X <- testing[features]
```

## Fitting models

``` r
#dt_model <- train(x=train.X, y=train.Y, method="rpart", trControl = trainControl(method="cv", 10))
#rf_model <- train(x=train.X, y=train.Y, method="rf") 

# Saving it to disk so that we do not have to retrain those
#saveRDS(dt_model, "./models/dt_model.rds")
#saveRDS(rf_model, "./models/rf_model.rds")

dt_model <- readRDS("./models/dt_model.rds")
rf_model <- readRDS("./models/rf_model.rds")
```

## Testing on validation sets

``` r
validation.predictions <- predict(list(dt=dt_model, rf=rf_model), newdata=validation.X)
training.predictions <- predict(list(dt=dt_model, rf=rf_model))

confusionMatrix(training.predictions$dt, train.Y)$overall['Accuracy']
```

    ##  Accuracy 
    ## 0.4917629

``` r
confusionMatrix(validation.predictions$dt, validation.Y)$overall['Accuracy']
```

    ##  Accuracy 
    ## 0.4885292

``` r
confusionMatrix(training.predictions$rf, train.Y)$overall['Accuracy']
```

    ## Accuracy 
    ##        1

``` r
confusionMatrix(validation.predictions$rf, validation.Y)$overall['Accuracy']
```

    ##  Accuracy 
    ## 0.9961764

## Predicting on test set with Random Forest

``` r
as.numeric(predict(rf_model, newdata = test.X))
```

    ##  [1] 2 1 2 1 1 5 4 2 1 1 2 3 2 1 5 5 1 2 2 2
