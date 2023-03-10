functions {
    vector system_alpha_zero(
        vector solve_params,
        data vector target_quantiles
    ) {
        vector[2] solver_targets;

        solver_targets[1] = lognormal_cdf(
            target_quantiles[1] | solve_params[1], solve_params[2]
        ) - 0.1;

        solver_targets[2] = 1 - lognormal_cdf(
            target_quantiles[2] | solve_params[1], solve_params[2]
        ) - 0.1;

        return solver_targets;
    }
}
data {
    vector[2] quantiles_alpha;
}
transformed data {
    // initial guess
    vector[2] alpha_guess = [7.3, 1]';
}
generated quantities {
    vector[2] params_alpha;

    params_alpha = solve_newton(
        system_alpha_zero,
        alpha_guess,
        quantiles_alpha
    );
}
