#! /usr/bin/perl

#use warnings;

$fasta = shift || die "perl $0 FASTA GFF!\n";
$gff = shift || die "perl $0 FASTA GFF!\n";

print "SPLIT SCAFFOLD TO CONTIG\n";

open IN,"$fasta";
open OUT,">$fasta\.contig_summary";
open SEQ,">$fasta\.contig_seq";
while (<IN>){
	chomp;
	if (/^>/){
		($s,$seq_name)=split(/\>/,$_);
		print "\n*******$seq_name******\n\n";
	}
	else {
		$seq=$_;
		
		###get_N_positions
		
		@positions=(0);
		while ($seq =~ m/(N+)/g){
			$len = length($1);
			$end = pos($seq);
			$start = $end-$len + 1;
			$contig_end=$start-2;
			$contig_start=$end;
			print "N-region: "."$seq_name\t$start\t$end\t$len\n";
			push @positions,$contig_end;
			push @positions,$contig_start;
		}
		$final_end=length($seq)-1;
		push @positions,$final_end;
#		print "@positions\n";
		
		###split2contig
		$sites=@positions;
		foreach $i (1..$sites/2){
			$con_s=shift(@positions);
			$con_sr=$con_s+1;
			$con_e=shift(@positions);
			$con_er=$con_e+1;
			$con_len=$con_e-$con_s+1;
			$contig_seq=substr($seq, $con_s, $con_len);
			print OUT $seq_name."_".$i."\t".$seq_name."\t".$con_sr."\t".$con_er."\t".$con_len."\n";
			print "Contig_region: ".$seq_name."_".$i."\t".$seq_name."\t".$con_sr."\t".$con_er."\t".$con_len."\n";
			$temp=$seq_name."_".$i;
			$hash{$temp}=$contig_seq;
		}
	}
}

###Contig_rename

print "\n\n******CONTIG RENAME*******\n";

system(qq(cat $fasta\.contig_summary | sort -r -n -k 5 > $fasta\.contig_summary_sorted));
open IN2,"$fasta\.contig_summary_sorted";
$j=1;
open OUT2,">$fasta\.contig_summary_sorted_rename";

%seq;

while (<IN2>){
	chomp;
	($contig,$scaffold,$start,$end,$length)=split(/\t/,$_);
	$contig_new="Contig".$j;
	print OUT2 $contig_new."\t".$contig."\t".$scaffold."\t".$start."\t".$end."\t".$length."\n";
	print "Contig_rename: ".$contig_new."\t".$contig."\t".$scaffold."\t".$start."\t".$end."\t".$length."\n";
	$seq{$contig_new}=$hash{$contig};
	$hash1{$contig_new} = $scaffold;
	$hash2{$contig_new} = $start;
	$hash3{$contig_new} = $end;
	$j+=1;
}

####OUTPUT CONTIG_SEQ
foreach $n (sort keys %seq){
	print SEQ ">$n\n";
	print SEQ "$seq{$n}\n";
}


###transferGFF_Positions&ID

print "\n\n*******GFF_TRANSFER******\n\n";

%hash4;

open IN4,"$fasta\.contig_summary_sorted_rename";
open IN3,"$gff";
open GFFOUT,">$gff\_contig.gff";
open NEW_GENE,">$gff\_geneID.transfer";
while (<IN3>){
	chomp;
	($scaf, $EVM, $type, $s, $e, $dian, $dire, $note, $ID)=split(/\t/,$_);
	if ($type eq "gene"){
		print "\n";
		foreach $m (keys %hash1){
			if ($hash1{$m} eq $scaf && $hash2{$m} <= $s && $hash3{$m} >= $e){
				$name = (split /\=|\;/,$ID)[1];
				print NEW_GENE  "\nold_gene: ".$name."\t";
				$new_s = $s-$hash2{$m}+1;
				$new_e = $e-$hash2{$m}+1;
				$hash4{$m}+=1;
			#	print NEW_GENE  "Contig_geneNO.".$hash4{$m}."\t";
				$new_gene = $m.".".$hash4{$m};
				print NEW_GENE "new_gene: ".$new_gene."\n";
				$new_ID = "ID=".$m.".".$hash4{$m};
			#	print $new_ID."\n";
				print GFFOUT  $m."\t".$EVM."\t".$type."\t".$new_s."\t".$new_e."\t".$dian."\t".$dire."\t".$note."\t".$new_ID."\n";
			}
		}
	}
	else{
		foreach $m (keys %hash1){
			if ($hash1{$m} eq $scaf && $hash2{$m} <= $s && $hash3{$m} >= $e){
				$new_s = $s-$hash2{$m}+1;
				$new_e = $e-$hash2{$m}+1;
				print GFFOUT $m."\t".$EVM."\t".$type."\t".$new_s."\t".$new_e."\t".$dian."\t".$dire."\t".$note."\t".$new_ID."\n";
			}
		}
	}
}

system(qq(rm -f $fasta\.contig_summary_sorted));
system(qq(rm -f $fasta\.contig_summary));
