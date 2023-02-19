
.PHONY:\
	all\
	data

DIR_DAT_MEGAHR_CLEAN = data/megahr/clean
DIR_DAT_MEGAHR_RAW = data/megahr/raw

DIR_DAT_PSYLING_RAW = data/psycholinguistic-estimates/raw
DIR_DAT_PSYLING_CLEAN = data/psycholinguistic-estimates/clean

DIR_SRC_WRANGLING = analyses/wrangling

all:\
	data

data:\
	${DIR_DAT_MEGAHR_CLEAN}/data_megahr.delim\
	${DIR_DAT_PSYLING_CLEAN}/megahr.csv

${DIR_DAT_MEGAHR_CLEAN}/data_megahr.delim: ${DIR_SRC_WRANGLING}/megart_data_read.R\
	${DIR_SRC_WRANGLING}/megart_data_prepare.R\
	${DIR_DAT_MEGAHR_RAW}/cda1012*.csv
	Rscript $< && Rscript ${DIR_SRC_WRANGLING}/megart_data_prepare.R

${DIR_DAT_PSYLING_CLEAN}/megahr.csv:\
	${DIR_DAT_PSYLING_RAW}/megahr.tsv\
	analyses/wrangling/psyling-estimates_data_prepare.R
	sed -Ee 's/\t/,/g' $< > $@
	Rscript analyses/wrangling/psyling-estimates_data_prepare.R

