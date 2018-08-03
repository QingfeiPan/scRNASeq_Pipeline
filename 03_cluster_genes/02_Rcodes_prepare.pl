#!/usr/bin/perl

use strict;
use warnings;

open (SH, "> ./03_Cluster_Gene_Analysis.sh") or die;
print SH "#BSUB -P Metastasis\n#BSUB -n 1\n#BSUB -M 64000\n#BSUB -oo 03_Cluster_Gene_Analysis.out -eo 03_Cluster_Gene_Analysis.err\n#BSUB -J Monocle_DEGs\n#BSUB -q priority\n\n";
open (IN, "./01_sample_list.txt") or die;
while (<IN>) {
    chomp;
    next if ($_ =~ /^##/);
    my @F = split(/\s+/, $_);
    mkdir $F[4] unless (-e $F[4]);
    open (OUT, "> $F[4]/$F[0]_$F[1]_Cluster_Gene.R") or die;
    open (REF, "./00_Cluster_Gene_Analysis_Template_byMonocle.R") or die;
    while (<REF>) {
        chomp;
        $_ =~ s/argv\[1\]/\"$F[0]\"/;
        $_ =~ s/argv\[2\]/\"$F[1]\"/;
        $_ =~ s/argv\[3\]/\"$F[2]\"/;
        $_ =~ s/argv\[4\]/\"$F[3]\"/;
        $_ =~ s/argv\[5\]/\"$F[4]\"/;
        print OUT "$_\n";
    }
    close REF; close OUT;
    print SH "Rscript $F[4]/$F[0]_$F[1]_Cluster_Gene.R\n";
}
close IN; close SH;
