#! /usr/bin/perl

#use warnings;

my $pfam = shift || die "perl $0 Pfam_file";
#my $cutoff = shift || die "perl $0 Pfam_file Evalue";

%hash;

open IN, "$pfam";
open OUT, ">$pfam\_filtered";
while (<IN>){
	chomp;
	($gene, $leng, $pfamID, $des, $s, $e, $evalue, $ipr, $anno,)=split(/\t/,$_);
	$var=$gene.$pfamID;
#	print $var."\n";
	if (exists $hash{$var}){
		next;
	}
	else {
		$hash{$var}=0;
	#	if ($evalue lt $cutoff){
			print OUT $gene."\t".$leng."\t".$pfamID."\t".$des."\t".$s."\t".$e."\t".$evalue."\t".$ipr."\t".$anno."\n";
	#	}
	}
}
