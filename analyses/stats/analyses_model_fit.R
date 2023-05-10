renv::activate()

library(here)
library(readr)
library(dplyr)
library(cmdstanr)

d_analysis <- readr::read_delim(
  file = here::here(
    "data",
    "analysis",
    "analysis-data.delim"
  ),
  delim = "|"
)
