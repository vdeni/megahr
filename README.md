#  Lexical decision times for nouns from the Croatian Psycholinguistic Database

 <p xmlns:cc="http://creativecommons.org/ns#"
 xmlns:dct="http://purl.org/dc/terms/"><span property="dct:title">Code for
 "Lexical decision times for nouns from the Croatian Psycholinguistic
 Database"</span> by <span property="cc:attributionName">Denis Vlašiček</span>
 is licensed under <a
 href="https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1"
 target="_blank" rel="license noopener noreferrer"
 style="display:inline-block;">CC BY 4.0<img
 style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"
 src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"
 alt=""><img
 style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"
 src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"
 alt=""></a></p>

This repository contains analysis code for the manuscript "Lexical decision
times for nouns from the Croatian Psycholinguistic Database".

The structure of the repository is as follows:

```
├── analyses
│   ├── stats
│   │   ├── analyses_correlation_matrix.R
│   │   ├── analyses_counterfactual_aoa.R
│   │   ├── analyses_counterfactual_aoa.stan
│   │   ├── analyses_counterfactual_length.R
│   │   ├── analyses_counterfactual_length.stan
│   │   ├── analyses_counterfactual-plots_merged.R
│   │   ├── analyses_counterfactual_subfreq.R
│   │   ├── analyses_counterfactual_subfreq.stan
│   │   ├── analyses.html
│   │   ├── analyses_model_blk_data.stan
│   │   ├── analyses_model_blk_model.stan
│   │   ├── analyses_model_blk_parameters.stan
│   │   ├── analyses_model_data.R
│   │   ├── analyses_model-dev_prior-pred_fit.R
│   │   ├── analyses_model-dev_prior-pred_fit.RData
│   │   ├── analyses_model-dev_prior-pred.stan
│   │   ├── analyses_model-dev_prior-pred_summarise.R
│   │   ├── analyses_model-dev_solver_alpha.stan
│   │   ├── analyses_model-dev_solver_beta.stan
│   │   ├── analyses_model-dev_solver.R
│   │   ├── analyses_model-dev_solver_sigma.stan
│   │   ├── analyses_model_explore-fit.R
│   │   ├── analyses_model_fit.R
│   │   ├── analyses_model_fit.RData
│   │   ├── analyses_model_fit.stan
│   │   ├── analyses_model_generated-quantities.R
│   │   ├── analyses_model_generated-quantities.stan
│   │   ├── analyses.Rmd
│   │   ├── analyses_stats_generated-quantities.RData
│   │   ├── methods.html
│   │   ├── methods.Rmd
│   │   ├── p_counterfactual_aoa.RData
│   │   ├── p_counterfactual_len.RData
│   │   ├── p_counterfactual_subfreq.RData
│   │   └── plots
│   │       ├── counterfactual_aoa.png
│   │       ├── counterfactual_length.png
│   │       ├── counterfactual_plots.png
│   │       ├── counterfactual_subfreq.png
│   │       └── pairs_plot.jpg
│   └── wrangling
│       ├── analysis_data_prepare.R
│       ├── megart_data_read.R
│       ├── psyling-estimates_data_merge.R
│       └── psyling-estimates_data_prepare.R
├── helpers
│   ├── plotting.R
│   ├── pooled-statistics.R
│   └── probability-functions.stan
├── Makefile
├── README.md
└── renv.lock
```

The `analyses` folder mostly contains R and Stan scripts used for conducting
the analyses reported in the associated manuscript. The short descriptions
of the contents of the folders are as follows:

- `analyses/wrangling/`: scripts which were used for cleaning and transforming
    the data so as to make it usable for analyses
- `analyses/stats/`: scripts used for the analyses themselves
    - `analyses_model-dev_*`: code used for model development
    - `analyses_model_fit`: code used for model fitting
    - `analyses_model_blk_*`: reusable parts of the Stan models' code
        blocks
    - `*.Rmd`: short reports on the methods and conducted analyses.
        These served as the basis of the numbers reported in the manuscript.
    - `analyses_counterfactual_*` and `analyses_correlation_matrix.R` were used
        to create the counterfactual plots and the scatterplot matrix.
    - `analyses_model_generated-quantities*`: code used for
        generating simulated data from the fitted model
    - `plots/`: various plots appearing in the manuscript, in raster formats
- `helpers/`: code defining helper functions used for analyses.

Unfortunately, the Makefile provided in the repository is incomplete. I had
trouble making it play nicely with the version of Stan/`cmdstanr` that was
being used. The code wouldn't run when using `make` but worked completely fine
when run through the terminal.

The analyses reported here rely on
[this publicly available dataset](https://doi.org/10.23669/PEVB54), as well
as the
[Croatian Psycholinguistic Database](https://doi.org/10.17234/megahr.2019.hpb).
