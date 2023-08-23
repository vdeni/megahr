library(here)
library(cmdstanr)

model_fit <- readRDS(here::here("analyses", "stats", "analyses_model_fit.RData"))

model_draws <- model_fit$draws()

# select random sample of draws
set.seed(1)
idx_sample <- sample(
  x = 1:dim(model_draws)[1],
  size = 200,
  replace = FALSE
)
model_draws_sample <- model_draws[idx_sample, , ]

l_data <- readRDS(here::here("data", "helpers", "l_analysis_data.RData"))

m_gen_quant <- cmdstanr::cmdstan_model(
  here::here(
    "analyses",
    "stats",
    "analyses_model_generated-quantities.stan"
  ),
  include_paths = c(
    here::here("analyses", "stats"),
    here::here("helpers")
  )
)

fit_gen_quant <- m_gen_quant$generate_quantities(
  model_draws_sample,
  data = l_data,
  parallel_chains = 4,
  sig_figs = 4
)

fit_gen_quant$save_object(
  here::here(
    "analyses",
    "stats",
    "analyses_stats_generated-quantities.RData"
  )
)
