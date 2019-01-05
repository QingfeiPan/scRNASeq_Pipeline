#!/usr/bin/perl

use strict;
use warnings;

## Specify the arguments
my $project = "MouseATLAS";
my $queue = "large_mem";
my $core = 1;

open (SH1, "> ./02_runMICA.sh") or die;
open (SH2, "> ./03_poolFigures.sh") or die;
open (IN, "../02_runMIE/01_sampleList.txt") or die;
while (<IN>) {
    chomp;
    next if ($_ =~ /^Sample/);
    next if ($_ =~ /^##/);
    my @F = split(/\s+/, $_);
    my $memory = ($F[3] * 5);

    open (OUT, "> ./$F[0]_$F[1]_MICA.sh") or die;
    print OUT "#BSUB -P $project\n#BSUB -M $memory\n#BSUB -oo $F[0]_$F[1]_MICA.out -eo $F[0]_$F[1]_MICA.err\n#BSUB -J $F[0]_$F[1]\n#BSUB -q $queue\n\n";

    print OUT "python3=/hpcf/apps/python/install/3.6.1/bin/python3.6\n";
    print OUT "scMINER=/research/projects/yu3grp/scRNASeq/yu3grp/qpan/Software/scMINER/scMINER-20180523/scMINER.py\n\n";

    print OUT "## Mutual Information Clustering Analysis\n";
    print OUT "\$python3 \$scMINER MICA Clust $F[0] $F[2]/scMINER_$F[0]/scMINER_MIE_out/$F[0].whole.h5 $F[2]/scMINER_$F[0]/scMINER_MIE_out/$F[0]_mi.h5 $F[2]/scMINER_$F[0]/ $F[0] --k 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 --perplexity 60 --retransformation 80 --resource $memory $memory $memory $memory $memory $memory\n";
    print SH1 "bsub < ./$F[0]_$F[1]_MICA.sh\n";
    my $dirname = "$F[2]/scMINER_$F[0]/scMINER_MICA_figures";
    mkdir $dirname unless (-e $dirname);
    print SH2 "cp $F[2]/scMINER_$F[0]/\*_MDS_\*/scMINER_MICA_out/\*.rplot.pdf $dirname\n";
}
close IN;
close SH1; close SH2;
