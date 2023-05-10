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
