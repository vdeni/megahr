# prepare analysis dataset

renv::activate()

library(dplyr)
library(here)
library(readr)

d_megart <- readr::read_delim(
  file = here::here(
    "data",
    "megart",
    "cleaned",
    "data_megart.delim"
  ),
  delim = "|"
)

d_psyling <- readr::read_csv(
  file = here::here(
    "data",
    "psycholinguistic-estimates",
    "clean",
    "psycholinguistic-estimates.csv"
  )
)

n_total <- nrow(d_megart)

# exclude participants with less than 90% accuracy over all their trials
v_ptcpt_exclude <- d_megart %>%
  dplyr::summarise(
    .data = .,
    prop_correct = sum(stimulus_acc) / dplyr::n(),
    .by = id
  ) %>%
  dplyr::filter(
    .data = .,
    prop_correct < 0.9
  ) %>%
  dplyr::pull(id)

d_megart <- d_megart %>%
  dplyr::filter(
    .data = .,
    !id %in% v_ptcpt_exclude
  )

n_post_accuracy <- nrow(d_megart)

# exclude pseudowords
d_megart <- d_megart %>%
  dplyr::filter(
    .data = .,
    string_type == "word"
  )

n_post_nonword <- nrow(d_megart)

# exclude reactions provided to words that have less than 40 reactions
v_word_exclude <- d_megart %>%
  dplyr::summarise(
    .data = .,
    cnt = dplyr::n(),
    .by = string
  ) %>%
  dplyr::filter(
    .data = .,
    cnt < 30
  ) %>%
  dplyr::pull(string)

d_megart <- d_megart %>%
  dplyr::filter(
    .data = .,
    !string %in% v_word_exclude
  )

n_post_rare_react_word <- nrow(d_megart)

# exclude incorrect responses
d_megart <- d_megart %>%
  dplyr::filter(
    stimulus_acc == TRUE
  )

n_post_incorrect <- nrow(d_megart)

# save exclusion info to RData object
l_n_exclude <- ls(pattern = "n_post|n_total") %>%
  sapply(
    X = .,
    FUN = function(n_row) eval(parse(text = n_row))
  ) %>%
  as.list(.)

saveRDS(
  object = l_n_exclude,
  file = here::here(
    "data",
    "helpers",
    "l_n_exclude.RData"
  )
)

d_analysis <- dplyr::inner_join(
  x = d_megart,
  y = d_psyling,
  by = c("string" = "lexeme")
) %>%
  dplyr::select(
    .data = .,
    id,
    stimulus_rt,
    string,
    num_letters,
    concreteness,
    subjective_frequency,
    aoa
  )

readr::write_delim(
  x = d_analysis,
  file = here::here(
    "data",
    "analysis",
    "analysis-data.delim"
  ),
  delim = "|"
)
