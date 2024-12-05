library(here)
library(cmdstanr)
library(readr)
library(dplyr)
library(ggplot2)
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
        axis_label = "Reaction time (ms)",
        x_limits = c(0, 4000),
        bins = 500,
        diag_plot = "hist"
    ),
    "num_letters" = list(
        axis_label = "Word length",
        diag_plot = "bar"
    ),
    "concreteness" = list(
        axis_label = "Concreteness",
        x_limits = c(1, 5),
        bins = 40,
        diag_plot = "hist"
    ),
    "subjective_frequency" = list(
        axis_label = "Subjective frequency",
        x_limits = c(1, 5),
        bins = 40,
        diag_plot = "hist"
    ),
    "aoa" = list(
        axis_label = "Age of acquisition",
        x_limits = c(1, 18),
        bins = 40,
        diag_plot = "hist"
    ),
    "imageability" = list(
        axis_label = "Imageability",
        x_limits = c(1, 5),
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
            axis_label = plot_configs[[colname]]$axis_label,
            x_limits = plot_configs[[colname]]$x_limits,
            bins = plot_configs[[colname]]$bins
        )
    } else if (plot_configs[[colname]]$diag_plot == "bar") {
        p <- .bar_plot(
            data = d_combined,
            x = colname,
            axis_label = plot_configs[[colname]]$axis_label
        )
    }
    diag_plots[[colname]] <- p
}
