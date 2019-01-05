#BSUB -P MouseATLAS
#BSUB -M 12495
#BSUB -oo Combined_Bladder_mm10_MICA.out -eo Combined_Bladder_mm10_MICA.err
#BSUB -J Combined_Bladder_mm10
#BSUB -q large_mem

python3=/hpcf/apps/python/install/3.6.1/bin/python3.6
scMINER=/research/projects/yu3grp/scRNASeq/yu3grp/qpan/Software/scMINER/scMINER-20180523/scMINER.py

## Mutual Information Clustering Analysis
$python3 $scMINER MICA Clust Combined_Bladder /research/projects/yu3grp/scRNASeq/yu3grp/MouseALTAS/02_primaryAnalysis/02_scMINER/Combined_Bladder/scMINER_Combined_Bladder/scMINER_MIE_out/Combined_Bladder.whole.h5 /research/projects/yu3grp/scRNASeq/yu3grp/MouseALTAS/02_primaryAnalysis/02_scMINER/Combined_Bladder/scMINER_Combined_Bladder/scMINER_MIE_out/Combined_Bladder_mi.h5 /research/projects/yu3grp/scRNASeq/yu3grp/MouseALTAS/02_primaryAnalysis/02_scMINER/Combined_Bladder/scMINER_Combined_Bladder/ Combined_Bladder --k 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 --perplexity 60 --retransformation 80 --resource 12495 12495 12495 12495 12495 12495
