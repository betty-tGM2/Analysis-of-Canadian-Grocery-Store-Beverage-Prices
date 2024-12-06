#### Preamble ####
# Purpose: Build a Bayesian model to analyze and predict pricing trends
# Author: Betty(Zaihua) Liu
# Date: 6 Dec 2024
# Contact: bettyzaihua.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure exploratory analysis is complete and analysis_data is up-to-date

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(rstanarm) # For Bayesian modeling

#### Read data ####
analysis_data <- arrow::read_parquet("data/02-analysis_data/analysis_data.parquet")

# Convert necessary columns to factors
analysis_data <- analysis_data %>%
  mutate(
    vendor = as.factor(vendor),
    month = as.factor(month) # Treat months as categorical
  )

#### Model: Bayesian Analysis ####
# Define the Bayesian regression model
bayesian_model <- stan_glm(
  formula = current_price ~ old_price + vendor + month,
  data = analysis_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 1234 # For reproducibility
)

# Print model summary
summary(bayesian_model)

#### Save the model ####
saveRDS(
  bayesian_model,
  file = "models/bayesian_model.rds"
)

#### Model Diagnostics ####
# Plot posterior distributions
plot(bayesian_model)

# Check posterior predictive checks
pp_check(bayesian_model)

#### Predictions ####
# Create a new data frame for prediction
new_data <- tibble(
  old_price = c(5, 10, 20),
  vendor = factor(c("Walmart", "Loblaws", "Metro"), levels = levels(analysis_data$vendor)),
  month = factor(c(6, 7, 8), levels = levels(analysis_data$month))
)

# Generate predictions
predictions <- posterior_predict(bayesian_model, newdata = new_data)
print(predictions)

# Save predictions to CSV
write_csv(as.data.frame(predictions), "other/modeling/predictions.csv")

#### Save the Model ####
saveRDS(
  bayesian_model,
  file = "models/bayesian_model.rds"
)

#### New Visualizations ####

# A. Predicted Average Prices by Vendor and Month
# Ensure predictions_summary has multiple observations per group
posterior_predictions <- as.data.frame(posterior_predict(bayesian_model))

# Add vendor and month information to predictions
predictions_summary <- analysis_data %>%
  mutate(predicted_price = colMeans(posterior_predictions)) %>%
  group_by(vendor, month) %>%
  summarize(
    avg_predicted_price = mean(predicted_price, na.rm = TRUE),
    .groups = "drop" # Ungroup to avoid nesting issues
  )

# Add group aesthetic for geom_line()
ggplot(predictions_summary, aes(x = month, y = avg_predicted_price, group = vendor, color = vendor)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(
    title = "Predicted Average Prices by Vendor and Month",
    x = "Month",
    y = "Predicted Average Price",
    color = "Vendor"
  )

# B. Posterior Coefficients with 90% Credible Intervals
# Add posterior means to the credible intervals
posterior_coeff <- posterior_interval(bayesian_model, prob = 0.9) %>%
  as.data.frame() %>%
  rownames_to_column("Predictor") %>%
  mutate(Estimate = (`5%` + `95%`) / 2) %>% # Use the correct column names for credible intervals
  filter(!Predictor %in% c("(Intercept)", "sigma"))

# Plot posterior coefficients with credible intervals
ggplot(posterior_coeff, aes(x = Predictor, y = Estimate)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = `5%`, ymax = `95%`), width = 0.2) +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Posterior Coefficients with 90% Credible Intervals",
    x = "Predictor",
    y = "Estimated Effect"
  )



# C. Residual Analysis
# Calculate residuals
analysis_data <- analysis_data %>%
  mutate(residuals = current_price - colMeans(posterior_predictions))

# Plot residuals
ggplot(analysis_data, aes(x = old_price, y = residuals, color = vendor)) +
  geom_point(alpha = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_minimal() +
  labs(
    title = "Residual Analysis: Predicted vs. Observed Prices",
    x = "Old Price",
    y = "Residuals",
    color = "Vendor"
  )

