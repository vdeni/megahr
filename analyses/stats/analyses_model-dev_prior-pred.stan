data {
    #include analyses_model_blk_data.stan

    real alpha_zero_mu;
    real alpha_zero_sigma;

    real beta_len_mu;
    real beta_len_sigma;

    real beta_subfreq_mu;
    real beta_subfreq_sigma;

    real beta_aoa_mu;
    real beta_aoa_sigma;

    real beta_concrete_mu;
    real beta_concrete_sigma;

    real sigma_rate;
}
generated quantities {
    vector[N_rt] rt_rep;
    real mu;

    real alpha_zero;

    vector[N_participants] alpha_participants;

    real beta_len;
    real beta_subfreq;
    real beta_aoa;
    real beta_concrete;

    vector[N_words] gamma_words;

    real<lower=0> sigma;

    alpha_zero = normal_rng(alpha_zero_mu, alpha_zero_sigma);

    for (i in 1:N_participants) {
        alpha_participants[i] = normal_rng(0, 0.3);
    }

    beta_len = normal_rng(beta_len_mu, beta_len_sigma);
    beta_subfreq = normal_rng(beta_subfreq_mu, beta_subfreq_sigma);
    beta_aoa = normal_rng(beta_aoa_mu, beta_aoa_sigma);
    beta_concrete = normal_rng(beta_concrete_mu, beta_concrete_sigma);

    for (i in 1:N_words) {
        gamma_words[i] = normal_rng(0, 0.15);
    }

    sigma = exponential_rng(sigma_rate);

    for (i in 1:N_rt) {
        mu = alpha_zero +
            alpha_participants[idx_participant[i]] +
            beta_len * num_letters[i] +
            beta_subfreq * sub_freq[i] +
            beta_concrete * concreteness[i] +
            beta_aoa * aoa[i] +
            gamma_words[idx_word[i]];

        rt_rep[i] = lognormal_rng(mu, sigma);
    }
}
