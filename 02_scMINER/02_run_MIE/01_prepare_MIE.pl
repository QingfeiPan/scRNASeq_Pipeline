#!/usr/bin/perl

use strict;
use warnings;

## Specify the arguments
my $project = "Metastasis";
my $queue = "priority";

open (SH, "> ./02_run_MIE.sh") or die;
open (IN, "./00_sample_list.txt") or die;
while (<IN>) {
    chomp;
    next if ($_ =~ /^Sample/);
    next if ($_ =~ /^##/);
    my @F = split(/\s+/, $_);
    my $memory = ($F[3] * 3); ## The default memory used in MIE.

    open (OUT, "> ./$F[0]_$F[1]_MIE.sh") or die;
    print OUT "#BSUB -P $project\n#BSUB -M $memory\n#BSUB -oo $F[0]_$F[1]_MIE.out -eo $F[0]_$F[1]_MIE.err\n#BSUB -J $F[0]_$F[1]\n#BSUB -q $queue\n\n";

    print OUT "python3=/hpcf/apps/python/install/3.6.1/bin/python3.6\n";
    print OUT "scMINER=/research/projects/yu3grp/scRNASeq/yu3grp/qpan/Software/scMINER/scMINER-20180523/scMINER.py\n\n";

    print OUT "## Mutual Information Estimation\n";
    print OUT "\$python3 \$scMINER MIE Pipeline $F[0] $F[2]/3_1_$F[0]_$F[1]_scMINER_total.txt $F[2]/ $F[0]\n";
    print SH "bsub < ./$F[0]_$F[1]_MIE.sh\n";
}
close IN;
close SH;
