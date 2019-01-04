#!/usr/bin/perl

use strict;
use warnings;

open (OUT1, "> ./04_Quality_control_summary.txt") or die;
open (OUT2, "> ./04_Quality_control_summary.csv") or die;

my $sample_number = 0;
open (REF, "./01_sample_list.txt") or die;
while (<REF>) {
    chomp;
    next if ($_ =~ /^##/);
    next unless ($_ =~ /^\w+/);
    my @F = split(/\s/, $_);
    print "$F[0]_$F[1] is processing...\n";
    $sample_number++;

    open (IN, "$F[3]/3_1_$F[0]_$F[1]_report.csv") or die;
    while (<IN>) {
        chomp;
        if ($_ =~ /^Name/) {
            if ($sample_number == 1) {
                print OUT2 "$_\n";
                my @F = split(/,/, $_);
                ##for(my$i=0;$i<@F;$i++) {
                ##    $F[$i] =~ s/^\"(.+)\"$/$1/g;
                ##}
                my $line = join("\t", @F);
                print OUT1 "$line\n";
                next;
            }
            else {
                next;
            }
        }
        else {
            print OUT2 "$_\n";
            my @F = split(/,/, $_);
            ##for(my$i=0;$i<@F;$i++) {
            ##    $F[$i] =~ s/^\"(.+)\"$/$1/g;
            ##}
            my $line = join("\t", @F);
            print OUT1 "$line\n";
        }
    }
    close IN;
}
close OUT1; close OUT2;
print "$sample_number Samples' QC report has been done!\n";
