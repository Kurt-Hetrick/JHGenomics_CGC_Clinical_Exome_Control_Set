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
KNOWN_INDEL_1=$7
KNOWN_INDEL_2=$8

RIS_ID=${SM_TAG%@*}
BARCODE_2D=${SM_TAG#*@}

## --Realigner Target Creator, turn off downsampling

START_REALIGNER_TARGET_CREATOR=`date '+%s'`

$JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-I $CORE_PATH/$PROJECT/TEMP/$SM_TAG".dup.bam" \
-R $REF_GENOME \
-known $KNOWN_INDEL_1 \
-known $KNOWN_INDEL_2 \
-dt NONE \
-nt 4 \
-o $CORE_PATH/$PROJECT/REPORTS/LOCAL_REALIGNMENT_INTERVALS/$SM_TAG"_LOCAL_REALIGNMENT_INTERVALS.intervals"

END_REALIGNER_TARGET_CREATOR=`date '+%s'`

HOSTNAME=`hostname`

echo $SM_TAG"_"$PROJECT",D.001,REALIGNER_TARGET_CREATOR,"$HOSTNAME","$START_REALIGNER_TARGET_CREATOR","$END_REALIGNER_TARGET_CREATOR \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".WALL.CLOCK.TIMES.csv"

md5sum $CORE_PATH/$PROJECT/REPORTS/LOCAL_REALIGNMENT_INTERVALS/$SM_TAG"_LOCAL_REALIGNMENT_INTERVALS.intervals" \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".CIDR.Analysis.MD5.txt"

echo $JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-I $CORE_PATH/$PROJECT/TEMP/$SM_TAG".dup.bam" \
-R $REF_GENOME \
-known $KNOWN_INDEL_1 \
-known $KNOWN_INDEL_2 \
-dt NONE \
-nt 4 \
-o $CORE_PATH/$PROJECT/REPORTS/LOCAL_REALIGNMENT_INTERVALS/$SM_TAG"_LOCAL_REALIGNMENT_INTERVALS.intervals" \
>> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND.LINES.txt"

echo >> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND.LINES.txt"
