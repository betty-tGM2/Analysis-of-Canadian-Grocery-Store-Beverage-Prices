#### Preamble ####
# Purpose: Simulates a dataset of Canadian Grocery
# Author: Betty(Zaihua) Liu
# Date: 5 Dec 2024
# Contact: bettyzaihua.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `dplyr` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
library(dplyr) # Load dplyr for tibble
set.seed(304)


#### Simulate data ####
vendors <- c("TandT", "Loblaws", "NoFrills", "Metro", "Galleria", "Walmart")
n <- 9999
product_name <- c("drink", "tea")

# Generate simulated data

simulated_data <- tibble(
  product = sample(product_name, n, replace = TRUE),
  vendor = sample(vendors, n, replace = TRUE),
  current_price = round(runif(n, 0.4, 90), 3),
  old_price = round(runif(n, 0.6, 100), 3),
  month = sample(1:12, n, TRUE)
) %>%
  mutate(
    # Ensure the difference is less than 10
    old_price = ifelse(abs(current_price - old_price) >= 10, current_price + runif(1, 0, 9.99), old_price)
  )


#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")

