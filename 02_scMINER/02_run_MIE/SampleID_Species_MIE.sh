#BSUB -P Metastasis
#BSUB -M 27385
#BSUB -oo Breast_10_nsTumor_mm10_MIE.out -eo Breast_10_nsTumor_mm10_MIE.err
#BSUB -J Breast_10_nsTumor_mm10
#BSUB -q priority

python3=/hpcf/apps/python/install/3.6.1/bin/python3.6
scMINER=/research/projects/yu3grp/scRNASeq/yu3grp/qpan/Software/scMINER/scMINER-20180523/scMINER.py

## Mutual Information Estimation
$python3 $scMINER MIE Pipeline Breast_10_nsTumor /research/projects/yu3grp/scRNASeq/yu3grp/metastasis/02_Breast_cancer/02_scMINER/Breast_10_nsTumor/3_1_Breast_10_nsTumor_mm10_scMINER_total.txt /research/projects/yu3grp/scRNASeq/yu3grp/metastasis/02_Breast_cancer/02_scMINER/Breast_10_nsTumor/ Breast_10_nsTumor
