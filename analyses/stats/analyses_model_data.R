library(here)
library(readr)

d_analysis <- readr::read_delim(
    here::here(
        "data",
        "analysis",
        "analysis-data.delim"
    ),
    delim = "|"
)

l_analysis_data <- d_analysis |>
    dplyr::select(
        -c(string, imageability),
        "rt" = stimulus_rt,
        "sub_freq" = subjective_frequency,
        "idx_participant" = id,
        "idx_word" = string_id
    ) |>
    as.list()

l_analysis_data$N_participants <- dplyr::n_distinct(l_analysis_data$idx_participant)
l_analysis_data$N_words <- dplyr::n_distinct(l_analysis_data$idx_word)
l_analysis_data$N_rt <- length(l_analysis_data$rt)

l_priors <- readRDS(file = here::here(
    "data",
    "helpers",
    "l_model_priors.RData"
))

l_analysis_data <- c(l_analysis_data, l_priors)

saveRDS(
    l_analysis_data,
    file = here::here(
        "data",
        "helpers",
        "l_analysis_data.RData"
    )
)
