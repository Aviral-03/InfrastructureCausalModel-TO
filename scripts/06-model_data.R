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

# combine all the years data for each ward and for each category
model_data <- analysis_budget_data |>
  group_by(ward_id, category, ward) |>
  summarize(total_10_year = sum(total_10_year)) |>
  pivot_wider(names_from = category, values_from = total_10_year)

# combine the model data with the ward profile data
model_data <- model_data |>
  left_join(analysis_ward_data, by = "ward_id") |>
  select(ward_id, ward.x, population, average_household_income, `Growth Related`, `State of Good Repair`, `Service Improvement and Enhancement`) |>
  rename(ward = ward.x) |>
  left_join(analysis_building_permits, by = "ward_id") |>
  rename(growth_related = `Growth Related`, state_of_good_repair = `State of Good Repair`, service_improvement = `Service Improvement and Enhancement`)


#### Model ####


#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


