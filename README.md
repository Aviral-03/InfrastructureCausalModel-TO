# Demographic Influences on Municipal Budget Allocation and Infrastructure Development in Toronto

## Overview

This study examines the relationship between population density, average house- hold income, and budget allocations across Toronto’s 25 wards and investigates their combined influence on construction activity. Using data from the city’s Capital Budget Plan, Ward Profiles, and Active Building Permits, we analyze spending patterns in key infrastructure-related areas. Employing a causal modeling approach, our findings reveal a negative association between population density and construction activity, despite some high-density wards receiving higher budget allocations. Additionally, average household income and total budget allocations exhibit a positive correlation with the number of building permits. These results underscore potential inequities in resource distribution, highlighting the need for data-driven and equitable urban budget planning to better address community needs.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from `opendatatoronto`.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.
-   `scripts` contains the R scripts used to simulate, download, clean, model and test data.
-   `models` contains fitted the model.
-   `other/datasheet` contains the files to generate the datasheet for the cleaned analysis dataset which created as a part of this study.
-   `other/sketches` contains the sketches for dataset and graphs.
-   `other/llm` contains the LLM conversation.

## Statement on LLM usage

ChatGPT4o (4o-mini) was used as an LLM for this project. Debugging, formating, and commenting was done using LLM.
All chat history for the LLM usage can be found in the `other/llm/usage.txt` folder
