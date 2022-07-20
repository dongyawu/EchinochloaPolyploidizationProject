#! /usr/bin/perl

use warnings;

my $prot=shift;

open IN,"$prot";
open OUT,">EC_contig_prot.fasta";
while(<IN>){
	chomp;
	if (/^>/){
		($id,)=split(/ /,$_);
		print OUT $id."\n";
	}
	else {print OUT $_."\n";}
}
