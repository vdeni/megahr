# prepare psycholinguistic estimates data

renv::activate()

library(here)
library(dplyr)

d <- readr::read_csv(here::here(
  "data",
  "psycholinguistic-estimates",
  "clean",
  "megahr.csv"
))

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
    "d.M"
  )
)

d <- janitor::clean_names(d)

d <- dplyr::rename(d,
  "lexeme" = "leksem",
  "word_type" = "vrsta_rijeci",
  "num_letters" = "broj_slova",
  "word_frequency" = "frek",
  "concreteness" = "k_m",
  "subjective_frequency" = "c_m",
  "imageability" = "p_m",
  "aoa" = "d_m"
)

readr::write_csv(
  d,
  here(
    "data",
    "psycholinguistic-estimates",
    "clean",
    "megahr.csv"
  )
)
