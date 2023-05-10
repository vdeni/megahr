renv::activate()

library(here)
library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(stringr)

m_fit <- readRDS(here::here("analyses/stats/analyses_model-dev_prior-pred_fit.RData"))

d_draws <- m_fit$draws(format = "df") %>%
  tibble::as_tibble(.)

d_draws_long <- dplyr::select(
  d_draws,
  dplyr::matches("rt_rep")
) %>%
  tidyr::pivot_longer(
    data = .,
    cols = dplyr::everything(),
    names_pattern = "rt_rep\\[(\\d+)\\]",
    names_to = "rt_id",
    values_to = "rt_rep",
    names_transform = as.integer
  )

set.seed(1)
v_select <- sample(1:max(d_draws_long$rt_id), 30, replace = FALSE)
p_hist_multiples <- dplyr::filter(
  d_draws_long,
  rt_id %in% v_select
) %>%
  ggplot2::ggplot(
    data = .,
    mapping = ggplot2::aes(
      x = rt_rep
    )
  ) +
  ggplot2::geom_histogram(
    binwidth = 50
  ) +
  ggplot2::facet_wrap(
    facets = "rt_id"
  ) +
  ggplot2::coord_cartesian(xlim = c(0, 3000))
