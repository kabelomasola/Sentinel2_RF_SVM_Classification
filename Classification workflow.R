# Set working directory
setwd("./data")

# Load required libraries
if (!require("raster")) install.packages("raster", dependencies=TRUE)
library(raster)
if (!require("rgdal")) install.packages("rgdal", dependencies=TRUE)
library(rgdal)
if (!require("randomForest")) install.packages("randomForest", dependencies=TRUE)
library(randomForest)
if (!require("caret")) install.packages("caret", dependencies=TRUE)
library(caret)
if (!require("e1071")) install.packages("e1071", dependencies=TRUE)
library(e1071)

# Load Sentinel-2 imagery
midrand <- brick("Subset_Midrand_v2.tif")
plotRGB(midrand, 4, 3, 2, scale = 255, stretch = "lin")

# Load training data
features <- readOGR("Training_samples_Midrand.shp")
plot(features, add=TRUE)

# Extract training data
dm <- extract(midrand, features, df = TRUE)
dm$cl <- as.factor(features$Classname[match(dm$ID, seq(nrow(features)))])
dm <- dm[-1]

# Save extracted data
save(dm, file = "dm.rda")

# Split into training and test sets
set.seed(190)
id <- sample(2, nrow(dm), replace = TRUE, prob = c(0.7, 0.3))
train <- dm[id == 1, ]
test <- dm[id == 2, ]

# ------------------------ RANDOM FOREST CLASSIFICATION ------------------------

# Train Random Forest model
cv_control <- trainControl(method = "cv", number = 10, savePredictions = TRUE)
rf_grid <- expand.grid(mtry = 1:10)
rf_model <- train(cl ~ ., data = train, method = "rf", trControl = cv_control, tuneGrid = rf_grid, importance = TRUE)

# Evaluate Random Forest model
rf_pred <- predict(rf_model, test)
rf_confusion <- confusionMatrix(rf_pred, test$cl)
print(rf_confusion)

# Classify entire image using RF
rf_classified <- predict(midrand, rf_model, type = "raw")
writeRaster(rf_classified, "RF_Classification_Midrand.tif", format = "GTiff", datatype = "INT1U", overwrite = TRUE)

# Save RF model
save(rf_model, file = "rf_model.rda")

# ------------------------ SUPPORT VECTOR MACHINE (SVM) CLASSIFICATION ------------------------

# Train SVM model
svm_grid <- expand.grid(sigma = c(0.01, 0.05, 0.1), C = c(1, 10, 100))
svm_model <- train(cl ~ ., data = train, method = "svmRadial", trControl = cv_control, tuneGrid = svm_grid)

# Evaluate SVM model
svm_pred <- predict(svm_model, test)
svm_confusion <- confusionMatrix(svm_pred, test$cl)
print(svm_confusion)

# Classify entire image using SVM
svm_classified <- predict(midrand, svm_model, type = "raw")
writeRaster(svm_classified, "SVM_Classification_Midrand.tif", format = "GTiff", datatype = "INT1U", overwrite = TRUE)

# Save SVM model
save(svm_model, file = "svm_model.rda")
