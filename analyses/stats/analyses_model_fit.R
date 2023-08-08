library(here)
library(readr)
library(dplyr)
library(cmdstanr)

l_analysis_data <- readRDS(
  file = here::here(
    "data",
    "helpers",
    "l_analysis_data.RData"
  )
)

model_final <- cmdstanr::cmdstan_model(
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
  ),
  stanc_options = list("O1")
)

model_fit <- model_final$sample(
  data = l_analysis_data,
  chains = 4,
  parallel_chains = 4,
  iter_warmup = 3000,
  iter_sampling = 10000,
  refresh = 10
)

model_fit$save_object(
  file = here::here(
    "analyses",
    "stats",
    "analyses_model_fit.RData"
  )
)
