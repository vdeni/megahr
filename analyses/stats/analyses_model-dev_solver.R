library(here)
library(cmdstanr)
library(dplyr)

path_model <- here::here("analyses", "stats")

l_model_priors <- list()

# mu and sigma for the alpha_0 distribution with 80% of values falling
# in [500, 2000]
solver_alpha <- cmdstanr::cmdstan_model(
  stan_file = here::here(
    path_model,
    "analyses_model-dev_solver_alpha.stan"
  ),
)
params_alpha <- solver_alpha$sample(
  data = list(
    "quantiles_alpha" = c(500, 2000)
  ),
  chains = 1,
  iter_sampling = 100,
  parallel_chains = 1,
  fixed_param = TRUE
)
v_params_alpha <- params_alpha$summary() %>%
  dplyr::pull("mean") %>%
  as.vector(.)

l_model_priors$prior_alpha_0_mu <- v_params_alpha[1]
l_model_priors$prior_alpha_0_sigma <- v_params_alpha[2]


# mu and sigma for beta distributions
solver_beta <- cmdstanr::cmdstan_model(
  stan_file = here::here(
    path_model,
    "analyses_model-dev_solver_beta.stan"
  )
)

# constrain beta_length so that 80% values are between [-0.1, 0.1]
params_beta_len <- solver_beta$sample(
  data = list(
    "quantiles_beta" = c(-0.1, 0.1),
    "beta_guess" = c(0, 0.1)
  ),
  chains = 1,
  iter_sampling = 100,
  parallel_chains = 1,
  fixed_param = TRUE
)
v_params_beta_len <- params_beta_len$summary() %>%
  dplyr::pull("mean") %>%
  as.vector(.)

l_model_priors$prior_beta_len_mu <- v_params_beta_len[1]
l_model_priors$prior_beta_len_sigma <- v_params_beta_len[2]

# constrain beta_subfreq so that 80% values are between [-0.2, 0.2]
params_beta_subfreq <- solver_beta$sample(
  data = list(
    "quantiles_beta" = c(-0.2, 0.2),
    "beta_guess" = c(0, 0.15)
  ),
  chains = 1,
  iter_sampling = 100,
  parallel_chains = 1,
  fixed_param = TRUE
)
v_params_beta_subfreq <- params_beta_subfreq$summary() %>%
  dplyr::pull("mean") %>%
  as.vector(.)

l_model_priors$prior_beta_subfreq_mu <- v_params_beta_subfreq[1]
l_model_priors$prior_beta_subfreq_sigma <- v_params_beta_subfreq[2]

# constrain beta_aoa so that 80% values are between [-0.07, 0.07]
params_beta_aoa <- solver_beta$sample(
  data = list(
    "quantiles_beta" = c(-0.07, 0.07),
    "beta_guess" = c(0, 0.035)
  ),
  chains = 1,
  iter_sampling = 100,
  parallel_chains = 1,
  fixed_param = TRUE
)
v_params_beta_aoa <- params_beta_aoa$summary() %>%
  dplyr::pull("mean") %>%
  as.vector(.)

l_model_priors$prior_beta_aoa_mu <- v_params_beta_aoa[1]
l_model_priors$prior_beta_aoa_sigma <- v_params_beta_aoa[2]

# constrain beta_concrete so that 80% values are between [-0.07, 0.07]
params_beta_concrete <- solver_beta$sample(
  data = list(
    "quantiles_beta" = c(-0.07, 0.07),
    "beta_guess" = c(0, 0.035)
  ),
  chains = 1,
  iter_sampling = 100,
  parallel_chains = 1,
  fixed_param = TRUE
)
v_params_beta_concrete <- params_beta_concrete$summary() %>%
  dplyr::pull("mean") %>%
  as.vector(.)

l_model_priors$prior_beta_concrete_mu <- v_params_beta_concrete[1]
l_model_priors$prior_beta_concrete_sigma <- v_params_beta_concrete[2]

# constrain sigma so that 80% values are between [0.2, 1]
solver_sigma <- cmdstanr::cmdstan_model(
  stan_file = here::here(
    path_model,
    "analyses_model-dev_solver_sigma.stan"
  )
)
params_sigma <- solver_sigma$sample(
  data = list(
    "quantiles_sigma" = c(0.2, 1),
    "sigma_guess" = c(2)
  ),
  chains = 1,
  iter_sampling = 100,
  parallel_chains = 1,
  fixed_param = TRUE
)
v_params_sigma <- params_sigma$summary() %>%
  dplyr::pull("mean") %>%
  as.vector(.)

l_model_priors$prior_sigma_rate <- v_params_sigma[1]

# round all to three decimal places
l_model_priors <- lapply(
  X = l_model_priors,
  FUN = round,
  digits = 3
)

# add manually chosen hyperparameters
l_model_priors$prior_alpha_participants_mu <- 0
l_model_priors$prior_alpha_participants_sigma <- 0.1

l_model_priors$prior_gamma_words_mu <- 0
l_model_priors$prior_gamma_words_sigma <- 0.1

l_model_priors$prior_delta_shape <- 160
l_model_priors$prior_delta_rate <- 0.55

saveRDS(
  object = l_model_priors,
  file = here::here(
    "data",
    "helpers",
    "l_model_priors.RData"
  )
)
