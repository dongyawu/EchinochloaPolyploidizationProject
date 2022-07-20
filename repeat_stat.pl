#! /usr/bin/perl

use warnings;

my $repeat = shift || die "";

my %hash1;
my %hash2;

open IN,"$repeat";
open OUT,">$repeat\_stat";

while (<IN>){
	chomp;
	($chr, $s, $e, $type)=split(/\t/,$_);

	$length=$e-$s+1;
	$hash1{$type}+=1;
	$hash2{$type}+=$length;

}

foreach $i (sort keys %hash1){
	
	print OUT $i."\t".$hash1{$i}."\t".$hash2{$i}."\n";

}
