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

JAVA_1_8=$1
GATK_DIR=$2
CORE_PATH=$3
VERIFY_VCF=$4

PROJECT=$5
SM_TAG=$6
REF_GENOME=$7
TI_TV_BED=$8

RIS_ID=${SM_TAG%@*}
BARCODE_2D=${SM_TAG#*@}

## --Creating an on the fly VCF file to be used as the reference for verifyBamID--
## --remove X and Y data

START_SELECT_VERIFYBAMID_VCF=`date '+%s'`

$JAVA_1_8/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T SelectVariants \
-R $REF_GENOME \
--variant $VERIFY_VCF \
-L $TI_TV_BED \
-XL X \
-XL Y \
-o $CORE_PATH/$PROJECT/TEMP/$SM_TAG".VerifyBamID.vcf"

END_SELECT_VERIFYBAMID_VCF=`date '+%s'`

HOSTNAME=`hostname`

echo $SM_TAG"_"$PROJECT",H.001,SELECT_VERIFYBAMID_VCF,"$HOSTNAME","$START_SELECT_VERIFYBAMID_VCF","$END_SELECT_VERIFYBAMID_VCF \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_8/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T SelectVariants \
-R $REF_GENOME \
--variant $VERIFY_VCF \
-L $TI_TV_BED \
-XL X \
-XL Y \
-o $CORE_PATH/$PROJECT/TEMP/$SM_TAG".VerifyBamID.vcf" \
>> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND.LINES.txt"

echo >> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND.LINES.txt"
