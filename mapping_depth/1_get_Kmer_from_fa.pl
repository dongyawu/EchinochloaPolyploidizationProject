#!/usr/bin/perl

die("Usage: perl $0 <fasta file> <Kmer_length, e.g. 150bp> <Step e.g. 5bp>\n") if @ARGV != 3;

open IN, "<$ARGV[0]";
open OUT, ">$ARGV[0]_$ARGV[1].kmer";
my $step=$ARGV[2];

while(<IN>){
	chomp;
	if(/^>/){
		s/^>//;
		$seq_num = $_;
		while(<IN>){
			chomp;
			$seq = $_;
			$num = length($seq)-$ARGV[1];
			foreach $i (0..$num){
   				if($i % $step == 0){
					print OUT ">".$seq_num."_".$i."\n";
					print OUT substr($seq,$i,$ARGV[1])."\n";
    				}
			}
		last;
		}
	}
}
