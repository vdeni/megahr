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

l_model_priors <- readRDS(
  file = here::here(
    "data",
    "helpers",
    "l_model_priors.RData"
  )
)

model_fit <- cmdstanr::cmdstan_model(
  stan_file = here::here(
    "analyses",
    "stats",
    "analyses_model_fit.stan"
  ),
  include_paths = c(
    here::here(
      "helpers"
    ),
    here::here("analyses", "stats")
  )
)
