Files:

01_scRNASeq_QC_with_cellranger.Rmd: Rmarkdown template for sample with CellRanger summary file--metrics_summary.csv
01_scRNASeq_QC_without_cellranger.Rmd: Markdown template for sample without CellRanger summary file--metrics_summary.csv
01_sample_list.txt: Four columns: Sample ID, Species (hg19/mm10), Input_Directory (Directory of CellRanger outputs) and Output_Directory (Directory to save QC output files).
02_get_Rmd.pl: To generate the Rmarkdown scripts of QC for each sample. 03_run_QC.sh will be generated to run these scripts.
03_run_QC.sh: generaged by 02_get_Rmd.pl.
04_Quality_control_summary.pl: summarize the quality control outputs. '04_Quality_control_summary.txt' and '04_Quality_control_summary.csv' will be generated.
