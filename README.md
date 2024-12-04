# Demographic Influences on Municipal Budget Allocation and Infrastructure Development in Toronto

## Overview

This study investigates how population density and average household income affect budget allocations across Toronto’s 25 wards, and how these factors, along with budget allocation, influence construction projects. Using data from the city's \"Capital Budget Plan\", \"Ward Profiles\" and \"Active Building Permits\", we analyze spending patterns in key areas like related to infrastructre. Our analysis, guided by a causal model, reveals a negative association between population density and construction activity, with some high-density wards receiving significantly higher budget allocations. Average household income and total budget allocations were positively correlated with the number of building permits. These insights highlight potential disparities in resource distribution, emphasizing the need for more equitable urban budget planning to address diverse community needs.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from `opendatatoronto`.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `other` contains details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.
-   `scripts` contains the R scripts used to simulate, download, clean, model and test data.
-   `models` contains fitted the model.
-   `other/datasheet` contains the files to generate the datasheet for the cleaned analysis dataset which created as a part of this study.
-   `other/sketches` contains the sketches for dataset and graphs.
-   `other/llm` contains the LLM conversation.

## Statement on LLM usage

ChatGPT4o (4o-mini) was used as an LLM for this project. Debugging, formating, and commenting was done using LLM.
All chat history for the LLM usage can be found in the `other/llm/usage.txt` folder
