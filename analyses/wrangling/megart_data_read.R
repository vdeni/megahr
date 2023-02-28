# load the data from the two data collection cycles, picking only the relevant
# columns, and combine them into a single dataset

renv::activate()

library(readr)
library(here)
library(dplyr)

v_select_cols <- c(
  "id",
  "session",
  "block_no",
  "block_in_session",
  "trial",
  "overall_acc_in_session",
  "stimulus_acc",
  "stimulus_rt",
  "string",
  "string_type"
)

df_megart_1 <- readr::read_csv(
  file = here::here(
    "data",
    "megart",
    "raw",
    "cda1012_dat_c_reaction-times_1.csv"
  ),
  col_select = dplyr::all_of(v_select_cols)
)

df_megart_2 <- readr::read_csv(
  file = here::here(
    "data",
    "megart",
    "raw",
    "cda1012_dat_c_reaction-times_2.csv"
  ),
  col_select = dplyr::all_of(v_select_cols)
)

df_megart <- dplyr::bind_rows(
  df_megart_1,
  df_megart_2
)

readr::write_delim(
  df_megart,
  file = here::here(
    "data",
    "megart",
    "clean",
    "data_megart.delim"
  ),
  delim = "|"
)
