#### Preamble ####
# Purpose: Test the simulated data for the project
# Author: Aviral Bhardwaj
# Date: 2024-12-01
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - 02-download_data.R must be run before this script
# - 03-clean_data.R must be run before this script
# Any other information needed? Make sure you are in the correct working directory.


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(readr)
library(dplyr)

# Load the cleaned analysis data
ward_data <-read.csv(here::here("data/02-analysis_data/analysis_ward_data.csv"))
budget_data <- read.csv(here::here("data/02-analysis_data/analysis_budget_data.csv"))
building_permits <- read.csv(here::here("data/02-analysis_data/analysis_building_permits.csv"))

#### Test data ####
test_that("Budget Data Integrity Tests", {
  expect_true(all(is.integer(budget_data$ward_id)))
  expect_true(all(budget_data$year %in% c(2021, 2022, 2023, 2024)))
  expect_false(any(is.na(budget_data$ward_id)))
  expect_false(any(is.na(budget_data$ward)))
  expect_false(any(is.na(budget_data$category)))
  expect_false(any(is.na(budget_data$total_10_year)))
  expect_false(any(is.na(budget_data$year)))
})

test_that("Building Permits Data Tests", {
  expect_equal(ncol(building_permits), 2)
  expect_true(all(names(building_permits) == c("ward_id", "total_building_permits")))
  expect_equal(n_distinct(building_permits$ward_id), nrow(building_permits))
  expect_true(all(building_permits$total_building_permits > 0))
})

test_that("Ward Data Integrity", {
  expect_equal(ncol(ward_data), 4)
  expect_true(all(names(ward_data) == c("ward_id", "ward", "population", "average_household_income")))
  expect_equal(n_distinct(ward_data$ward_id), nrow(ward_data))
  expect_true(all(as.numeric(ward_data$population) > 0))
  expect_true(all(as.numeric(ward_data$average_household_income) > 0))
})

test_that("Specific Ward Validations", {
  spadina_budget <- budget_data %>% 
    filter(ward_id == 10 & year == 2023)
  
  expect_true(nrow(spadina_budget) == 3)
    expect_true(building_permits$total_building_permits[building_permits$ward_id == 10] > 5000)
})

test_that("Data Completeness", {
  years_count <- budget_data %>%
    group_by(year) %>%
    summarize(ward_count = n_distinct(ward_id), .groups = "drop")
  expect_true(length(unique(years_count$ward_count)) == 1)
    expect_equal(nrow(budget_data), n_distinct(budget_data))
  expect_equal(nrow(building_permits), n_distinct(building_permits))
  expect_equal(nrow(ward_data), n_distinct(ward_data))
})

test_that("Income and Population Distributions", {
  expect_true(all(as.numeric(ward_data$population) >= 50000 & 
                    as.numeric(ward_data$population) <= 200000))
  
  expect_true(all(as.numeric(ward_data$average_household_income) >= 50000 & 
                    as.numeric(ward_data$average_household_income) <= 250000))
})

test_that("Budget Data Consistency", {
  expect_true(all(budget_data$total_10_year < 100000000))
})

test_that("Building Permit Data Consistency", {
  expect_true(all(building_permits$total_building_permits < 100000))
})

test_that("Ward Data Consistency", {
  expect_true(all(ward_data$population < 500000))
  expect_true(all(ward_data$average_household_income < 500000))
})

test_that("Data Types", {
  # check if ward_id is integer
  expect_true(is.integer(ward_data$ward_id))
  expect_true(is.integer(budget_data$ward_id))
  expect_true(is.integer(building_permits$ward_id))
  # check if ward is character
  expect_true(is.character(ward_data$ward))
  # check if population and average_household_income are numeric
  expect_true(is.numeric(ward_data$population))
  expect_true(is.numeric(ward_data$average_household_income))
  # check if year is integer
  expect_true(is.integer(budget_data$year))
  # check if total_10_year is numeric
  expect_true(is.numeric(budget_data$total_10_year))
})

test_that("Ward ID Integrity", {
  expect_true(all(ward_data$ward_id > 0))
  expect_true(all(ward_data$ward_id == floor(ward_data$ward_id)))
})

test_that("Building Permits Data Range", {
  expect_true(all(building_permits$total_building_permits >= 0))
  expect_true(all(building_permits$total_building_permits <= 10000))
})

test_that("Population Data Integrity", {
  expect_true(all(ward_data$population %% 1 == 0)) # Population should be integers
})

test_that("Household Income Data Integrity", {
  expect_true(all(ward_data$average_household_income %% 1 == 0)) # Income should be integers
})

test_that("Ward Population Consistency", {
  expect_true(all(ward_data$population > 0))
  expect_true(all(ward_data$population < 1000000))
})

test_that("Budget Total Consistency", {
  expect_true(all(budget_data$total_10_year >= 0))
})

test_that("Year Range Consistency", {
  expect_true(all(budget_data$year >= 2021 & budget_data$year <= 2024))
})

test_that("Ward Name Consistency", {
  expect_true(all(nchar(ward_data$ward) >= 3))
  expect_true(all(nchar(ward_data$ward) <= 50))
})

