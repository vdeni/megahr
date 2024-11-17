# prepare psycholinguistic estimates data

renv::activate()

library(here)
library(dplyr)

.args <- commandArgs(trailingOnly = TRUE)

filename <- .args[2]

d <- readr::read_csv(
    here::here(
        "data",
        "psycholinguistic-estimates",
        "clean",
        filename
    )
)

d <- dplyr::select(
    d,
    c(
        "leksem",
        "vrsta.riječi",
        "broj.slova",
        "frek",
        "k.M",
        "č.M",
        "p.M",
        "d.M",
        "k.N",
        "č.N",
        "p.N",
        "d.N"
    )
)

d <- janitor::clean_names(d)

d <- dplyr::rename(
    d,
    "lexeme" = "leksem",
    "word_type" = "vrsta_rijeci",
    "num_letters" = "broj_slova",
    "word_frequency" = "frek",
    "concreteness" = "k_m",
    "subjective_frequency" = "c_m",
    "aoa" = "d_m",
    "concreteness_n" = "k_n",
    "subjective_frequency_n" = "c_n",
    "aoa_n" = "d_n",
    "imageability" = "p_m",
    "imageability_n" = "p_n"
)

readr::write_csv(
    d,
    here(
        "data",
        "psycholinguistic-estimates",
        "clean",
        filename
    )
)
