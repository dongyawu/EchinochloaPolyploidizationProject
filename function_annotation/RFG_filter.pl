#! /usr/bin/perl

my $file = shift || die "perl $0 BLAST_file Identity Evalue!\n";
my $iden = shift || die "";
my $eth = shift || die "";

open IN,"$file";
open OUT,">$file\_$iden\_$eth";
while (<IN>){
	chomp;
	@array=split(/\t/,$_);
	if ($array[2] > $iden && $array[10] < $eth){
		print OUT $array[0]."\t".$array[1]."\t".$array[2]."\t".$array[10]."\n";
	}
}
close IN;
close OUT;

system(qq(cat $file\_$iden\_$eth | cut -f2 | sort | uniq -c | perl -npe "s/ +//" | perl -npe "s/ /\t/g" > $file\_$iden\_$eth.summary));

