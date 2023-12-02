functions {
  #include "probability-functions.stan"
}
data {
  #include analyses_model_blk_data.stan
  int N_subsample;

  real alpha_0_fixed;
  real<lower=0> sigma_rt_fixed;

  int N_subfreq_counterfactual;
  vector[N_subfreq_counterfactual] subfreq_counterfactual;

  real aoa_fixed;
  real concreteness_fixed;
  int<lower=1> length_fixed;
}
parameters {
  #include analyses_model_blk_parameters.stan
}
generated quantities {
  matrix[N_subsample, N_subfreq_counterfactual] rt_rep;

  for (i in 1:N_subsample) {
    for (j in 1:N_subfreq_counterfactual) {
      real mu = alpha_0_fixed +
        beta_length * length_fixed +
        beta_subfreq * subfreq_counterfactual[j] +
        beta_aoa * aoa_fixed +
        beta_concreteness * concreteness_fixed;

      rt_rep[i, j] = shift_lognormal_rng(
        mu,
        sigma_rt_fixed,
        0
      );
    }
  }
}
