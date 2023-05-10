renv::activate()

library(here)
library(readr)
library(cmdstanr)
library(dplyr)
library(stringr)

path_stats <- here::here(
  "analyses",
  "stats"
)
path_data_helpers <- here::here(
  "data",
  "helpers"
)

d_analysis <- readr::read_delim(
  here::here(
    "data",
    "analysis",
    "analysis-data.delim"
  ),
  delim = "|"
)
l_model_priors <- readRDS(
  here::here(
    path_data_helpers,
    "l_model_priors.RData"
  )
)
l_model_data <- readRDS(
  here::here(
    path_data_helpers,
    "l_analysis_data.RData"
  )
)

l_model_priors <- unlist(l_model_priors)
names(l_model_priors) <- names(l_model_priors) %>%
  stringr::str_replace_all(
    string = .,
    pattern = "\\.",
    replacement = "_"
  )

l_data <- c(l_model_data, l_model_priors)

model_prior_pred <- cmdstanr::cmdstan_model(
  stan_file = here::here(
    path_stats,
    "analyses_model-dev_prior-pred.stan"
  ),
  include_paths = path_stats
)

fit_prior_pred <- model_prior_pred$sample(
  data = l_data,
  chains = 4,
  parallel_chains = 4,
  iter_sampling = 200,
  fixed_param = TRUE
)

fit_prior_pred$save_object(file = here::here(
  path_stats,
  "analyses_model-dev_prior-pred_fit.RData"
))
