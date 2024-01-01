# prepare analysis dataset

library(dplyr)
library(tidyr)
library(here)
library(readr)

d_megart <- readr::read_delim(
    file = here::here(
        "data",
        "megart",
        "clean",
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

# exclude incorrect responses
d_megart <- d_megart %>%
    dplyr::filter(
        stimulus_acc == TRUE
    )

n_post_incorrect <- nrow(d_megart)

# exclude reactions provided to words that have less than 30 reaction times
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

# squash psycholinguistic estimates data
v_word_dupes <- d_psyling$string[duplicated(d_psyling$string)]

d_word_dupes <- dplyr::filter(
    d_psyling,
    string %in% v_word_dupes
)

d_word_dupes <- dplyr::summarise(
    d_word_dupes,
    string = unique(string),
    num_letters = unique(num_letters),
    concreteness = sum(concreteness * concreteness_n) / sum(concreteness_n),
    subjective_frequency = sum(subjective_frequency * subjective_frequency_n) /
        sum(subjective_frequency_n),
    aoa = sum(aoa * aoa_n) / sum(aoa_n)
)

d_psyling <- dplyr::filter(
    d_psyling,
    !string %in% v_word_dupes
)

d_psyling <- dplyr::select(
    d_psyling,
    !dplyr::ends_with("_n")
)

d_psyling <- dplyr::bind_rows(
    d_psyling,
    d_word_dupes
)

# join megart data with psycholinguistic estimates, keeping only strings
# which appear in both datasets
d_analysis <- dplyr::inner_join(
    x = d_megart,
    y = d_psyling,
    by = "string"
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

n_post_intersect <- nrow(d_analysis)

# transform ID to numeric for Stan
d_analysis <- d_analysis %>%
    tidyr::nest(
        .data = .,
        .by = "id"
    ) %>%
    dplyr::mutate(
        .data = .,
        id = 1:dplyr::n()
    ) %>%
    tidyr::unnest(
        data = .,
        cols = "data"
    ) %>%
    tidyr::nest(
        .data = .,
        .by = "string"
    ) %>%
    dplyr::mutate(
        .data = .,
        string_id = 1:dplyr::n()
    ) %>%
    tidyr::unnest(
        data = .,
        cols = "data"
    ) %>%
    dplyr::select(
        .data = .,
        "id",
        "string_id",
        dplyr::everything()
    ) %>%
    dplyr::arrange(
        .data = .,
        id,
        string_id
    )

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

readr::write_delim(
    x = d_analysis,
    file = here::here(
        "data",
        "analysis",
        "analysis-data.delim"
    ),
    delim = "|"
)
