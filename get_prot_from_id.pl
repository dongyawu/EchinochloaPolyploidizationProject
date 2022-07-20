#! /usr/bin/perl

my $prot = shift || die "";
my $list = shift || die "";

%hash;
$str;
@array;

open IN,"$prot";
while (<IN>){
	chomp;
	if (/^>/){
		$hash{$array[1]}=$str;
		$str="";
		@array=split(/\>/,$_);
	}
	else {
		$str.=$_;
	}
}

open IN2,"$list";
open OUT,">$list.prot";
while (<IN2>){
	chomp;
	print OUT ">".$_."\n";
	print OUT $hash{$_}."\n";
}

