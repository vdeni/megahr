.pooled_mean <- function(mean_var, n_tot_var) {
    sum(
        {{ mean_var }} * {{ n_tot_var }}
    ) / sum({{ n_tot_var }})
}
