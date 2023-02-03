date
echo
echo "=========================="

BFILE=${1}
REF=${2}
OUT=${3}
NTHREADS=${4}
plinkpath=${5}

######################################################################
# RUN PRSCS by chromsome

export MKL_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1
export OMP_NUM_THREADS=1

PRSCS_func(){
echo PRS-CS is running for chromosome ${1}     
python -u ./PRScs.py \
--ref_dir=${4}  \
--bim_prefix=${3} \
--sst_file=./data/EXTERNALIZING.excl23andMe_PRSCS_input_HM3.txt \
--n_gwas=1045957 \
--out_dir=${2}_EXT_PRSCS_chr${1} \
--chrom=${1} \
--seed=111 2>&1 | tee ${2}_EXT_PRSCS_chr${1}.log
}
export -f PRSCS_func

for chr in {1..22}; do echo $chr; done | xargs -t -I{} -P ${NTHREADS} bash -c "PRSCS_func {} ${OUT} ${BFILE} ${REF}"


######################################################################
# Create a score for the target sample

rm -f ${OUT}_PRSCS_beta_adj.txt && touch ${OUT}_EXT_PRSCS_beta_adj.txt
for chr in {1..22}
do
cat ${OUT}_EXT_PRSCS_chr${chr}_pst_eff_a1_b0.5_phiauto_chr${chr}.txt >> ${OUT}_EXT_PRSCS_beta_adj.txt
rm ${OUT}_EXT_PRSCS_chr${chr}_pst_eff_a1_b0.5_phiauto_chr${chr}.txt
done

${plinkpath} \
--bfile ${BFILE} \
--score ${OUT}_EXT_PRSCS_beta_adj.txt 2 4 6 \
--out ${OUT}_EXT_PRSCS_scores

echo
echo "=========================="
date
