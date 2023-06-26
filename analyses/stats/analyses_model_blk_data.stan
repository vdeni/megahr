int<lower=1> N_participants; // number of participants
int<lower=1> N_words; // number of words
int<lower=1> N_rt; // number of reaction times

vector<lower=0>[N_rt] rt; // reaction time observations

array[N_rt] int<lower=1> idx_participant;
array[N_rt] int<lower=1> idx_word;

array[N_rt] int<lower=0> num_letters; // number of letters for each word
vector<lower=0>[N_rt] concreteness; // concreteness ratings for each word
vector<lower=0>[N_rt] sub_freq; // subjective frequency ratings for each word
vector<lower=0>[N_rt] aoa; // AoA rating for each word

real prior_alpha_0_mu;
real prior_alpha_0_sigma;

real prior_alpha_participants_mu;
real prior_alpha_participants_sigma;

real prior_beta_len_mu;
real prior_beta_len_sigma;

real prior_beta_subfreq_mu;
real prior_beta_subfreq_sigma;

real prior_beta_aoa_mu;
real prior_beta_aoa_sigma;

real prior_beta_concrete_mu;
real prior_beta_concrete_sigma;

real prior_gamma_words_mu;
real prior_gamma_words_sigma;

real prior_sigma_rate;

real prior_delta_shape;
real prior_delta_rate;
