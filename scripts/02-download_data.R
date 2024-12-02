#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto.
# Author: Aviral Bhardwaj
# Date: 2024-12-01
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: N.A
# Any other information needed? N.A


#### Work-space setup ####

library(tidyverse)
library(readxl)
library(styler)
library(dplyr)
library(here)

#### Download data ####

# Define a function to download, read, and save data
download_and_save <- function(url, output_file) {
  local_file <- tempfile(fileext = ".csv")
  download.file(url, local_file, mode = "wb")
  if (grepl("xlsx$", url)) {
    data <- readxl::read_xlsx(local_file)
  } else
    data <- readr::read_csv(local_file)
  write_csv(data, output_file)
  unlink(local_file)
  return(data)
}

# List of URLs and output file names
datasets <- list(
  "ward_profile_data" = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/6678e1a6-d25f-4dff-b2b7-aa8f042bc2eb/resource/16a31e1d-b4d9-4cf0-b5b3-2e3937cb4121/download/2023-WardProfiles-2011-2021-CensusData.xlsx",
  "budget_data_2024" = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7d3bcf2f-8eca-4ed5-a352-a34adb130931/resource/6b774b3a-5e1a-4362-ba31-a3b07fce31db/download/2024-2033-capital-budget-and-plan-details.xlsx",
  "budget_data_2023" = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7d3bcf2f-8eca-4ed5-a352-a34adb130931/resource/50f76ab0-3ed3-41b4-8350-49c2c52911f9/download/2023-2032-capital-budget-and-plan-details.xlsx",
  "budget_data_2022" = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7d3bcf2f-8eca-4ed5-a352-a34adb130931/resource/2640ca61-9eae-4d0d-89b2-523952c2b611/download/2022-2031-capital-budget-and-plan-details.xlsx",
  "budget_data_2021" = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7d3bcf2f-8eca-4ed5-a352-a34adb130931/resource/921832d8-d3cd-4e30-84f8-2e76b9b23191/download/2021-2030-capital-budget-and-plan-details.xlsx",
  "short_term_rental" = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/2ab20f80-3599-486a-8f8a-9cb59117977c/resource/9c235257-b09f-441e-bcad-1495607f9a82/download/short-term-rental-registrations-data.csv",
  "building_permits_data" = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/108c2bd1-6945-46f6-af92-02f5658ee7f7/resource/dfce3b7b-4f17-4a9d-9155-5e390a5ffa97/download/building-permits-active-permits.csv"
)

# Download and save all data sets
output_folder <- here::here("data", "01-raw_data")

data_list <- lapply(names(datasets), function(name) {
  output_file <- file.path(output_folder, paste0(name, ".csv"))
  download_and_save(datasets[[name]], output_file)
})

