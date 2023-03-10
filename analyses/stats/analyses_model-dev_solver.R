renv::activate()

library(here)
library(cmdstanr)
library(dplyr)

path_model <- here::here("analyses", "stats")

l_model_params <- list()

# mu and sigma for the alpha_0 distribution with 80% of values falling
# in [500, 2000]
solver_alpha <- cmdstanr::cmdstan_model(
  stan_file = here::here(
    path_model,
    "analyses_model-dev_solver_alpha.stan"
  )
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

l_model_params$alpha_zero <- list(
  "mu" = v_params_alpha[[1]],
  "sigma" = v_params_alpha[[2]]
)

# mu and sigma for beta distributions
