#### Preamble ####
# Purpose: Simulate data for the project
# Author: Aviral Bhardwaj
# Date: 2024-12-01
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: N.A
# Any other information needed? N.A

#### Workspace setup ####
library(tidyverse)
set.seed(9407)


#### Simulate data ####
ward_id <- tibble(ward = 1:25)
ward_names <- c("Etobicoke North", "Etobicoke Centre", "Etobicoke-Lakeshore",
                "Parkdale-High Park","York South-Weston", "York Centre",
                "Humber River-Black Creek", "Eglinton-Lawrence",
                "Davenport", "Spadina-Fort York", "University-Rosedale",
                "Toronto-St. Paul's", "Toronto Centre", "Toronto-Danforth",
                "Don Valley West", "Don Valley East", "Don Valley North",
                "Willowdale", "Beaches-East York", "Scarborough Southwest",
                "Scarborough Centre", "Scarborough-Agincourt",
                "Scarborough North", "Scarborough-Guildwood",
                "Scarborough-Rouge Park")

ward_id <- ward_id |>
  mutate(ward_name = ward_names) |>
  rename(ward_id = ward) |>
  rename(ward = ward_name)

category <- c("A", "B", "C", "D")

# Simulate analysis budget data
analysis_budget <- tibble(ward_id = sample(1:25, 100, replace = TRUE),
                          category = sample(category, 100, replace = TRUE),
                          budget = runif(100, 10000, 100000),
                          year = sample(2021:2024, 100, replace = TRUE)) |>
  left_join(ward_id, by = "ward_id")

# Simulate ward data
ward_data <- tibble(ward_id = 1:25,
                    population = sample(10000:100000, 25),
                    average_household_income = sample(50000:100000, 25)) |>
  left_join(ward_id, by = "ward_id")

# Simulate building permit data
building_permits <- tibble(ward_id = 1:25,
                           number_of_permits = sample(100:1000, 25)) |>
  left_join(ward_id, by = "ward_id")

#### Save data ####
write.csv(ward_data, here::here("data/00-simulated_data/ward_data.csv"), row.names = FALSE)
write.csv(analysis_budget, here::here("data/00-simulated_data/analysis_budget.csv"), row.names = FALSE)
write.csv(building_permits, here::here("data/00-simulated_data/building_permits.csv"), row.names = FALSE)
