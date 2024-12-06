#### Preamble ####
# Purpose: Tests the analysis data
# Author: Betty(Zaihua) Liu
# Date: 5 Dec 2024
# Contact: bettyzaihua.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The cleaned data is updated in the analysis data folder.
# Any other information needed? N/A

#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)

analysis_data <- arrow::read_parquet("/Users/bettyliu/Downloads/starter_folder-main/data/02-analysis_data/analysis_data.parquet")


#### Test data ####
# Test that the dataset has 30875 rows - there are 30875 divisions in Australia
test_that("dataset has 30875 rows", {
  expect_equal(nrow(analysis_data), 30875)
})

# Test that the dataset has 5 columns
test_that("dataset has 5 columns", {
  expect_equal(ncol(analysis_data), 5)
})

# Test that the 'vendor' column is character type
test_that("'vendor' is character", {
  expect_type(analysis_data$vendor, "character")
})

# Test that the 'product_name' column is character type
test_that("'product_name' is character", {
  expect_type(analysis_data$product_name, "character")
})

# Check if the "current_price" and "old_price" columns are numeric types
# Test to check if columns are numeric
test_that("current_price and old_price are numeric", {
  expect_true(is.numeric(analysis_data$current_price), info = "current_price should be numeric")
  expect_true(is.numeric(analysis_data$old_price), info = "old_price should be numeric")
})

# Check if the "month" column only contains values from 1 to 12
test_that("month column contains only values from 1 to 12", {
  expect_true(all(analysis_data$month %in% 1:12), info = "Month values must be between 1 and 12")
})


# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(analysis_data)))
})


# Test that 'vendor' contains only valid vendor names
valid_vendor <- c("TandT", "Loblaws", "NoFrills", "Metro", "Galleria", "Walmart")
test_that("'vendor' contains only valid vendor names", {
  expect_true(all(analysis_data$vendor %in% valid_vendor))
})

# Test that there are no empty strings in 'vendor', 'product_name' columns
test_that("no empty strings in 'vendor', 'product_name'", {
  expect_false(any(analysis_data$vendor == "" | analysis_data$product_name == ""))
})

