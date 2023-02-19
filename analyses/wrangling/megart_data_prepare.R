# prepare the data for analysis

renv::activate()

library(dplyr)
library(readr)
library(here)

df_megahr <- readr::read_delim(
  file = here::here(
    "data",
    "megahr",
    "cleaned",
    "data_megahr.delim"
  ),
  delim = "|"
)

df_megahr <- dplyr::filter(
  df_megahr,
  string_type == "word" & stimulus_acc == TRUE
)

readr::write_delim(
  df_megahr,
  file = here::here(
    "data",
    "megahr",
    "cleaned",
    "data_megahr.delim"
  ),
  delim = "|"
)
