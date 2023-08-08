library(cmdstanr)
library(here)
library(dplyr)
library(bayesplot)
library(stringr)

m_fit <- readRDS(
  here::here(
    "analyses",
    "stats",
    "01_fit.RData"
  )
)

m_summary <- m_fit$summary()

m_summary$rhat %>%
  range()

m_summary$ess_bulk %>%
  range()

# which parameters have ess_bulk less than or equal to 500
m_summary %>%
  dplyr::filter(
    .,
    ess_bulk <= 500
  ) %>%
  dplyr::pull(variable)

# about half of the per-participant parameters

# check the graphs
m_draws <- m_fit$draws(format = "draws_array")

# alpha
set.seed(1)

visualisation_params <- m_summary$variable %>%
  stringr::str_subset(
    string = .,
    pattern = "alpha"
  ) %>%
  sample(., size = 12, replace = FALSE)

bayesplot::mcmc_trace(
  x = m_draws,
  pars = visualisation_params
)

visualisation_params <- m_summary$variable %>%
  stringr::str_subset(
    string = .,
    pattern = "beta"
  )

bayesplot::mcmc_trace(
  x = m_draws,
  pars = visualisation_params
)

visualisation_params <- m_summary$variable %>%
  stringr::str_subset(
    string = .,
    pattern = "gamma"
  ) %>%
  sample(., size = 12, replace = FALSE)

bayesplot::mcmc_trace(
  x = m_draws,
  pars = visualisation_params
)


visualisation_params <- m_summary$variable %>%
  stringr::str_subset(
    string = .,
    pattern = "delta"
  ) %>%
  sample(., size = 12, replace = FALSE)

bayesplot::mcmc_trace(
  x = m_draws,
  pars = visualisation_params
)


visualisation_params <- m_summary$variable %>%
  stringr::str_subset(
    string = .,
    pattern = "sigma"
  )

bayesplot::mcmc_trace(
  x = m_draws,
  pars = visualisation_params
)
