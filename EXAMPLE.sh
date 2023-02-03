# Set inputs
BFILE=./MY_PLINK_FILE  # plink file prefix of your target sample
REF=./ldblk_1kg_eur # path to EUR LD reference file folder
OUT=EXAMPLE # prefix for output file
NTHREADS=22 # number of threads (one thread for each chromosome)
PLINK_PATH=plink # replace this with the path to plink software if plink is not in the path 

bash PRSCS_WRAPPER.sh ${BFILE} ${REF} ${OUT} ${NTHREADS} ${PLINK_PATH}

# output:
# ${OUT}_EXT_PRSCS_scores.profile