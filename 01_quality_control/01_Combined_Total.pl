#!/usr/bin/perl

use strict;
use warnings;

##NOTE: This script is used to combine the scRNA-Seq cells by 10X Genomics. The input and output of this script are both standard output of Cell Ranger, and can be directly used for downstream analysis.


my @samples = qw/Breast_10_nsTumor Breast_30_nsTumor Breast_10_sTumor Breast_30_sTumor Breast_10_sLymph Breast_30_sLymph Lung_10_nsLung Lung_30_nsLung Lung_10_sLymph Lung_30_sLymph Spleen_10_sSpleen Spleen_30_sSpleen/; ## List of samples for combination.
my @dirs = (
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0213_AHT5LKBBXX/E_Tumor_2/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0213_AHT5LKBBXX/C_Tumor_1/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0213_AHT5LKBBXX/F_Tumor_2_CD45_high/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0213_AHT5LKBBXX/D_Tumor_1_CD45_high/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0214_BHT3LLBBXX/L_Tumor_2_LN/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0214_BHT3LLBBXX/I_Tumor_1_LN/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0213_AHT5LKBBXX/B_Lung_2/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0213_AHT5LKBBXX/A_Lung_1/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0214_BHT3LLBBXX/K_Lung_2_LN/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0213_AHT5LKBBXX/H_Lung_1_LN/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0214_BHT3LLBBXX/J_Spleen_2/outs/filtered_gene_bc_matrices/mm10",
    "/research/dept/cmpb/genomicsLab/runs/180309_K00202_0213_AHT5LKBBXX/G_Spleen_1/outs/filtered_gene_bc_matrices/mm10"
); ## Corresponding directories of samples listed above.

my $outdir = "/research/projects/yu3grp/scRNASeq/yu3grp/metastasis/02_Breast_cancer/01_quality_control/00_cell_combination/Combined_Total";
mkdir $outdir unless (-e $outdir);

## Prepare the Gene list file
`cp $dirs[0]/genes.tsv $outdir/genes.tsv`; ## This file varies only by species.

## Prepare the Barcode and Matrix files

open (OUT1, "> $outdir/barcodes.tsv") or die;
open (OUT2, "> $outdir/matrix.mtx") or die;
print OUT2 "%%MatrixMarket matrix coordinate integer general\n%\n"; ## The header of matrix.mtx file. It's always the same.

my ($cell_num, $umi_num) = (0, 0);
my @total = ();
for(my$i=0;$i<@samples;$i++) {
    open (IN1, "$dirs[$i]/barcodes.tsv") or die;
    while (<IN1>) {
        chomp;
        my $tag = "$samples[$i]_$_"; ## Label the barcodes to mark the sources of cells.
        print OUT1 "$tag\n";
    }
    close IN1;

    open (IN2, "$dirs[$i]/matrix.mtx") or die;
    my $cell_serial_num = 0;
    while (<IN2>) {
        next if ($. <= 3);
        my @F = split(/\s+/, $_);
        if ($F[1] > $cell_serial_num) { ## It indicates a new cell starts.
            $cell_serial_num = $F[1];
            $cell_num++;
            my $tag = "$F[0]\t$cell_num\t$F[2]"; ## Gene_Serial_Number NewCell_Serial_Number UMI_Count
            push @total, $tag;
            $umi_num += $F[2];
        }
        else {
            my $tag = "$F[0]\t$cell_num\t$F[2]"; ## Gene_Serial_Number OldCell_Serial_Number UMI_Count
            push @total, $tag;
            $umi_num += $F[2];
        }
    }
    close IN2;
}

my $lines = join("\n", @total);
print OUT2 "27998\t$cell_num\t$umi_num\n$lines\n"; ## 27998 is the gene number of genes.tsv of mouse.
close OUT1; close OUT2;
