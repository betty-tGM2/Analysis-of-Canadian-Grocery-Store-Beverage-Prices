#### Preamble ####
# Purpose: Explore the analyzed data
# Author: Betty(Zaihua) Liu
# Date: 5 Dec 2024
# Contact: bettyzaihua.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Updated the analysis_data file
# Any other information needed? N/A


#### Workspace setup ####
library(tidyverse)
library(arrow)

library(lubridate) # For date manipulation
library(ggplot2)   # For visualizations

#### Read data ####
analysis_data <- arrow::read_parquet("/Users/bettyliu/Downloads/starter_folder-main/data/02-analysis_data/analysis_data.parquet")

# Check unique months and their distribution
unique_months <- unique(analysis_data$month)
month_distribution <- analysis_data %>%
  count(month) %>%
  arrange(month)

# Print unique months and distribution
print(unique_months)
print(month_distribution)


#### 1. Understand Dataset Structure ####
# Check structure and summary
glimpse(analysis_data)
summary(analysis_data)

# Check for missing values
missing_values <- colSums(is.na(analysis_data))
print(missing_values)

#### 2. Summarize Key Variables ####
# Summary statistics for pricing
pricing_summary <- analysis_data %>%
  summarize(
    avg_current_price = mean(current_price, na.rm = TRUE),
    median_current_price = median(current_price, na.rm = TRUE),
    sd_current_price = sd(current_price, na.rm = TRUE),
    avg_old_price = mean(old_price, na.rm = TRUE),
    median_old_price = median(old_price, na.rm = TRUE),
    sd_old_price = sd(old_price, na.rm = TRUE)
  )
print(pricing_summary)

# Count unique vendors and products
unique_counts <- analysis_data %>%
  summarize(
    unique_vendors = n_distinct(vendor),
    unique_products = n_distinct(product_id)
  )
print(unique_counts)

#### 3. Visualize Trends ####
# 3.1 Cross-Vendor Pricing Trends
ggplot(analysis_data, aes(x = vendor, y = current_price)) +
  geom_boxplot(fill = "steelblue") +
  theme_minimal() +
  labs(
    title = "Current Price Distribution by Vendor",
    x = "Vendor",
    y = "Current Price"
  )

# 3.2 Temporal Trends in Pricing
# Sort numeric months as factor levels
analysis_data <- analysis_data %>%
  mutate(month = factor(month, levels = sort(unique(month))))

ggplot(analysis_data, aes(x = month, y = current_price, color = vendor)) +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = 0.2) +  # Error bars
  geom_point(stat = "summary", fun = mean, size = 3) +
  geom_line(stat = "summary", fun = mean, size = 1) +
  theme_minimal() +
  labs(
    title = "Average Monthly Pricing by Vendor",
    x = "Month",
    y = "Average Current Price",
    color = "Vendor"
  )


# 3.3 Correlation Between Current and Old Prices
ggplot(analysis_data, aes(x = old_price, y = current_price, color = vendor)) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(
    title = "Correlation Between Old Price and Current Price",
    x = "Old Price",
    y = "Current Price",
    color = "Vendor"
  )


#### 4. Identify Anomalies ####
# Identify outliers in pricing
outliers <- analysis_data %>%
  filter(current_price > (mean(current_price, na.rm = TRUE) + 3 * sd(current_price, na.rm = TRUE)) |
           current_price < (mean(current_price, na.rm = TRUE) - 3 * sd(current_price, na.rm = TRUE)))
print(outliers)

#### 5. Prepare Insights ####
# Highlight vendors with highest and lowest average prices
vendor_summary <- analysis_data %>%
  group_by(vendor) %>%
  summarize(
    avg_price = mean(current_price, na.rm = TRUE),
    count = n()
  ) %>%
  arrange(desc(avg_price))
print(vendor_summary)

# Save results to CSV for further review
write_csv(vendor_summary, "/Users/bettyliu/Downloads/starter_folder-main/other/exploratory/vendor_pricing_summary.csv")
write_csv(outliers, "/Users/bettyliu/Downloads/starter_folder-main/other/exploratory/pricing_outliers.csv")

# Summarize outliers by vendor
outlier_summary <- outliers %>%
  group_by(vendor) %>%
  summarize(count = n(), avg_price = mean(current_price, na.rm = TRUE))

print(outlier_summary)

# Save outlier summary
write_csv(outlier_summary, "/Users/bettyliu/Downloads/starter_folder-main/other/exploratory/outlier_summary.csv")


