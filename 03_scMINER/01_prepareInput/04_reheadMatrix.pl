#!/usr/bin/perl

use strict;
use warnings;

open (REF, "./01_sample_list.txt") or die;
while (<REF>) {
    chomp;
    next if ($_ =~ /^##/);
    my @F = split(/\s+/, $_);
    print "$F[0] is processing...\n";

    open (IN1, "$F[3]/3_1_$F[0]_$F[1]_scMINER_total.txt") or die;
    open (OUT1, "> $F[3]/3_1_$F[0]_$F[1]_scMINER_total.txt.tmp") or die;
    while (<IN1>) {
        chomp;
        if ($. == 1) { print OUT1 "GeneSymbol\t$_\n" unless ($_ =~ /^GeneSymbol/); }
        else { print OUT1 "$_\n"; }
    }
    close IN1; close OUT1;
    `mv $F[3]/3_1_$F[0]_$F[1]_scMINER_total.txt.tmp $F[3]/3_1_$F[0]_$F[1]_scMINER_total.txt`;

    open (IN2, "$F[3]/3_2_$F[0]_$F[1]_scMINER_variable.txt") or die;
    open (OUT2, "> $F[3]/3_2_$F[0]_$F[1]_scMINER_variable.txt.tmp") or die;
    while (<IN2>) {
        chomp;
        if ($. == 1) { print OUT2 "GeneSymbol\t$_\n" unless ($_ =~ /^GeneSymbol/); }
        else { print OUT2 "$_\n"; }
    }
    close IN2; close OUT2;
    `mv $F[3]/3_2_$F[0]_$F[1]_scMINER_variable.txt.tmp $F[3]/3_2_$F[0]_$F[1]_scMINER_variable.txt`;
}
close REF;
