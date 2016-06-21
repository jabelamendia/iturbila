#!/usr/bin/perl
#Parametroak:
#$1 fitxategia. Bi motako lerroak ditu, 4 zutabekoak:
#  aldakia  baliokide_std baliokide_std estandarraren_analisia
# Estandar horrek ez badu analisirik azken posizioan +? ageri da
# 
# Azken posizioan "+?" badago, posizio horretan baliokide_std kopiatuko du

 

use strict;
use warnings;

my ($lerro1);
my (@banatuta,);

binmode (STDOUT,":utf8");
open (FITX1,$ARGV[0]) or die ("Errorea lehen fitxategia zabaltzen: $!\n");
binmode (FITX1,":utf8");

while ($lerro1=<FITX1>){
  chomp($lerro1); 
  @banatuta = split (/\s+/,$lerro1); #zutabetan hitzak banatu
  if ($banatuta[3] eq "+?") {
	printf("$banatuta[0]\t$banatuta[1]\t$banatuta[2]\t$banatuta[2]\n");
  } else {
	printf("$lerro1\n");
  }
}

close(FITX1);
