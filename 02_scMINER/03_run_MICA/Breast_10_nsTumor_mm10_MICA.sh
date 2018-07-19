#BSUB -P Metastasis
#BSUB -M 54770
#BSUB -oo Breast_10_nsTumor_mm10_MICA.out -eo Breast_10_nsTumor_mm10_MICA.err
#BSUB -J Breast_10_nsTumor_mm10
#BSUB -q large_mem

python3=/hpcf/apps/python/install/3.6.1/bin/python3.6
scMINER=/research/projects/yu3grp/scRNASeq/yu3grp/qpan/Software/scMINER/scMINER-20180523/scMINER.py

## Mutual Information Clustering Analysis
$python3 $scMINER MICA Clust Breast_10_nsTumor /research/projects/yu3grp/scRNASeq/yu3grp/metastasis/02_Breast_cancer/02_scMINER/Breast_10_nsTumor/scMINER_Breast_10_nsTumor/scMINER_MIE_out/Breast_10_nsTumor.whole.h5 /research/projects/yu3grp/scRNASeq/yu3grp/metastasis/02_Breast_cancer/02_scMINER/Breast_10_nsTumor/scMINER_Breast_10_nsTumor/scMINER_MIE_out/Breast_10_nsTumor_mi.h5 /research/projects/yu3grp/scRNASeq/yu3grp/metastasis/02_Breast_cancer/02_scMINER/Breast_10_nsTumor/scMINER_Breast_10_nsTumor/ Breast_10_nsTumor --k 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 --perplexity 80
