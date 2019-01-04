#BSUB -P Metastasis
#BSUB -n 1
#BSUB -M 500000
#BSUB -oo std.out -eo std.err
#BSUB -J scRNASeq_Merge
#BSUB -q large_mem

dir=/research/projects/yu3grp/scRNASeq/yu3grp/MouseALTAS/02_scMINER/01_qc/00_combination

perl $dir/mergeDatasets_10X.pl $dir/Sample_Combination.txt
