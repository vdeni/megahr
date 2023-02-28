.PHONY: all\
	data

DIR_DAT_MEGART_CLEAN = data/megart/clean
DIR_DAT_MEGART_RAW = data/megart/raw

DIR_DAT_PSYLING_RAW = data/psycholinguistic-estimates/raw
DIR_DAT_PSYLING_CLEAN = data/psycholinguistic-estimates/clean

DIR_DAT_HELPERS = data/helpers

DIR_DAT_ANALYSIS = data/analysis

DIR_SRC_WRANGLING = analyses/wrangling

all: data

data: ${DIR_DAT_MEGART_CLEAN}/data_megart.delim\
	${DIR_DAT_PSYLING_CLEAN}/psycholinguistic-estimates.csv\
	${DIR_DAT_HELPERS}/l_n_exclude.RData\
	${DIR_DAT_ANALYSIS}/analysis-data.delim

${DIR_DAT_MEGART_CLEAN}/data_megart.delim: ${DIR_SRC_WRANGLING}/megart_data_read.R\
	${DIR_DAT_MEGART_RAW}/cda1012_dat_c_reaction-times_1.csv\
	${DIR_DAT_MEGART_RAW}/cda1012_dat_c_reaction-times_2.csv
	Rscript $<

${DIR_DAT_PSYLING_CLEAN}/psycholinguistic-estimates.csv:\
	analyses/wrangling/psyling-estimates_data_merge.R\
	${DIR_DAT_PSYLING_CLEAN}/megahr_wave-1.csv\
	${DIR_DAT_PSYLING_CLEAN}/megahr_wave-2.csv
	Rscript $<
	rm ${DIR_DAT_PSYLING_CLEAN}/megahr_*.csv

${DIR_DAT_PSYLING_CLEAN}/megahr_wave-%.csv: ${DIR_DAT_PSYLING_RAW}/megahr_wave-%.tsv
	sed -Ee 's/\t/,/g' $< > $@
	Rscript analyses/wrangling/psyling-estimates_data_prepare.R --args $(notdir $@)

${DIR_DAT_HELPERS}/l_n_exclude.RData\
	${DIR_DAT_ANALYSIS}/analysis-data.delim &: analyses/wrangling/analysis_data_prepare.R
	Rscript $<
