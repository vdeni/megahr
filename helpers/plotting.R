library(ggplot2)
library(glue)

.hist_plot <- function(
    data,
    x,
    bins = 30,
    x_limits = NULL) {
    p <- ggplot2::ggplot(
        data = data,
        mapping = ggplot2::aes(x = .data[[x]])
    ) +
        ggplot2::geom_histogram(
            fill = "black",
            bins = bins,
            linewidth = 0
        ) +
        ggplot2::scale_x_continuous(
            name = "",
        ) +
        ggplot2::scale_y_continuous(
            name = ""
        ) +
        ggplot2::coord_cartesian(
            xlim = x_limits
        )

    return(p)
}

.scatter_plot <- function(
    data,
    var_x,
    var_y,
    x_limits = NULL,
    y_limits = NULL) {
    p <- ggplot2::ggplot(
        data = data,
        mapping = ggplot2::aes(
            x = .data[[var_x]],
            y = .data[[var_y]]
        )
    ) +
        ggplot2::geom_point(
            size = 2,
            alpha = 0.3,
            color = "black",
            fill = "black",
            shape = 21,
            stroke = 0
        ) +
        ggplot2::scale_x_continuous(name = "") +
        ggplot2::scale_y_continuous(name = "") +
        ggplot2::coord_cartesian(
            xlim = x_limits,
            ylim = y_limits
        )

    return(p)
}

.corr_plot <- function(
    var_x,
    var_y) {
    res <- cor.test(x = var_x, y = var_y, method = "pearson")

    if (round(res$p.value, 2) == 0) {
        p_val <- "p < .01"
    } else {
        p_val <- glue::glue("p = {round(res$p.value, 2)}") |>
            stringr::str_replace(
                pattern = "^0",
                replacement = ""
            )
    }

    r_val <- glue::glue("r = {sprintf('%.2f', res$estimate)}") |>
        stringr::str_replace(
            pattern = "0(?=\\.)",
            replacement = ""
        )

    r_conf <- glue::glue(
        "({sprintf('%.2f', res$conf.int[1])}, {sprintf('%.2f', res$conf.int[2])})"
    ) |>
        stringr::str_replace_all(
            pattern = "0(?=\\.)",
            replacement = ""
        )

    p <- ggplot2::ggplot() +
        ggplot2::geom_text(
            data = data.frame(
                x = paste(
                    stringr::str_interp("${r_val} ${r_conf}"),
                    stringr::str_interp("t(${res$parameter}) = $[.2f]{res$statistic}"),
                    stringr::str_interp("${p_val}"),
                    sep = "\n"
                )
            ),
            mapping = ggplot2::aes(label = x, x = 5, y = 5),
            size = 5
        ) +
        ggplot2::theme_void()

    return(p)
}

.bar_plot <- function(
    data,
    x) {
    ggplot2::ggplot(data,
        mapping = ggplot2::aes(x = .data[[x]])
    ) +
        ggplot2::geom_bar(
            fill = "black"
        ) +
        ggplot2::labs(
            x = "",
            y = ""
        )
}
