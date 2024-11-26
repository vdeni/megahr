library(here)
library(cmdstanr)
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)

source(
    here::here(
        "helpers",
        "pooled_statistics.R"
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
