.PHONY: all\
	data\
	reports

DIR_DAT_MEGART_CLEAN = data/megart/clean
DIR_DAT_MEGART_RAW = data/megart/raw

DIR_DAT_PSYLING_RAW = data/psycholinguistic-estimates/raw
DIR_DAT_PSYLING_CLEAN = data/psycholinguistic-estimates/clean

DIR_DAT_HELPERS = data/helpers

DIR_DAT_ANALYSIS = data/analysis

DIR_SRC_WRANGLING = analyses/wrangling

DIR_STATS = analyses/stats

DIR_WRANGLING = analyses/wrangling

all: data\
	reports\
	stats

data: ${DIR_DAT_MEGART_CLEAN}/data_megart.delim\
	${DIR_DAT_PSYLING_CLEAN}/psycholinguistic-estimates.csv\
	${DIR_DAT_HELPERS}/l_n_exclude.RData\
	${DIR_DAT_ANALYSIS}/analysis-data.delim\
	${DIR_DAT_HELPERS}/l_model_priors.RData\
	${DIR_DAT_HELPERS}/l_analysis_data.RData

${DIR_DAT_MEGART_CLEAN}/data_megart.delim: ${DIR_SRC_WRANGLING}/megart_data_read.R\
	${DIR_DAT_MEGART_RAW}/cda1012_dat_c_reaction-times_1.csv\
	${DIR_DAT_MEGART_RAW}/cda1012_dat_c_reaction-times_2.csv
	Rscript $<

${DIR_DAT_PSYLING_CLEAN}/psycholinguistic-estimates.csv:\
	analyses/wrangling/psyling-estimates_data_merge.R\
	${DIR_DAT_PSYLING_CLEAN}/megahr_wave-1.csv\
	${DIR_DAT_PSYLING_CLEAN}/megahr_wave-2.csv
	Rscript $<

${DIR_DAT_PSYLING_CLEAN}/megahr_wave-%.csv: ${DIR_DAT_PSYLING_RAW}/megahr_wave-%.tsv\
	analyses/wrangling/psyling-estimates_data_prepare.R
	sed -Ee 's/\t/,/g' $< > $@
	Rscript analyses/wrangling/psyling-estimates_data_prepare.R --args $(notdir $@)

${DIR_DAT_HELPERS}/l_n_exclude.RData\
	${DIR_DAT_ANALYSIS}/analysis-data.delim &: analyses/wrangling/analysis_data_prepare.R
	Rscript $<

${DIR_DAT_HELPERS}/l_model_priors.RData: ${DIR_STATS}/analyses_model-dev_solver.R\
	$(wildcard ${DIR_STATS}/*.stan)
	Rscript ${DIR_STATS}/analyses_model-dev_solver.R

${DIR_DAT_HELPERS}/l_analysis_data.RData: ${DIR_STATS}/analyses_model_data.R
	Rscript $<

reports: ${DIR_STATS}/methods.html

${DIR_STATS}/%.html: ${DIR_STATS}/%.Rmd\
	$(wildcard ${DIR_WRANGLING}/*)\
	${DIR_DAT_MEGART_CLEAN}/data_megart.delim\
	${DIR_DAT_PSYLING_CLEAN}/psycholinguistic-estimates.csv
	Rscript -e 'renv::activate(); rmarkdown::render("$<")'

stats: ${DIR_STATS}/analyses_model-dev_prior-pred_fit.RData

${DIR_STATS}/analyses_model-dev_prior-pred_fit.RData:\
	${DIR_STATS}/analyses_model-dev_prior-pred_fit.R\
	${DIR_STATS}/analyses_model-dev_prior-pred.stan\
	${DIR_STATS}/analyses_model_blk_data.stan\
	${DIR_DAT_ANALYSIS}/analysis-data.delim\
	${DIR_DAT_HELPERS}/l_model_priors.RData\
	${DIR_DAT_HELPERS}/l_analysis_data.RData
	Rscript $<
