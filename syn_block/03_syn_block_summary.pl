#! /usr/bin/perl

my $syn_file = shift || die "perl $0 syn_file_bga";

@EO=("EO_start","EO_end");
@EH=("EH_start","EH_end");

$EO_ctg="EO_ctg";
$EH_scaf="EH_scaf";

open IN, "$syn_file";
open OUT, ">$syn_file\.summary";
while (<IN>){
	chomp;
	if (/##/){
		print OUT $EO_ctg."\t".$EO[0]."\t".$EO[-1]."\t".$EH_scaf."\t".$EH[0]."\t".$EH[-1]."\t".@EO."\n";
		@EO=();
		@EH=();
	}
	else {
		($EO_ctg,$EO_gene,$EO_n,$EO_n2,$EH_scaf,$EH_gene,$EH_n,$EH_n2,)=split(/\t/,$_);
		push @EO,$EO_n;
		push @EH,$EH_n;
	}

}
