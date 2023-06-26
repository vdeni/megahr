real alpha_0;  // intercept

vector[N_participants] alpha_participant;

real beta_length; // coefficient for word length
real beta_concreteness; // coefficient for word concreteness
real beta_subfreq; // coefficient for subjective frequency
real beta_aoa; // coefficient for AoA

vector[N_words] gamma_words;

vector<lower=0>[N_participants] delta_participants;

real<lower=0> sigma_rt; // variance of the reaction time distribution
