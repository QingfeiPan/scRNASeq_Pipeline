#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::Path qw(make_path);

#
# combineSamples_cellRanger_v2.0.pl - Script to merge the scRNASeq datasets by 10X Genomics.
#
# Author: Qingfei Pan (Qingfei.Pan<@>hotmail.com), SJCRH, USA
# Version: 2.0 (Jan. 2, 2019)
# This version works fine with the samples of different gene list;
# A master table of genes-by-cells will be generated;
# A statistics report will be generated. 
#
# Permission is granted to anyone to use this software for any purpose, without
# any express or implied warranty. In no event will the authors be held liable
# for any damages arising from the use of this software.
# 

## Get options
my ($help, $input);
GetOptions(
    'help|h!' => \$help,
);

my $usage = "
mergeDatasets_10X.pl:
This program can merge the single-cell RNA-Seq datasets generated by 10X Genomics Plateform.
The input for this analysis is a plain file, of which each row is for a merge and includes three columns seperated by <tab> or <space>:
    1) Sample Names: Name of samples which will be added to the cell IDs, seperated by <comma>.
    2) Input Directories: Directories of input samples, seperated by <comma>. Make sure the directory list is in the same order as name list.
    3) Output Directory: The directory to save the output files.
An example for the input file:
    ##Sample_Names      Sample_Directories          Output_Directory
    Name1,Name2,...     Directory1,Directory2,...   OutputDirectory

Usage:
    perl mergeDatasets_10X.pl <input_file.txt>
Options:
    -h|--help           print the help message.
";

if ($#ARGV < 0 or $help) {
    print "$usage";
    exit;
}

my $filename = $ARGV[0];
open (IN, $filename) or die;
while (<IN>) {
    chomp;
    next if ($_ =~ /^#/);
    my @F = split(/\s+/, $_);

    # Check the input file
    unless ($F[0] and $F[1] and $F[2]) {
        print STDERR "ERROR: Three colums representing sample names, input directories and output directory are required.\n";
        exit;
    }

    # Parsing the columes
    my @names = split(/,/, $F[0]);
    my @dirs = split(/,/, $F[1]);
    my $outdir = $F[2];

    unless ($#names == $#dirs) {
        print STDERR "ERROR: The number of sample names must be same with that of sample directories.\n";
        exit;
    }

    # Start the merge
    print STDOUT "\nThe merge of $outdir STARTS ...\n";

    # Create the output directory
    make_path($outdir) unless (-d $outdir);
    open (STAT, "> $outdir/stat.txt") or die;
    print STAT "##SampleName\tGeneNumber\tCellNumber\tUMICounts\n";

    # Read the input
    my %gene = (); my %cell = (); my %umi = ();
    my %geneInfo = (); my $umi_total = 0;
    for (my$i=0;$i<@names;$i++) {

        # Read the genes
        open (GENE, "$dirs[$i]/genes.tsv") or die;
        my %geneCode = (); my $gene_code = 0;
        while (<GENE>) {
            chomp;
            my @G = split(/\s+/, $_);
            $gene_code++;
            $geneCode{$gene_code} = "$G[1]"; ## Generally, the second colume is for the gene symbols.
            $geneInfo{$G[1]} = $_;
        }
        close GENE;

        # Read the cells
        open (CELL, "$dirs[$i]/barcodes.tsv") or die;
        my %cellCode = (); my $cell_code = 0;
        while (<CELL>) {
            chomp;
            $cell_code++;
            $cellCode{$cell_code} = "$names[$i]_$_";
        }
        close CELL;

        # Read the UMI matrix
        open (UMI, "$dirs[$i]/matrix.mtx") or die;
        my %gene_number = (); my %cell_number = (); my $umi_count = 0;
        while (<UMI>) {
            chomp;
            next if ($. <= 3);
            my @U = split(/\s+/, $_);
            next if ($U[2] <= 0);
            $gene_number{$U[0]}++; $cell_number{$U[1]}++; $umi_count += $U[2];
            $umi{$cellCode{$U[1]}}{$geneCode{$U[0]}} = $U[2];
            $gene{$geneCode{$U[0]}}++; $cell{$cellCode{$U[1]}}++;
        }
        close UMI;

        $umi_total += $umi_count; ## for the third line of matrix.mtx

        # Print the statistics info
        my $gene_number = scalar (keys %gene_number);
        my $cell_number = scalar (keys %cell_number);
        print STAT "$names[$i]\t$gene_number\t$cell_number\t$umi_count\n";
    }


    # Print the genes
    my @geneMerged_array = keys %gene;
    my $geneMerged_number = scalar @geneMerged_array;

    open (OUT1, "> $outdir/genes.tsv") or die;
    my $gene_line = join("\n", @geneMerged_array);
    print OUT1 "$gene_line\n";
    close OUT1;
    print STDOUT "<genes.tsv> is successfully printed.\n";

    # Print the cells
    my @cellMerged_array = keys %cell;
    my $cellMerged_number = scalar @cellMerged_array;

    open (OUT2, "> $outdir/barcodes.tsv") or die;
    my $cell_line = join("\n", @cellMerged_array);
    print OUT2 "$cell_line\n";
    close OUT2;
    print STDOUT "<barcodes.tsv> is successfully printed.\n";

    # Print the UMI matrix
    my @umiMerged_array = ();
    for (my$c=0;$c<@cellMerged_array;$c++) {
        my $cell_order = $c + 1;
        for (my$g=0;$g<@geneMerged_array;$g++) {
            my $gene_order = $g + 1;
            next unless (exists $umi{$cellMerged_array[$c]}{$geneMerged_array[$g]});
            push @umiMerged_array, "$gene_order $cell_order $umi{$cellMerged_array[$c]}{$geneMerged_array[$g]}";
        }
    }
    my $umiMerged_number = scalar @umiMerged_array;

    open (OUT3, "> $outdir/matrix.mtx") or die;
    print OUT3 "%%MatrixMarket matrix coordinate integer general\n%\n$geneMerged_number\t$cellMerged_number\t$umiMerged_number\n";
    my $umi_line = join("\n", @umiMerged_array);
    print OUT3 "$umi_line\n";
    close OUT3;
    print STDOUT "<matrix.mtx> is successfully printed.\n";

    # print the masterTable
    open (MSTB, "> $outdir/masterTable.txt") or die;
    my $title = join("\t", @cellMerged_array);
    print MSTB "GeneSymbol\t$title\n";
    for (my$g=0;$g<@geneMerged_array;$g++) {
        my $line = $geneMerged_array[$g];
        for (my$c=0;$c<@cellMerged_array;$c++) {
            $umi{$cellMerged_array[$c]}{$geneMerged_array[$g]} = 0 unless (exists $umi{$cellMerged_array[$c]}{$geneMerged_array[$g]});
            $line .= "\t$umi{$cellMerged_array[$c]}{$geneMerged_array[$g]}";
        }
        print MSTB "$line\n";
    }
    close MSTB;
    print STDOUT "<masterTable.txt> is successfully printed.\n";

    print STAT "Merged\t$geneMerged_number\t$cellMerged_number\t$umi_total\n";
    close STAT;
    print STDOUT "<stat.txt> is successfully printed.\n";

    print STDOUT "The merge of $outdir is DONE!\n";
}
close IN;
