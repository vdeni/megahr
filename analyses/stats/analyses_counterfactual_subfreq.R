library(here)
library(cmdstanr)
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)

l_data <- readRDS(here::here("data", "helpers", "l_analysis_data.RData"))

model_fit <- readRDS(
    here::here(
        "analyses",
        "stats",
        "analyses_model_fit.RData"
    )
)

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
N_draws <- 1000
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
        "analyses_counterfactual_subfreq.stan"
    ),
    include_paths = c(
        here::here(
            "helpers"
        ),
        here::here("analyses", "stats")
    ),
    stanc_options = list("O1")
)

subfreq_counterfactual <- seq(1, 5, by = 0.1)

l_data[["N_subsample"]] <- 1000
l_data[["alpha_0_fixed"]] <- posterior_means[["alpha_0"]]
l_data[["sigma_rt_fixed"]] <- posterior_means[["sigma_rt"]]
l_data[["aoa_fixed"]] <- 18
l_data[["concreteness_fixed"]] <- 3
l_data[["length_fixed"]] <- 7
l_data[["subfreq_counterfactual"]] <- subfreq_counterfactual
l_data[["N_subfreq_counterfactual"]] <- length(subfreq_counterfactual)

counterfactual_subfreq <- counterfactual_model$generate_quantities(
    model_draws_sample,
    data = l_data,
    parallel_chains = 4,
    sig_figs = 4
)

counterfactual_subfreq_summary <- counterfactual_subfreq$summary(
    "mean" = mean,
    "quantiles" = ~ quantile(., probs = c(.025, .975))
) %>%
    dplyr::rename(
        .,
        "q025" = "2.5%",
        "q975" = "97.5%"
    )

counterfactual_subfreq_summary$subfreq <- stringr::str_extract(
    counterfactual_subfreq_summary$variable,
    r"{\d+(?=\])}"
) %>%
    as.integer(.) %>%
    {
        subfreq_counterfactual[.]
    }

counterfactual_subfreq_summary$rt_id <- stringr::str_extract(
    counterfactual_subfreq_summary$variable,
    r"{(?<=\[)\d+}"
) %>%
    as.integer(.)

plot_data <- dplyr::summarise(
    counterfactual_subfreq_summary,
    m_rt = mean(mean),
    m_stderr_q025 = quantile(mean, .025),
    m_stderr_q975 = quantile(mean, .975),
    m_q025 = mean(q025),
    m_q975 = mean(q975),
    .by = "subfreq"
)

p_subfreq <- ggplot2::ggplot(
    data = plot_data,
    mapping = ggplot2::aes(
        x = subfreq,
        y = m_rt,
        ymin = m_q025,
        ymax = m_q975
    )
) +
    ggplot2::geom_ribbon(fill = "lightgray", alpha = 0.8) +
    ggplot2::geom_ribbon(
        fill = "darkgray",
        inherit.aes = FALSE,
        data = plot_data,
        mapping = ggplot2::aes(
            ymin = m_stderr_q025,
            ymax = m_stderr_q975,
            x = subfreq
        )
    ) +
    ggplot2::geom_line(linewidth = 0.3) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
        panel.grid.major.x = ggplot2::element_line(
            color = "grey",
            linetype = "dashed",
            linewidth = 0.5
        ),
        panel.grid.minor.x = ggplot2::element_line(
            color = "grey",
            linetype = "dashed",
            linewidth = 0.5
        ),
        panel.grid.major.y = ggplot2::element_line(
            color = "grey",
            linetype = "dashed",
            linewidth = 0.5
        ),
        panel.grid.minor.y = ggplot2::element_blank()
    ) +
    ggplot2::scale_y_continuous(
        breaks = seq(0, 1400, by = 200),
        limits = c(0, 1230),
        labels = seq(0, 1400, by = 200),
        minor_breaks = seq(0, 1400, by = 100)
    ) +
    ggplot2::labs(
        x = "Subjective frequency rating",
        y = "Reaction time (ms)"
    )

saveRDS(
    p_subfreq,
    file = here::here(
        "analyses",
        "stats",
        "p_counterfactual_subfreq.RData"
    )
)
