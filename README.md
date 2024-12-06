# Cross-Vendor and Temporal Pricing Trends in Beverages

## Overview

This study represents pricing trends in the Canadian grocery market, specifically for beverages. The dataset focuses on six major vendors: Walmart, Loblaws, NoFrills, Metro, Galleria, and TandT, spanning a temporal range from June to November. Variables include `current_price`, `old_price`, `vendor`, `month`, and `product_name`.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Jacob Fillipp's grouceries dataset. It can be downloaded at: https://jacobfilipp.com/hammer/.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.

## Raw Data Souce

Due to the large size of the source data, it was not able to be uploaded to the repo. The link directs to the data is as follows: 
https://jacobfilipp.com/hammer/

## Reading the Analysis Data
To read the `.parquet` file in R:
```R
library(arrow)
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")
```

## Statement on LLM usage

This project utilized OpenAI's ChatGPT to assist with drafting text, troubleshooting code, and refining project documentation. All outputs were reviewed and edited by the authors to ensure accuracy and relevance.

