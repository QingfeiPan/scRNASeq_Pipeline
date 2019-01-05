#!/usr/bin/perl

use strict;
use warnings;

open (SH, "> ./03_run_Rmd.sh") or die;
open (IN, "./01_sample_list.txt") or die;
while (<IN>) {
    chomp;
    next if ($_ =~ /^#/);
    my @F = split(/\s+/, $_);
##    $F[3] =~ /(\/.+)\/[hg19|mm10]/; my $dir = $1; mkdir $dir unless (-e $dir);
    mkdir $F[3] unless (-e $F[3]);
    open (OUT, "> $F[3]/$F[0]_$F[1]_scMINER_input.Rmd") or die;
    open (REF, "/Volumes/yu3grp/scRNASeq/yu3grp/qpan/Software/scRNAseq/02_scRNASeq_MICA_Input.Rmd") or die;
    while (<REF>) {
        chomp;
        $_ =~ s/argv\[1\]/\"$F[0]\"/;
        $_ =~ s/argv\[2\]/\"$F[1]\"/;
        $_ =~ s/argv\[3\]/\"$F[2]\"/;
        $_ =~ s/argv\[4\]/\"$F[3]\"/;
        print OUT "$_\n";
    }
    close REF; close OUT;
    print SH "Rscript -e \"rmarkdown::render(\'$F[3]/$F[0]_$F[1]_scMINER_input.Rmd\')\"\n";
}
close IN; close SH;
