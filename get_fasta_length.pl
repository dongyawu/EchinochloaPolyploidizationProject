#! /usr/bin/perl

use warnings;

my $fasta=shift;
open OUT,">$fasta\_length";
open IN,"$fasta";

while(<IN>){
	chomp;
	if(/^>/){
		$contig=$_;
		$hash{$contig}=0;
	}
	else{
		$hash{$contig}+=length($_);
	}
}

foreach $i (sort keys %hash){
	print OUT $i."\t".$hash{$i}."\n";
}
