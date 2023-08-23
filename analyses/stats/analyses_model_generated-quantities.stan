functions {
  #include "probability-functions.stan"
}
data {
  #include analyses_model_blk_data.stan
}
parameters {
  #include analyses_model_blk_parameters.stan
}
generated quantities {
  vector[N_rt] y_rep;

  for (n in 1:N_rt) {
    real mu = alpha_0 +
      alpha_participant[idx_participant[n]] +
      num_letters[n] * beta_length +
      sub_freq[n] * beta_subfreq +
      aoa[n] * beta_aoa +
      concreteness[n] * beta_concreteness +
      gamma_words[idx_word[n]];

    y_rep[n] = shift_lognormal_rng(
          mu,
          sigma_rt,
          delta_participants[idx_participant[n]]
    );
  }
}
