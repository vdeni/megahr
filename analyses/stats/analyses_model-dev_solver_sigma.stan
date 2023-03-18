functions {
    vector system_sigma(
        vector solve_param,
        data vector target_quantiles
    ) {
        vector[1] solver_targets;

        solver_targets[1] = exponential_cdf(
            target_quantiles[1] | solve_param[1]
        ) - 0.1;

        solver_targets[1] = 1 - exponential_cdf(
            target_quantiles[2] | solve_param[1]
        ) - 0.1;

        return solver_targets;
    }
}
data {
    vector[2] quantiles_sigma;
    vector[1] sigma_guess;
}
generated quantities {
    vector<lower=0>[1] params_sigma;

    params_sigma = solve_newton(
        system_sigma,
        sigma_guess,
        quantiles_sigma
    );
}
