#### Preamble ####
# Purpose: Test the simulated data for the project
# Author: Aviral Bhardwaj
# Date: 2024-12-01
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the correct working directory.


#### Workspace setup ####
library(tidyverse)

# Load the simulated data
ward_data <- read_csv(here::here("data/00-simulated_data/ward_data.csv"))
analysis_budget <- read_csv(here::here("data/00-simulated_data/analysis_budget.csv"))
building_permits <- read_csv(here::here("data/00-simulated_data/building_permits.csv"))

# Test if the data was successfully loaded
if (all(c("ward_data", "analysis_budget", "building_permits") %in% ls())) {
  message("Test Passed: Data loaded successfully.")
} else {
  stop("Test Failed: Data not loaded.")
}


#### Test data ####
# 1. Row Count Check for `ward_id`
if (nrow(ward_id) == 25) {
  print("Test Passed: `ward_id` has exactly 25 rows")
} else {
  print("Test Failed: `ward_id` does not have 25 rows")
}

# 2. Column Count Check for `ward_id`
if (ncol(ward_id) == 2) {
  print("Test Passed: `ward_id` has exactly 2 columns")
} else {
  print("Test Failed: `ward_id` does not have 2 columns")
}

# 3. Ward Names Uniqueness
if (length(unique(ward_id$ward)) == 25) {
  print("Test Passed: `ward` column has unique values")
} else {
  print("Test Failed: `ward` column does not have unique values")
}

# 4. Missing Values Check for `ward_id`
if (all(!is.na(ward_id))) {
  print("Test Passed: `ward_id` contains no missing values")
} else {
  print("Test Failed: `ward_id` contains missing values")
}

# 5. Valid `category` Values in `analysis_budget`
valid_categories <- c("A", "B", "C", "D")
if (all(analysis_budget$category %in% valid_categories)) {
  print("Test Passed: `category` contains only valid values")
} else {
  print("Test Failed: `category` contains invalid values")
}

# 6. Year Range Check in `analysis_budget`
if (all(analysis_budget$year >= 2021 & analysis_budget$year <= 2024)) {
  print("Test Passed: `year` values in `analysis_budget` are between 2021 and 2024")
} else {
  print("Test Failed: `year` values are out of range")
}

# 7. Non-Negative Budget in `analysis_budget`
if (all(analysis_budget$budget >= 0)) {
  print("Test Passed: `budget` values are non-negative")
} else {
  print("Test Failed: `budget` contains negative values")
}

# 8. Population Range Check in `ward_data`
if (all(ward_data$population >= 10000 & ward_data$population <= 100000)) {
  print("Test Passed: `population` values in `ward_data` are between 10,000 and 100,000")
} else {
  print("Test Failed: `population` values are out of range")
}

# 9. Income Range Check in `ward_data`
if (all(ward_data$average_household_income >= 50000 & ward_data$average_household_income <= 100000)) {
  print("Test Passed: `average_household_income` values are between 50,000 and 100,000")
} else {
  print("Test Failed: `average_household_income` values are out of range")
}

# 10. Building Permits Range Check
if (all(building_permits$number_of_permits >= 100 & building_permits$number_of_permits <= 1000)) {
  print("Test Passed: `number_of_permits` values are between 100 and 1,000")
} else {
  print("Test Failed: `number_of_permits` values are out of range")
}

# 11. No Duplicates in `ward_id` of `analysis_budget`
if (length(unique(analysis_budget$ward_id)) == nrow(analysis_budget)) {
  print("Test Passed: `ward_id` in `analysis_budget` is not duplicated")
} else {
  print("Test Failed: `ward_id` in `analysis_budget` is duplicated")
}

# 12. Valid Ward IDs in `analysis_budget`
if (all(analysis_budget$ward_id %in% 1:25)) {
  print("Test Passed: `ward_id` values in `analysis_budget` are valid (from 1 to 25)")
} else {
  print("Test Failed: `ward_id` values in `analysis_budget` are invalid")
}

# 13. Missing Values Check for `ward_data`
if (all(!is.na(ward_data))) {
  print("Test Passed: `ward_data` contains no missing values")
} else {
  print("Test Failed: `ward_data` contains missing values")
}

# 14. Check for Empty Strings in `ward`
if (any(ward_id$ward == "")) {
  print("Test Failed: Empty string found in `ward`")
} else {
  print("Test Passed: No empty strings in `ward`")
}

# 15. Check for Duplicate Rows in `building_permits`
if (nrow(building_permits) == nrow(distinct(building_permits))) {
  print("Test Passed: `building_permits` contains no duplicate rows")
} else {
  print("Test Failed: `building_permits` contains duplicate rows")
}
# Test for uniqueness of ward_id
if (all(duplicated(analysis_budget$ward_id) == FALSE)) {
  print("Test Passed: ward_id is unique in analysis_budget")
} else {
  print("Test Failed: ward_id is duplicated in analysis_budget")
}

if (all(duplicated(ward_data$ward_id) == FALSE)) {
  print("Test Passed: ward_id is unique in ward_data")
} else {
  print("Test Failed: ward_id is duplicated in ward_data")
}

if (all(duplicated(building_permits$ward_id) == FALSE)) {
  print("Test Passed: ward_id is unique in building_permits")
} else {
  print("Test Failed: ward_id is duplicated in building_permits")
}

