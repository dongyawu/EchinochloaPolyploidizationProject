open IN,$ARGV[0];
while(<IN>){
   chomp;
  @aa=split/\t/;
if($aa[2] eq "gene" ){
   $gene=$1 if $aa[-1] =~/ID\=(.*?);Name/;
  print "$aa[0]\t$gene\t$aa[3]\t$aa[4]\n";
}
}
