#! /usr/bin/perl

my $summary= shift || die;

####首先根据共线基因数多少排序，确定最佳定位染色体

open IN,"$summary";
open OUT,">$summary\_intg";

while (<IN>){
	chomp;
	($EO, $EO_s, $EO_e, $EH, $EH_s, $EH_e, $Num)=split(/\t/,$_);
	@EO_array=($EO_s..$EO_e);
	@EH_array=($EH_s..$EH_e);
	$sum=$Num;
	while (<IN>){
		chomp;	
		($EO_ctg, $EO_s, $EO_e, $EH_scaf, $EH_s, $EH_e, $Num)=split(/\t/,$_);
		
		if ($EH_s > $EH_e){$max=$EH_s;$EH_s=$EH_e;$EH_e=$max;}
	
		if ($EO_ctg eq $EO and $EH_scaf eq $EH){
			for $i ($EO_s..$EO_e){
				push @EO_array,$i;
			}
			for $j ($EH_s..$EH_e){
				push @EH_array,$j;
			}
			$sum+=$Num;
		}
		if ($EO_ctg eq $EO and $EH_scaf ne $EH){
			next;
		}
		if ($EO_ctg ne $EO){
			my @EO_array_sort = sort { $a <=> $b } @EO_array;
			my @EH_array_sort = sort { $a <=> $b } @EH_array;
			print OUT $EO."\t".$EO_array_sort[0]."\t".$EO_array_sort[-1]."\t".$EH."\t".$EH_array_sort[0]."\t".$EH_array_sort[-1]."\t".$sum."\n";
			$EO=$EO_ctg;
			$EH=$EH_scaf;
			@EO_array=($EO_s..$EO_e);
			@EH_array=($EH_s..$EH_e);
			$sum=$Num;
		}
	
	}
	my @EO_array_sort = sort { $a <=> $b } @EO_array;
	my @EH_array_sort = sort { $a <=> $b } @EH_array;
	print OUT $EO."\t".$EO_array_sort[0]."\t".$EO_array_sort[-1]."\t".$EH."\t".$EH_array_sort[0]."\t".$EH_array_sort[-1]."\t".$sum."\n";
}
