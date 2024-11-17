renv::activate()

library(dplyr)
library(here)
library(readr)

df_psyling_1 <- readr::read_csv(
    here::here(
        "data",
        "psycholinguistic-estimates",
        "clean",
        "megahr_wave-1.csv"
    )
)

df_psyling_2 <- readr::read_csv(
    here::here(
        "data",
        "psycholinguistic-estimates",
        "clean",
        "megahr_wave-2.csv"
    )
)

df_psyling <- dplyr::bind_rows(
    df_psyling_1,
    df_psyling_2
)

df_psyling <- df_psyling %>%
    dplyr::filter(
        .data = .,
        word_type == "Nc"
    )

df_psyling <- dplyr::select(
    .data = df_psyling,
    "string" = lexeme,
    num_letters,
    concreteness,
    subjective_frequency,
    aoa,
    concreteness_n,
    subjective_frequency_n,
    aoa_n,
    imageability,
    imageability_n
)

df_psyling <- dplyr::distinct(df_psyling)

readr::write_csv(
    df_psyling,
    file = here::here(
        "data",
        "psycholinguistic-estimates",
        "clean",
        "psycholinguistic-estimates.csv"
    )
)
