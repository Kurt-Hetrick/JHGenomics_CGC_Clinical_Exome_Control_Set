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

set

JAVA_1_7=$1
GATK_DIR=$2
CORE_PATH=$3

PROJECT=$4
SM_TAG=$5
REF_GENOME=$6
TITV_BED=$7


# Filter to just on all of the variants all

START_FILTER_TO_SAMPLE_TITV_VCF=`date '+%s'`

$JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T SelectVariants \
--disable_auto_index_creation_and_locking_when_reading_rods \
-R $REF_GENOME \
-L $TITV_BED \
--excludeNonVariants \
--excludeFiltered \
--variant $CORE_PATH/$PROJECT/SNV/FILTERED_ON_BAIT/$SM_TAG".SNV.ON_BAIT.PASS.vcf.gz" \
-o $CORE_PATH/$PROJECT/TEMP/$SM_TAG".SNV.TITV_ALL.vcf"

END_FILTER_TO_SAMPLE_TITV_VCF=`date '+%s'`

HOSTNAME=`hostname`

echo $PROJECT",S.001,FILTER_TO_SAMPLE_TITV_VCF,"$HOSTNAME","$START_FILTER_TO_SAMPLE_TITV_VCF","$END_FILTER_TO_SAMPLE_TITV_VCF \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T SelectVariants \
--disable_auto_index_creation_and_locking_when_reading_rods \
-R $REF_GENOME \
-L $TITV_BED \
--excludeNonVariants \
--excludeFiltered \
--variant $CORE_PATH/$PROJECT/SNV/FILTERED_ON_BAIT/$SM_TAG".SNV.ON_BAIT.PASS.vcf.gz" \
-o $CORE_PATH/$PROJECT/TEMP/$SM_TAG".SNV.TITV_ALL.vcf" \
echo >> $CORE_PATH/$PROJECT/CONTROL_DATA_SET.COMMAND.LINES.txt

echo >> $CORE_PATH/$PROJECT/CONTROL_DATA_SET.COMMAND.LINES.txt
