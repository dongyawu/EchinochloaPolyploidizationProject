#! /usr/bin/perl

use warnings;

my $fasta = shift || die "perl $0 fasta_file";

open IN, "$fasta";
open OUT, ">$fasta\_motified";

while (<IN>){
	chomp;
	if (/^\>/){
		print OUT "\n";
		print OUT $_."\n";
	}
	else {
	print OUT $_;
	}
}
