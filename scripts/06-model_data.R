#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(bayesplot)
library(here)

#### Read data ####
analysis_budget_data <- read.csv(here::here("data/02-analysis_data/analysis_budget_data.csv"))
analysis_building_permits <- read.csv(here::here("data/02-analysis_data/analysis_building_permits.csv"))
analysis_ward_data <- read.csv(here::here("data/02-analysis_data/analysis_ward_data.csv"))


### Model data ####

model_data <-
  analysis_budget_data |>
  group_by(ward_id, ward, category) |>
  summarise(total_10_year = mean(total_10_year)) |>
  pivot_wider(names_from = category, values_from = total_10_year) |>
  select(ward_id, ward, `Growth Related`, `State of Good Repair`, `Service Improvement and Enhancement`) |>
  left_join(analysis_building_permits, by = "ward_id") |>
  left_join(analysis_ward_data, by = "ward_id") |>
  rename(ward = ward.x) |>
  select(ward_id, ward, population, average_household_income, total_building_permits, `Growth Related`, `State of Good Repair`, `Service Improvement and Enhancement`) |>
  # add a new column for total budget across three categories
  mutate(total_budget = `Growth Related` + `State of Good Repair` + `Service Improvement and Enhancement`) |>
  select(-`Growth Related`, -`State of Good Repair`, -`Service Improvement and Enhancement`)

# mean of all population, average household income, total budget and total building permits
mean_population <- mean(model_data$population)
mean_income <- mean(model_data$average_household_income)
mean_budget <- mean(model_data$total_budget)
mean_building_permits <- mean(model_data$total_building_permits)

# median of all population, average household income, total budget and total building permits
median_population <- median(model_data$population)
median_income <- median(model_data$average_household_income)
median_budget <- median(model_data$total_budget)
median_building_permits <- median(model_data$total_building_permits)

# standard deviation of all population, average household income, total budget and total building permits
sd_population <- sd(model_data$population)
sd_income <- sd(model_data$average_household_income)
sd_budget <- sd(model_data$total_budget)
sd_building_permits <- sd(model_data$total_building_permits)

# Create a data frame with the mean, median, and standard deviation of each variable
model_justification <- data.frame(
  Variable = c("Population", "Average Household Income", "Total Budget", "Total Building Permits"),
  Mean = c(mean_population, mean_income, mean_budget, mean_building_permits),
  Median = c(median_population, median_income, median_budget, median_building_permits),
  SD = c(sd_population, sd_income, sd_budget, sd_building_permits)
)

# standardize the variables
model_data <- model_data |>
  mutate(
    population = (population - mean_population) / sd_population,
    average_household_income = (average_household_income - mean_income) / sd_income,
    total_budget = (total_budget - mean_budget) / sd_budget,
    total_building_permits = (total_building_permits - mean_building_permits) / sd_building_permits
  )

#### Model ####

model_data$ward_id <- as.factor(model_data$ward_id)

model <- stan_glmer(
  formula = total_building_permits ~ total_budget + average_household_income + (1 | ward_id),
  data = model_data,
  family = gaussian(link = "identity"),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE)
)


#### Save model ####
saveRDS(
  model,
  file = here("models/model.rds")
)


