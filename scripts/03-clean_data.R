#### Preamble ####
# Purpose: Cleans the raw ward profile, ward capital budget data and building permit data
# Author: Aviral Bhardwaj
# Date: 2024-12-01
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: N.A
# Any other information needed? N.A

#### Works-pace setup ####
library(tidyverse)
library(here)

#### Clean data ####
input_folder <- here::here("data/01-raw_data")
output_folder <- here::here("data/02-analysis_data")

## Cleaning Budget Data

years <- c(2021, 2022, 2023)

# Function to clean data
clean_capital_data <- function(file_path, year) {
  raw_data <- read_csv(file_path)

  cleaned_data <- raw_data[c("Ward Number", "Ward", "Category", "Total 10 Year")] |>
    rename(
      ward_id = "Ward Number",
      ward = "Ward",
      category = "Category",
      total_10_year = "Total 10 Year"
    ) |>
    filter(ward_id != "CW") |>
    group_by(ward_id, ward, category) |>
    summarise(total_10_year = sum(total_10_year), .groups = "drop") |>
    mutate(ward_id = as.numeric(ward_id)) |>
    arrange(ward_id)

  # Save cleaned data to a csv file
  output_file <- file.path(output_folder, paste0("cleaned_data_", year, ".csv"))
  write.csv(cleaned_data, output_file, row.names = FALSE)

  return(cleaned_data)
}

# Process and clean data for each year
cleaned_data <-
  lapply(years, function(year) {
    file_path <- file.path(input_folder, paste0("budget_data_", year, ".csv"))
    clean_capital_data(file_path, year)
  })


cleaned_2024 <- read_csv(here::here("data/01-raw_data/budget_data_2024.csv"))

# Only keep the relevant columns with name Total 10 Year, Ward Number, Ward, Category
cleaned_capital_data <- cleaned_2024[c(14, 15, 16, 17)] |>
  rename("ward_id" = "Ward Number") |>
  rename("ward" = "Ward") |>
  rename("category" = "Category") |>
  rename("total_10years" = "total_10years")

# Filter out the rows in ward_id that are CW (city wide) as they are not relevant
cleaned_capital_data <- cleaned_capital_data %>%
  filter(ward_id != "CW")

# Combine the rows with the same ward_id and category and sum the total_10_year keep the ward_name
cleaned_capital_data <- cleaned_capital_data |>
  group_by(ward_id, ward, category) |>
  summarise(total_10years = sum(total_10years)) |>
  mutate(ward_id = as.numeric(ward_id)) |>
  arrange(ward_id) |>
  rename("total_10_year" = "total_10years")

# Save the cleaned data to a csv file
write.csv(cleaned_capital_data, here::here("data/02-analysis_data/cleaned_data_2024.csv"), row.names = FALSE)


# Prepare the data for analysis
capital_data_2024 <- read_csv(here::here("data/02-analysis_data/cleaned_data_2024.csv"))
capital_data_2023 <- read_csv(here::here("data/02-analysis_data/cleaned_data_2023.csv"))
capital_data_2022 <- read_csv(here::here("data/02-analysis_data/cleaned_data_2022.csv"))
capital_data_2021 <- read_csv(here::here("data/02-analysis_data/cleaned_data_2021.csv"))

# renaming categories in 2024 data
capital_data_2024 <- capital_data_2024 |>
  mutate(category = case_when(
    category == "State of Good Repair C03" ~ "State of Good Repair",
    category == "Growth Related C05" ~ "Growth Related",
    category == "Health and Safety C01" ~ "Health and Safety",
    category == "Service Improvement and Enhancement C04" ~ "Service Improvement and Enhancement",
    category == "Legislated C02" ~ "Legislated",
    category == "Other" ~ "Other"
  ))

capital_data_2021 <- capital_data_2021 |>
  mutate(year = 2021)

capital_data_2022 <- capital_data_2022 |>
  mutate(year = 2022)

capital_data_2023 <- capital_data_2023 |>
  mutate(year = 2023)

capital_data_2024 <- capital_data_2024 |>
  mutate(year = 2024)

# combine all the data
analysis_data <- bind_rows(capital_data_2021, capital_data_2022, capital_data_2023, capital_data_2024) |>
  #only keep state of good repair, growth related, service improvement and enhancement
  filter(category == "State of Good Repair" | category == "Growth Related" | category == "Service Improvement and Enhancement") |>
  # remove rows with missing ward_id
  filter(!is.na(ward_id)) |>
  # remove rows with missing total_10_year
  filter(!is.na(total_10_year)) |>
  # remove rows with negative total_10_year
  filter(total_10_year > 0)

# Remove the intermediate files
file.remove(here::here("data/02-analysis_data/cleaned_data_2021.csv"))
file.remove(here::here("data/02-analysis_data/cleaned_data_2022.csv"))
file.remove(here::here("data/02-analysis_data/cleaned_data_2023.csv"))
file.remove(here::here("data/02-analysis_data/cleaned_data_2024.csv"))


## Cleaning Raw Ward Profile Data
raw_ward_data <- read_csv(here::here("data/01-raw_data/ward_profile_data.csv"))

# Only keep the relevant columns:
cleaned_ward_data <-
  raw_ward_data[c(18, 997, 1307, 1383), ]

cleaned_ward_data <- as.data.frame(t(cleaned_ward_data)) |>
  slice(-1) |>
  slice(-1) |>
  rename(population = V1, income = V4)


# Add ward_id column:
cleaned_ward_data$ward_id = 1:25

# Set row name as ward_id
rownames(cleaned_ward_data) <- cleaned_ward_data$ward_id

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

# Add ward name column:
cleaned_ward_data$ward = ward_names

# Calculate the percentage of uneducated people in each ward:
cleaned_ward_data <- cleaned_ward_data[c("ward_id", "ward", "population", "income")] |>
  rename("average_household_income" = "income")


## Cleaning Building Permit Data

building_permits <- read_csv(here::here("data/01-raw_data/building_permits_data.csv"))
short_term_rental_data <- read_csv(here::here("data/01-raw_data/short_term_rental.csv"))

# create a dictionary of postal code to ward number
postal_code_to_ward <- short_term_rental_data |>
  select(ward_number, postal_code) |>
  distinct() |>
  filter(!is.na(postal_code)) |>
  filter(!is.na(ward_number)) |>
  group_by(postal_code) |>
  summarize(primary_ward = ward_number[which.max(table(ward_number))])


# remove rows with missing postal codes
building_permits <- building_permits |>
  filter(!is.na(POSTAL)) |>
  filter(STATUS == "Approved" | STATUS == "
Application Accepted" | STATUS == "Issuance Pending" | STATUS == "Ready for Issuance" | STATUS == "Permit Issued" | STATUS == "Permit Issued/Close File") |>
  filter(!is.na(POSTAL)) |>
  filter(!is.na(STATUS)) |>
  # filter(grepl("new building", WORK, ignore.case = TRUE)) |>
  left_join(postal_code_to_ward, by = c("POSTAL" = "postal_code")) |>
  filter(!is.na(primary_ward)) |>
  rename("ward_id" = "primary_ward")

# count the number of building permits in each ward
building_permits <- building_permits |>
  group_by(ward_id) |>
  summarize(n_building_permits = n(), .groups = "drop") |>
  arrange(ward_id) |>
  mutate(ward_id = as.numeric(ward_id)) |>
  rename("total_building_permits" = "n_building_permits")


#### Save data ####
write.csv(analysis_data, here::here("data/02-analysis_data/analysis_budget_data.csv"), row.names = FALSE)
write_parquet(analysis_data, here::here("data/02-analysis_data/analysis_budget_data.parquet"))
write.csv(cleaned_ward_data, here::here("data/02-analysis_data/analysis_ward_data.csv"), row.names = FALSE)
write_parquet(cleaned_ward_data, here::here("data/02-analysis_data/analysis_ward_data.parquet"))
write.csv(building_permits, here::here("data/02-analysis_data/analysis_building_permits.csv"), row.names = FALSE)
write_parquet(building_permits, here::here("data/02-analysis_data/analysis_building_permits.parquet"))



