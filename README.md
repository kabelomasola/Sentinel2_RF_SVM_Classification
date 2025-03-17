Remote Sensing Classification using Random Forest & SVM

Overview
This repository contains R scripts for performing remote sensing classification using Sentinel-2 imagery. The workflow includes data preprocessing, feature extraction, classification using **Random Forest (RF)** and **Support Vector Machine (SVM)**, and visualization of classification results.

Features
- Reads Sentinel-2 imagery and training shapefiles.
- Extracts spectral information for training data.
- Implements **Random Forest** classification with hyperparameter tuning.
- Implements **Support Vector Machine** classification with hyperparameter tuning.
- Evaluates classification performance using confusion matrices.
- Exports classified raster images.

Requirements
Software:
- RStudio
- R (version 4.0 or later recommended)

R Packages:
Ensure the following R packages are installed:
install.packages(c("raster", "randomForest", "caret", "metrics", "e1071", "rgdal"))

Usage
1. Load Sentinel-2 imagery
Modify the script to set the correct path for Sentinel-2 imagery files:
Midrand <- brick("path_to_your_file/imagery.tif")

2. Load Training Data
Ensure your training shapefile is correctly linked:
features <- readOGR("path_to_your_file/Training_samples.shp")

3. Run Classification
Execute the script to train and apply the **Random Forest** or **SVM** classifier to the imagery.

4. Export Results
Classified images are saved as GeoTIFF files in the working directory.

License
**All Rights Reserved** – The code in this repository is not open for modification or redistribution without explicit permission.

Author
**Kabelo Masola**

Contact
For any inquiries, please contact me via GitHub or email.
