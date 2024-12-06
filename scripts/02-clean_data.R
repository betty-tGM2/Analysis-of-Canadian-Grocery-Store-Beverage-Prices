#### Preamble ####
# Purpose: Cleans the raw data from the grocery dataset
# Author: Betty(Zaihua) Liu
# Date: 5 Dec 2024
# Contact: bettyzaihua.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The raw data was downloaded and uplaoded in the 01-raw_data folder
# Any other information needed? N/A

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(janitor)
library(lubridate)
library(dplyr)
library(stringr)
library(readr)

#### Clean data ####
raw_data <- read_csv("data/01-raw_data/hammer-4-raw.csv")
product_data <- read_csv("data/01-raw_data/hammer-4-product.csv")

joined_data <- raw_data %>%
  inner_join(product_data, by = c("product_id" = "id")) %>%
  select(nowtime,
         vendor,
         product_id,
         product_name,
         brand,
         current_price,
         old_price,
         units,
         price_per_unit)


# Final cleaning pipeline
cleaned_data <- joined_data %>%
  # Step 1: Filter only relevant vendors
  filter(vendor %in% c("TandT", "Loblaws", "NoFrills", "Metro", "Galleria", "Walmart")) %>%
  
  # Step 2: Select relevant columns
  select(nowtime, vendor, current_price, old_price, product_name) %>%
  
  # Step 3: Clean old_price and current_price
  mutate(
    month = month(nowtime),
    current_price = parse_number(current_price), # Ensure numerical parsing
    old_price = parse_number(str_replace_all(old_price, "[^0-9.]", "")) # Remove non-numeric chars
  ) %>%
  filter(!is.na(current_price) & current_price > 0) %>% # Remove non-numeric or invalid values
  filter(str_detect(tolower(product_name), "drink")) %>%
  select(-nowtime) %>%
  tidyr::drop_na()

#### Save data ####
write_parquet(x = cleaned_data,
              sink = "data/02-analysis_data/analysis_data.parquet")

