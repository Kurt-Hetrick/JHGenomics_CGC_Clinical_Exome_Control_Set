# ---qsub parameter settings---
# --these can be overrode at qsub invocation--

# tell sge to execute in bash
#$ -S /bin/bash


# tell sge to submit any of these queue when available
#$ -q rnd.q,prod.q,test.q

# tell sge that you are in the users current working directory
#$ -cwd

# tell sge to export the users environment variables
#$ -V

# tell sge to submit at this priority setting
#$ -p -10

# tell sge to output both stderr and stdout to the same file
#$ -j y

# export all variables, useful to find out what compute node the program was executed on
# redirecting stderr/stdout to file as a log.

# This would be a good candidate to write a bright module to load this.
source /u01/home/khetrick/bashrc_change_R

set

JAVA_1_8=$1
GATK_DIR=$2
CORE_PATH=$3

PROJECT=$4
SM_TAG=$5
REF_GENOME=$6

RIS_ID=${SM_TAG%@*}
BARCODE_2D=${SM_TAG#*@}

## --Generate BQSR plots--

START_ANALYZE_COVARIATES=`date '+%s'`

$JAVA_1_8/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T AnalyzeCovariates \
-R $REF_GENOME \
-before $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_PERFORM_BQSR.bqsr" \
-after $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_AFTER_BQSR.bqsr" \
-plots $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/PDF/$SM_TAG".BQSR.pdf"

END_ANALYZE_COVARIATES=`date '+%s'`

HOSTNAME=`hostname`

echo $SM_TAG"_"$PROJECT",H.001,ANALYZE_COVARIATES,"$HOSTNAME","$START_ANALYZE_COVARIATES","$END_ANALYZE_COVARIATES \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_8/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T AnalyzeCovariates \
-R $REF_GENOME \
-before $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_PERFORM_BQSR.bqsr" \
-after $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_AFTER_BQSR.bqsr" \
-plots $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/PDF/$SM_TAG".BQSR.pdf" \
>> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND.LINES.txt"

echo >> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND.LINES.txt"

md5sum $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/PDF/$SM_TAG".BQSR.pdf" \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".CIDR.Analysis.MD5.txt"

