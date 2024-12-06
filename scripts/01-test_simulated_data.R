#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Australian 
  #electoral divisions dataset.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
# Load necessary library
library(tidyverse)
library(testthat)


simulated_data <- read_csv("/Users/bettyliu/Downloads/starter_folder-main/data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 9999 rows
if (nrow(simulated_data) == 9999) {
  message("Test Passed: The dataset has 9999 rows.")
} else {
  stop("Test Failed: The dataset does not have 9999 rows.")
}

# Check if the dataset has 5 columns
if (ncol(simulated_data) == 5) {
  message("Test Passed: The dataset has 5 columns.")
} else {
  stop("Test Failed: The dataset does not have 5 columns.")
}

# Check if the 'product' column contains only valid product names
valid_names <- c("drink", "tea")

if (all(simulated_data$product %in% valid_names)) {
  message("Test Passed: The 'product' column contains only valid product names.")
} else {
  stop("Test Failed: The 'product' column contains invalid product names.")
}

# Check if the 'vendor' column contains only valid vendor names
valid_vendor <- c("TandT", "Loblaws", "NoFrills", "Metro", "Galleria", "Walmart")

if (all(simulated_data$vendor %in% valid_vendor)) {
  message("Test Passed: The 'vendor' column contains only valid vendor names.")
} else {
  stop("Test Failed: The 'vendor' column contains invalid vendor names.")
}


# Check if the "current_price" and "old_price" columns are numeric types
# Test to check if columns are numeric
test_that("current_price and old_price are numeric", {
  expect_true(is.numeric(simulated_data$current_price), info = "current_price should be numeric")
  expect_true(is.numeric(simulated_data$old_price), info = "old_price should be numeric")
})

# Check if the "month" column only contains values from 1 to 12
test_that("month column contains only values from 1 to 12", {
  expect_true(all(simulated_data$month %in% 1:12), info = "Month values must be between 1 and 12")
})

# Check if there are any missing values in the dataset
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'product', 'vendor' columns
if (all(simulated_data$product != "" & simulated_data$vendor != "")) {
  message("Test Passed: There are no empty strings in 'product', 'vendor'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}



