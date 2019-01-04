#!/usr/bin/perl

# prepareRmd.pl - To prepare .Rmd script for each sample listed in qualityControl_cellRanger_v2.0.txt
#
# Author: Qingfei Pan (Qingfei.Pan<@>hotmail.com), SJCRH, USA
# Version: 2.0 (Jan. 2, 2019)
# 

use strict;
use warnings;

open (SH, "> ./qualityControl_runRmd.sh") or die;
open (IN, "./qualityControl_cellRanger_v2.0.txt") or die;
while (<IN>) {
    chomp;
    next unless ($_ =~ /^\w+/);
    next if ($_ =~ /^##/); ## Skip the samples with "##" in the beginning of rows.
    my @F = split(/\s+/, $_);
    ##$F[3] =~ /(\/.+)\/[hg19|mm10]/; my $dir = $1; mkdir $dir unless (-e $dir);
    mkdir $F[3] unless (-e $F[3]);

    if ($F[0] =~ /^Combined/) {
        open (OUT, "> $F[3]/$F[0]_$F[1]_report.Rmd") or die;
        open (REF, "/Volumes/yu3grp/scRNASeq/yu3grp/qpan/Software/scRNAseq/qualityControl_cellRanger_v2.0_withoutReport.Rmd") or die;
        while (<REF>) {
            chomp;
            $_ =~ s/argv\[1\]/\"$F[0]\"/;
            $_ =~ s/argv\[2\]/\"$F[1]\"/;
            $_ =~ s/argv\[3\]/\"$F[2]\"/;
            $_ =~ s/argv\[4\]/\"$F[3]\"/;
            print OUT "$_\n";
        }
        close REF; close OUT;
        print SH "Rscript -e \"rmarkdown::render(\'$F[3]/$F[0]_$F[1]_report.Rmd\')\"\n";
    }
    else {
        open (OUT, "> $F[3]/$F[0]_$F[1]_report.Rmd") or die;
        open (REF, "/Volumes/yu3grp/scRNASeq/yu3grp/qpan/Software/scRNAseq/qualityControl_cellRanger_v2.0_withReport.Rmd") or die;
        while (<REF>) {
            chomp;
            $_ =~ s/argv\[1\]/\"$F[0]\"/;
            $_ =~ s/argv\[2\]/\"$F[1]\"/;
            $_ =~ s/argv\[3\]/\"$F[2]\"/;
            $_ =~ s/argv\[4\]/\"$F[3]\"/;
            print OUT "$_\n";
        }
        close REF; close OUT;
        print SH "Rscript -e \"rmarkdown::render(\'$F[3]/$F[0]_$F[1]_report.Rmd\')\"\n";
    }
}
close IN; close SH;
