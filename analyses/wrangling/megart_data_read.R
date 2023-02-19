# load the data from the two data collection cycles, picking only the relevant
# columns, and combine them into a single dataset
renv::activate()

library(readr)
library(here)
library(dplyr)

v_select_cols <- c(
  "id", "session", "block_no", "block_in_session", "trial", "overall_acc_in_session",
  "stimulus_acc", "stimulus_rt", "string", "string_type"
)

df_megahr_1 <- readr::read_csv(
  file = here::here(
    "data",
    "megahr",
    "raw",
    "cda1012_dat_c_reaction-times_1.csv"
  ),
  col_select = v_select_cols
)

df_megahr_2 <- readr::read_csv(
  file = here::here(
    "data",
    "megahr",
    "raw",
    "cda1012_dat_c_reaction-times_2.csv"
  ),
  col_select = v_select_cols
)

df_megahr <- dplyr::bind_rows(
  df_megahr_1,
  df_megahr_2
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
