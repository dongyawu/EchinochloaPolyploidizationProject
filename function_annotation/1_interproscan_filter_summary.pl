#! /usr/bin/perl

#use warnings;

my $pfam = shift || die "perl $0 Pfam_file cutoff !\n" ;
my $cutoff = shift || die "perl $0 Pfam_file cutoff !\n" ;

%hash;
%hash2;

open IN, "$pfam";
while (<IN>){
	chomp;
	($gene, $md5, $length, $tag, $pfamid, $pfam_anno, $start, $end, $evalue, $t, $time, $ipr, $ipr_anno, $go,)=split(/\t/,$_);
	if ($evalue <= $cutoff){
		$hash{$pfamid}+=1;
		@go_term=split(/\|/,$go);
		foreach $i (@go_term){
			$hash2{$i}+=1;
		}
	}

}

open OUT1,">$pfam\_$cutoff\.pfam";
open OUT2,">$pfam\_$cutoff\.go";
foreach $m (sort keys %hash){
	print OUT1 $m."\t".$hash{$m}."\n";
}
foreach $n (sort keys %hash2){
	print OUT2 $n."\t".$hash2{$n}."\n";
}

close OUT1;
close OUT2;
close IN;
