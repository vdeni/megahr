library(ggplot2)
library(glue)

.hist_plot <- function(
    data,
    x,
    axis_label,
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
            name = axis_label,
        ) +
        ggplot2::scale_y_continuous(
            name = "Count"
        ) +
        ggplot2::coord_cartesian(
            xlim = x_limits
        )

    return(p)
}

.scatter_plot <- function(
    data,
    mapping,
    axis_label_x,
    axis_label_y,
    x_limits = NULL,
    y_limits = NULL) {
    p <- ggplot2::ggplot(
        data = data,
        mapping = mapping
    ) +
        ggplot2::geom_point(
            size = 2,
            alpha = 0.3,
            color = "black",
            fill = "black",
            shape = 21,
            stroke = 0
        ) +
        ggplot2::scale_x_continuous(name = axis_label_x) +
        ggplot2::scale_y_continuous(name = axis_label_y) +
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

    if (round(res$p.value, 3) == 0) {
        p_val <- "p < 0.01"
    } else {
        p_val <- glue::glue("p = {round(res$p.value, 3)}")
    }

    p <- ggplot2::ggplot() +
        ggplot2::geom_text(
            data = data.frame(
                x = glue::glue(
                    "r = {round(res$estimate, 3)} ({round(res$conf.int[1], 3)}, {round(res$conf.int[2], 3)})",
                    "t({res$parameter}) = {round(res$statistic, 3)}",
                    "{p_val}",
                    .sep = "\n"
                )
            ),
            mapping = ggplot2::aes(label = x, x = 5, y = 5),
            size = 20
        ) +
        ggplot2::theme_void()

    return(p)
}

.bar_plot <- function(
    data,
    x,
    axis_label) {
    ggplot2::ggplot(d_combined,
        mapping = ggplot2::aes(x = num_letters)
    ) +
        ggplot2::geom_bar(
            fill = "black"
        ) +
        ggplot2::labs(
            x = axis_label,
            y = "Count"
        )
}
