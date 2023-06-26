functions {
    #include "probability-functions.stan"
}
data {
    #include analyses_model_blk_data.stan
}
parameters {
    #include analyses_model_blk_parameters.stan
}
model {
    #include analyses_model_blk_model.stan
}
