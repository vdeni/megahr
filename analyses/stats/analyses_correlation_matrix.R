library(here)
library(cmdstanr)
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)
library(ggpubr)
library(stringr)

ggplot2::theme_set(ggplot2::theme_minimal())
ggplot2::theme_update(
    panel.grid.major.x = ggplot2::element_line(
        color = "gray",
        linewidth = 0.7
    ),
    panel.grid.major.y = ggplot2::element_line(
        color = "gray",
        linewidth = 0.7
    )
)

source(
    here::here(
        "helpers",
        "pooled-statistics.R"
    )
)

source(
    here::here(
        "helpers",
        "plotting.R"
    )
)

d_psyling <- readr::read_csv(
    here::here(
        "data",
        "psycholinguistic-estimates",
        "clean",
        "psycholinguistic-estimates.csv"
    )
) |>
    dplyr::select(
        string,
        imageability,
        imageability_n
    )

d_megart <- readr::read_delim(
    here::here(
        "data",
        "analysis",
        "analysis-data.delim"
    ),
    delim = "|"
)

v_psyling_dupes <- d_psyling$string[duplicated(d_psyling$string)]

d_psyling_dupes <- d_psyling |>
    dplyr::filter(
        string %in% v_psyling_dupes
    )

d_psyling_dupes_aggregated <- d_psyling_dupes |>
    dplyr::summarise(
        imageability = .pooled_mean(imageability, imageability_n),
        .by = string
    )

d_psyling_uniques <- d_psyling |>
    dplyr::filter(
        !string %in% v_psyling_dupes
    ) |>
    dplyr::select(
        string,
        imageability
    )

d_psyling_deduped <- dplyr::bind_rows(
    d_psyling_uniques,
    d_psyling_dupes_aggregated
)

d_combined <- dplyr::left_join(
    x = d_megart,
    y = d_psyling_deduped,
    suffix = c("_megart", "_psyling"),
    by = "string"
)

plot_configs <- list(
    "stimulus_rt" = list(
        limits = c(0, 4000),
        bins = 500,
        diag_plot = "hist"
    ),
    "num_letters" = list(
        diag_plot = "bar"
    ),
    "concreteness" = list(
        limits = c(1, 5),
        bins = 40,
        diag_plot = "hist"
    ),
    "subjective_frequency" = list(
        limits = c(1, 5),
        bins = 40,
        diag_plot = "hist"
    ),
    "aoa" = list(
        limits = c(1, 18),
        bins = 40,
        diag_plot = "hist"
    ),
    "imageability" = list(
        limits = c(1, 5),
        bins = 40,
        diag_plot = "hist"
    )
)

variable_combinations <- combn(x = names(plot_configs), m = 2)

diag_plots <- list()
for (colname in names(plot_configs)) {
    if (plot_configs[[colname]]$diag_plot == "hist") {
        p <- .hist_plot(
            d_combined,
            x = colname,
            x_limits = plot_configs[[colname]]$limits,
            bins = plot_configs[[colname]]$bins
        )
    } else if (plot_configs[[colname]]$diag_plot == "bar") {
        p <- .bar_plot(
            data = d_combined,
            x = colname
        )
    }
    diag_plots[[colname]] <- p
}

non_diag_plots <- list(
    "upper" = list(),
    "lower" = list()
)

for (col_idx in 1:ncol(variable_combinations)) {
    varname_x <- variable_combinations[1, col_idx]
    varname_y <- variable_combinations[2, col_idx]

    var_x <- d_combined[[variable_combinations[1, col_idx]]]
    var_y <- d_combined[[variable_combinations[2, col_idx]]]

    var_combn <- paste(
        varname_x,
        varname_y,
        sep = ","
    )

    non_diag_plots$upper[[var_combn]] <- .corr_plot(
        var_x = var_x,
        var_y = var_y
    )

    non_diag_plots$lower[[var_combn]] <- .scatter_plot(
        data = d_combined,
        var_x = varname_x,
        var_y = varname_y,
        x_limits = plot_configs[[varname_x]]$limits,
        y_limits = plot_configs[[varname_y]]$limits
    )
}

plot_list <- list()

for (row_idx in seq_along(names(diag_plots))) {
    for (col_idx in seq_along(names(diag_plots))) {
        if (row_idx == col_idx) {
            plot_list[[paste(row_idx, col_idx, sep = ",")]] <- diag_plots[[names(diag_plots)[row_idx]]]
            next
        }

        .search_var_1 <- names(diag_plots)[[row_idx]]
        .search_var_2 <- names(diag_plots)[[col_idx]]

        .is_target_combn <- which(
            stringr::str_detect(names(non_diag_plots$upper), .search_var_1) &
                stringr::str_detect(names(non_diag_plots$upper), .search_var_2)
        )

        if (row_idx < col_idx) {
            plot_list[[paste(row_idx, col_idx, sep = ",")]] <-
                non_diag_plots$upper[[.is_target_combn]]
        } else {
            plot_list[[paste(row_idx, col_idx, sep = ",")]] <-
                non_diag_plots$lower[[.is_target_combn]]
        }
    }
}

ggpubr::ggarrange(
    plotlist = plot_list,
    nrow = 6,
    ncol = 6,
    labels = list(
        "Reaction time (ms)", "Word length", "Concreteness",
        "Subjective frequency", "Age of acquisition", "Imageability",
        "2", "1", "", "", "", "",
        "3", "", "", "", "", "",
        "4", "", "", "", "", "",
        "5", "", "", "", "", "",
        "6", "", "", "", "", ""
    ),
    label.x = c(
        0.1, 0.17, 0.13, -0.05, 0.03, 0.17,
        0, -1, rep(0, 4),
        0, rep(0, 5),
        0, rep(0, 5),
        0, rep(0, 5),
        0, rep(0, 5)
    ),
    label.y = c(
        rep(1, 6),
        0.7, 1.7, rep(0, 4),
        0.7, rep(0, 5),
        0.7, rep(0, 5),
        0.7, rep(0, 5),
        0.7, rep(0, 5)
    )
)
