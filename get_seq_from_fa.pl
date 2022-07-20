#!/usr/bin/perl

die("Usage: perl $0 <fasta file> <chr> <start> <end>\n") if @ARGV != 4;

open FH_IN, "<$ARGV[0]";
open FH_OUT, ">$ARGV[1]_$ARGV[2]_$ARGV[3].fa";

my $chr = $ARGV[1];
my $start = $ARGV[2];
my $end = $ARGV[3];

my $seq;
while(<FH_IN>){
	chomp;
	if(/^>/){
		s/^>//;
		if($chr eq $_){
			while(<FH_IN>){
				chomp;
				if( !/^>/){
					$seq .= $_;
				}else{
					last;
				}
			}
			last;
		}
	}
}

my $target = substr($seq, $start, $end-$start);
print FH_OUT ">${chr}_${start}_${end}\n";
print FH_OUT "$target\n";