alpha_0 ~ normal(prior_alpha_0_mu, prior_alpha_0_sigma);

for (n in 1:N_participants) {
    alpha_participant[n] ~ normal(
        prior_alpha_participants_mu, prior_alpha_participants_sigma
    );

    delta_participants[n] ~ gamma(
        prior_delta_shape,
        prior_delta_rate
    );
}

beta_length ~ normal(prior_beta_len_mu, prior_beta_len_sigma);
beta_subfreq ~ normal(prior_beta_subfreq_mu, prior_beta_subfreq_sigma);
beta_aoa ~ normal(prior_beta_aoa_mu, prior_beta_aoa_sigma);
beta_concreteness ~ normal(prior_beta_concrete_mu, prior_beta_concrete_sigma);

sigma_rt ~ exponential(prior_sigma_rate);

for (n in 1:N_words) {
    gamma_words[n] ~ normal(prior_gamma_words_mu, prior_gamma_words_sigma);
}    

for (n in 1:N_rt) {
    real mu = alpha_0 +
        alpha_participant[idx_participant[n]] +
        beta_length * num_letters[n] +
        beta_subfreq * sub_freq[n] +
        beta_aoa * aoa[n] +
        beta_concreteness * concreteness[n] +
        gamma_words[idx_word[n]];

    rt[n] ~ shift_lognormal(mu, sigma_rt, delta_participants[idx_participant[n]]);
}
