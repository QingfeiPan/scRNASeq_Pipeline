#BSUB -P MouseALTAS
#BSUB -M 209667
#BSUB -oo Combined_Total_mm10_MIE.out -eo Combined_Total_mm10_MIE.err
#BSUB -J Combined_Total_mm10_MIE
#BSUB -q large_mem

python3=/hpcf/apps/python/install/3.6.1/bin/python3.6
scMINER=/research/projects/yu3grp/scRNASeq/yu3grp/qpan/Software/scMINER/scMINER-master/scMINER.py

## Mutual Information Estimation
$python3 $scMINER MIE Pipeline Combined_Total /research/projects/yu3grp/scRNASeq/yu3grp/MouseALTAS/02_primaryAnalysis/02_scMINER/Combined_Total/3_1_Combined_Total_mm10_scMINER_total.txt /research/projects/yu3grp/scRNASeq/yu3grp/MouseALTAS/02_primaryAnalysis/02_scMINER/Combined_Total/ Combined_Total --resource 209667 209667 209667 209667 209667
