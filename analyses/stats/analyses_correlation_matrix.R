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
        size = 0.7
    ),
    panel.grid.major.y = ggplot2::element_line(
        color = "gray",
        size = 0.7
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

.hist_plot(
    d_combined,
    ggplot2::aes(x = stimulus_rt),
    axis_name = "Reaction time (ms)",
    bins = 500,
    x_limits = c(0, 3000)
)

.scatter_plot(
    d_combined,
    ggplot2::aes(
        x = stimulus_rt,
        y = aoa
    ),
    axis_label_x = "Reaction time (ms)",
    axis_label_y = "Age of acquisition",
    x_limits = c(0, 3000),
    y_limits = c(0, 16)
)

.corr_plot(
    d_combined$stimulus_rt,
    d_combined$subjective_frequency
)
