library(here)
library(ggplot2)
library(ggpubr)

p_len <- readRDS(
    here::here(
        "analyses",
        "stats",
        "p_counterfactual_len.RData"
    )
)

p_aoa <- readRDS(
    here::here(
        "analyses",
        "stats",
        "p_counterfactual_aoa.RData"
    )
)

p_subfreq <- readRDS(
    here::here(
        "analyses",
        "stats",
        "p_counterfactual_subfreq.RData"
    )
)

ggpubr::ggarrange(
    p_len,
    p_aoa,
    p_subfreq,
    ncol = 1,
    nrow = 3,
    labels = list("A", "B", "C")
)

.height <- 14
ggplot2::ggsave(
    here::here(
        "analyses",
        "stats",
        "plots",
        "counterfactual_plots.png"
    ),
    device = "png",
    bg = "white",
    dpi = 600,
    height = .height,
    width = .height * 9 / 16
)
