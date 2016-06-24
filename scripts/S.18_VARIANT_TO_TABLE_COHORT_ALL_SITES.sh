# ---qsub parameter settings---
# --these can be overrode at qsub invocation--

# tell sge to execute in bash
#$ -S /bin/bash


# tell sge to submit any of these queue when available
#$ -q prod.q,rnd.q,test.q

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

set

JAVA_1_7=$1
GATK_DIR=$2
CORE_PATH=$3

PROJECT=$4
REF_GENOME=$5

# Filter to just on all of the variants all

START_VARIANT_TO_TABLE_COHORT=`date '+%s'`

# not doing --splitMultiallelic here...maybe do one as an example and discuss with Molly
# do an example of molten output to look at/show molly

$JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T VariantsToTable \
--disable_auto_index_creation_and_locking_when_reading_rods \
-R $REF_GENOME \
--variant $CORE_PATH/$PROJECT/JOINT_VCF/CONTROL_DATA_SET.VQSR.ANNOTATED.vcf.gz \
--fields CHROM \
--fields POS \
--fields ID \
--fields REF \
--fields ALT \
--fields QUAL \
--fields EVENTLENGTH \
--fields FILTER \
--fields AC \
--fields AC_Orig \
--fields AN \
--fields AN_Orig \
--fields AF \
--fields AF_Orig \
--fields ABHet \
--fields ABHom \
--fields OND \
--fields HOM-REF \
--fields HET \
--fields HOM-VAR \
--fields NO-CALL \
--fields NSAMPLES \
--fields GQ_MEAN \
--fields GQ_STDDEV \
--fields NDA \
--fields Samples \
--fields DP \
--fields QD \
--fields FS \
--fields SOR \
--fields MQ \
--fields MQRankSum \
--fields ReadPosRankSum \
--fields culprit \
--fields VQSLOD \
--fields POSITIVE_TRAIN_SITE \
--fields NEGATIVE_TRAIN_SITE \
--fields GC \
--fields FractionInformativeReads \
--fields HRun \
--fields RPA \
--fields RU \
--fields STR \
--fields MVLR \
--fields ClippingRankSum \
--fields OneKGP.AF \
--fields OneKGP.EAS_AF \
--fields OneKGP.AMR_AF \
--fields OneKGP.AFR_AF \
--fields OneKGP.EUR_AF \
--fields OneKGP.SAS_AF \
--genotypeFields AD \
--genotypeFields DP \
--genotypeFields GQ \
--genotypeFields GT \
--genotypeFields PGT \
--genotypeFields PID \
--genotypeFields PL \
--genotypeFields RGQ \
--genotypeFields SAC \
--allowMissingData \
--showFiltered \
-o $CORE_PATH/$PROJECT/TEMP/CONTROL_SET.VQSR.ANNOTATED.txt

END_VARIANT_TO_TABLE_COHORT=`date '+%s'`

HOSTNAME=`hostname`

echo $PROJECT",T.01,VARIANT_TO_TABLE_CONTROL_SET_ALL_SITES,"$HOSTNAME","$START_VARIANT_TO_TABLE_COHORT","$END_VARIANT_TO_TABLE_COHORT \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T VariantsToTable \
--disable_auto_index_creation_and_locking_when_reading_rods \
-R $REF_GENOME \
--variant $CORE_PATH/$PROJECT/JOINT_VCF/CONTROL_DATA_SET.VQSR.ANNOTATED.vcf.gz \
--fields CHROM \
--fields POS \
--fields ID \
--fields REF \
--fields ALT \
--fields QUAL \
--fields EVENTLENGTH \
--fields FILTER \
--fields AC \
--fields AC_Orig \
--fields AN \
--fields AN_Orig \
--fields AF \
--fields AF_Orig \
--fields ABHet \
--fields ABHom \
--fields OND \
--fields HOM-REF \
--fields HET \
--fields HOM-VAR \
--fields NO-CALL \
--fields NSAMPLES \
--fields GQ_MEAN \
--fields GQ_STDDEV \
--fields NDA \
--fields Samples \
--fields DP \
--fields QD \
--fields FS \
--fields SOR \
--fields MQ \
--fields MQRankSum \
--fields ReadPosRankSum \
--fields culprit \
--fields VQSLOD \
--fields POSITIVE_TRAIN_SITE \
--fields NEGATIVE_TRAIN_SITE \
--fields GC \
--fields FractionInformativeReads \
--fields HRun \
--fields RPA \
--fields RU \
--fields STR \
--fields MVLR \
--fields ClippingRankSum \
--fields OneKGP.AF \
--fields OneKGP.EAS_AF \
--fields OneKGP.AMR_AF \
--fields OneKGP.AFR_AF \
--fields OneKGP.EUR_AF \
--fields OneKGP.SAS_AF \
--genotypeFields AD \
--genotypeFields DP \
--genotypeFields GQ \
--genotypeFields GT \
--genotypeFields PGT \
--genotypeFields PID \
--genotypeFields PL \
--genotypeFields RGQ \
--genotypeFields SAC \
--allowMissingData \
--showFiltered \
-o $CORE_PATH/$PROJECT/TEMP/CONTROL_SET.VQSR.ANNOTATED.txt \
>> $CORE_PATH/$PROJECT/$PROJECT".COMMAND.LINES.txt"

echo >> $CORE_PATH/$PROJECT/$PROJECT".COMMAND.LINES.txt"
