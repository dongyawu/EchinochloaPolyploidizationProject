#!/usr/bin/perl

use strict;
use warnings;

my $input = shift or die "CDS aligned fasta?";

open IN, $input;
open OUT, ">$input.axt";

my $tit;
my %seq;
while(<IN>){
  chomp;
  if(/>(\S+)/){
    $tit = $1;	
  }else{
    $seq{$tit} .= $_;	
  }	
}
close IN;

my @tits = sort keys%seq;
my $combined_tit = $tits[0]."|".$tits[-1];
my $seq1 = $seq{$tits[0]};
my $seq2 = $seq{$tits[-1]};
print OUT "$combined_tit\n$seq1\n$seq2\n";