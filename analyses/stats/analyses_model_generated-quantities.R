library(here)
library(cmdstanr)
library(arrow)
library(duckdb)
library(tidyr)
library(glue)

model_fit <- readRDS(here::here("analyses", "stats", "analyses_model_fit.RData"))

model_draws <- model_fit$draws()

# select random sample of draws
set.seed(1)
idx_sample <- sample(
  x = 1:dim(model_draws)[1],
  size = 500,
  replace = FALSE
)
model_draws_sample <- model_draws[idx_sample, , ]

l_data <- readRDS(here::here("data", "helpers", "l_analysis_data.RData"))

m_gen_quant <- cmdstanr::cmdstan_model(
  here::here(
    "analyses",
    "stats",
    "analyses_model_generated-quantities.stan"
  ),
  include_paths = c(
    here::here("analyses", "stats"),
    here::here("helpers")
  )
)

fit_gen_quant <- m_gen_quant$generate_quantities(
  model_draws_sample,
  data = l_data,
  parallel_chains = 4,
  sig_figs = 4
)

d_draws_gen_quant <- fit_gen_quant$draws(format = "df")
d_draws_gen_quant <- janitor::clean_names(d_draws_gen_quant)
d_draws_gen_quant <- dplyr::select(
  .data = d_draws_gen_quant,
  -c("chain", "iteration")
)
d_draws_gen_quant <- dplyr::as_tibble(d_draws_gen_quant)

d_draws_gen_quant <- tidyr::pivot_longer(
  data = d_draws_gen_quant,
  cols = dplyr::matches("y_rep"),
  names_pattern = "y_rep_(\\d)",
  names_to = "y_rt_rep_id",
  values_to = "y_rt_rep_ms"
)

gc()

arrow::write_parquet(
  x = d_draws_gen_quant,
  sink = here::here(
    "analyses",
    "stats",
    "analyses_model_generated-quantities.parquet"
  )
)

duck_conn <- DBI::dbConnect(
  drv = duckdb::duckdb(),
  dbdir = here::here(
    "analyses",
    "stats",
    "analyses_model_generated-quantities.duckdb"
  )
)

DBI::dbExecute(
  conn = duck_conn,
  statement = "DROP TABLE IF EXISTS generated_quantities"
)

DBI::dbExecute(
  conn = duck_conn,
  statement = glue::glue_sql(
    "CREATE TABLE generated_quantities AS ",
    "SELECT * ",
    "FROM {
        here::here(
            'analyses',
            'stats',
            'analyses_model_generated-quantities.parquet'
        )
    }",
    .con = duck_conn
  )
)

duckdb::dbDisconnect(conn = duck_conn, shutdown = TRUE)
