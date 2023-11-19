functions {
  #include "probability-functions.stan"
}
data {
  #include analyses_model_blk_data.stan

  int N_subsample;

  int<lower=1> max_wordlen;

  real alpha_0_fixed;
  real<lower=0> sigma_rt_fixed;
  // real beta_subfreq;
  // real beta_aoa;
  // real beta_concreteness;

  real sub_freq_fixed;
  real aoa_fixed;
  real concreteness_fixed;
}
parameters {
  #include analyses_model_blk_parameters.stan
}
generated quantities {
  matrix[N_subsample, max_wordlen] rt_rep;

  for (i in 1:N_subsample) {
    for (j in 2:max_wordlen) {
      real mu = alpha_0_fixed +
        beta_length * j +
        beta_subfreq * sub_freq_fixed +
        beta_aoa * aoa_fixed +
        beta_concreteness * concreteness_fixed;

      rt_rep[i, j - 1] = shift_lognormal_rng(
        mu,
        sigma_rt_fixed,
        0
      );
    }
  }
}
