functions {
    vector system_beta(
        vector solve_params,
        data vector target_quantiles
    ) {
        vector[2] solver_targets;

        solver_targets[1] = normal_cdf(
            target_quantiles[1] | solve_params[1], solve_params[2]
        ) - 0.1;

        solver_targets[2] = 1 - normal_cdf(
            target_quantiles[2] | solve_params[1], solve_params[2]
        ) - 0.1;

        return solver_targets;
    }
}
data {
    vector[2] quantiles_beta;
    vector[2] beta_guess;
}
generated quantities {
    vector[2] params_beta;

    params_beta = solve_newton(
        system_beta,
        beta_guess,
        quantiles_beta
    );
}
