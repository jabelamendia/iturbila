#!/usr/bin/perl
# 
# $1: testeko hitz zerrenda duen fitxategia
# $2,$3,$4,$5: 4 erantzun beste hainbeste metodoekin lortuak. Formatua:
#		sarrera		erantzuna (hitza edo +?)

# GARRANTZITSUA: ordenak lehentasuna markatzen du: lehentasun handienetik txikienera.

use strict;
use warnings;

my ($lerro1,$xehez,$erantzuna);
my (@hitzak);
my (%emaitza);

binmode (STDOUT,":utf8");

open (FITX1,$ARGV[0]) or die ("Errorea zerrendako fitxategia zabaltzen: $!\n");
binmode (FITX1,":utf8");
open (FITX2,$ARGV[1]) or die ("Errorea 1 metodoaren erantzun-fitxategia zabaltzen: $!\n");
binmode (FITX2,":utf8");
open (FITX3,$ARGV[2]) or die ("Errorea 2 metodoaren erantzun-fitxategia zabaltzen: $!\n");
binmode (FITX3,":utf8");
open (FITX4,$ARGV[3]) or die ("Errorea 3 metodoaren erantzun-fitxategia zabaltzen: $!\n");
binmode (FITX4,":utf8");
open (FITX5,$ARGV[4]) or die ("Errorea 4 metodoaren erantzun-fitxategia zabaltzen: $!\n");
binmode (FITX5,":utf8");


# lehen metodoaren erantzuna jaso
while ($lerro1=<FITX2>) {
 chomp ($lerro1);
 @hitzak = split (/\s+/,$lerro1); # lerroa hitzetan banatu: sarrera eta erantzuna
 		$emaitza{$hitzak[0]} = $hitzak[1] ;
}

# bigarren metodoaren erantzuna jaso
while ($lerro1=<FITX3>) {
 chomp ($lerro1);
 @hitzak = split (/\s+/,$lerro1); # lerroa hitzetan banatu: sarrera eta erantzuna
 if (exists ($emaitza{$hitzak[0]})) {
	if ($emaitza{$hitzak[0]} eq "+?") {
		$emaitza{$hitzak[0]} = $hitzak[1] ;
	} 
 } else {
	  $emaitza{$hitzak[0]} = $hitzak[1] ;
}
}

# hirugarren metodoaren erantzuna jaso
while ($lerro1=<FITX4>) {
 chomp ($lerro1);
 @hitzak = split (/\s+/,$lerro1); # lerroa hitzetan banatu: sarrera eta erantzuna
 if (exists ($emaitza{$hitzak[0]})) {
	if ($emaitza{$hitzak[0]} eq "+?") {
		$emaitza{$hitzak[0]} = $hitzak[1] ;
	} 
 } else {
     	  $emaitza{$hitzak[0]} = $hitzak[1] ;
 }
}

# laugarren metodoaren erantzuna jaso
while ($lerro1=<FITX5>) {
 chomp ($lerro1);
 @hitzak = split (/\s+/,$lerro1); # lerroa hitzetan banatu: sarrera eta erantzuna
 if (exists ($emaitza{$hitzak[0]})) {
	if ($emaitza{$hitzak[0]} eq "+?") {
		$emaitza{$hitzak[0]} = $hitzak[1] ;
	} 
 } else {
          $emaitza{$hitzak[0]} = $hitzak[1] ;
}
}

# testeko zerrenda jaso eta erantzuna eman
while ($lerro1=<FITX1>) {
 chomp ($lerro1);
 if ((exists ($emaitza{$lerro1})) && ($emaitza{$lerro1} ne "+?")) {
#     if ($emaitza{$lerro1} ne "+?") {
	 printf("$lerro1\t$emaitza{$lerro1}\n");
 } else { # begiratu ea xehez erantzuna duen hitz horrek
     $xehez=lc($lerro1);
     if (exists($emaitza{$xehez})) {
	 if ($emaitza{$xehez} ne "+?") {
	     $erantzuna=lehenletra($emaitza{$xehez});
	     printf("$lerro1\t$erantzuna\n");
	 } else {
	     printf("$lerro1\t+?\n");
	 }}
     else {
	  printf("$lerro1\t+?\n");
     }
 }
}
	 
close (FITX1); 
close (FITX2); 
close (FITX3); 
close (FITX4);
close (FITX5);

sub lehenletra {
    my $hitza=shift;
    my @letrak=split("",$hitza);
    $letrak[0]=uc($letrak[0]);
    $hitza=join("",@letrak);
    return ($hitza);
}

