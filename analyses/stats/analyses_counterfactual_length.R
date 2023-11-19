library(here)
library(cmdstanr)
library(readr)
library(dplyr)

l_data <- readRDS(here::here("data", "helpers", "l_analysis_data.RData"))

model_fit <- readRDS(here::here("analyses", "stats", "analyses_model_fit.RData"))

model_variables <- c(
  "alpha_0",
  "sigma_rt"
)

model_summary <- model_fit$summary(
  variables = model_variables
) %>%
  dplyr::select(
    .,
    1:2
  )
posterior_means <- model_summary$mean
names(posterior_means) <- model_summary$variable

# select random sample of draws
model_draws <- model_fit$draws()
N_draws <- 125
set.seed(1)
idx_sample <- sample(
  x = 1:dim(model_draws)[1],
  size = N_draws,
  replace = FALSE
)
model_draws_sample <- model_draws[idx_sample, , ]
dimnames(model_draws_sample)$iteration <- 1:length(idx_sample)

counterfactual_model <- cmdstanr::cmdstan_model(
  stan_file = here::here(
    "analyses",
    "stats",
    "analyses_counterfactual_length.stan"
  ),
  include_paths = c(
    here::here(
      "helpers"
    ),
    here::here("analyses", "stats")
  ),
  stanc_options = list("O1")
)

l_data[["N_subsample"]] <- N_draws
l_data[["min_wordlen"]] <- 2
l_data[["max_wordlen"]] <- 12
l_data[["alpha_0_fixed"]] <- posterior_means[["alpha_0"]]
l_data[["sigma_rt_fixed"]] <- posterior_means[["sigma_rt"]]
l_data[["sub_freq_fixed"]] <- 3
l_data[["aoa_fixed"]] <- 18
l_data[["concreteness_fixed"]] <- 3

counterfactual_lengths <- counterfactual_model$generate_quantities(
  model_draws_sample,
  data = l_data,
  parallel_chains = 4,
  sig_figs = 4
)

counterfactual_lengths_summary <- counterfactual_lengths$summary(
  "mean" = mean,
  "median" = median,
  "quantiles" = ~ quantile(., probs = c(.025, .975))
)
