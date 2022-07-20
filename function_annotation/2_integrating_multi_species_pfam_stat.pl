#! /usr/bin/perl

use warnings;

$list = shift || die "perl $0 multi_species_pfamstat \n";

### multi_species_pfamstat is a txt-format file with TAB separation.pfamstat was generated from interproscan_filter_summary.pl. 
### Each line looks lile "SPECIES_NAME<TAB>PATH_TO_PFAM_stat"

open IN, "$list";
while (<IN>){
	chomp;
	($sp, $stat)=split(/\t/,$_);
	$hash{$sp}=$stat;
}

foreach $i (keys %hash){
	open IN2,"$hash{$i}";
	while (<IN2>){
		chomp;
		($pfamid, $num)=split(/\t/,$_);
		${$i}{$pfamid}=$num;
		push @pfam_pool,$pfamid;
	}
	close IN2;
}

my @pfam_ID = grep { ++$count{ $_ } < 2; } @pfam_pool;

open OUT,">$list\.integrated_summary";

####OUTput header

print OUT "TERM";

foreach $i (sort keys %hash){
	print OUT "\t$i";
}

print OUT "\n";

###OUTput MAIN

foreach $m (@pfam_ID){
	print OUT "$m";
	foreach $n (sort keys %hash){
		if (exists ${$n}{$m}){
			print OUT  "\t".${$n}{$m};
		}
		else {print OUT "\t0";}
	}
	print OUT "\n";
}


