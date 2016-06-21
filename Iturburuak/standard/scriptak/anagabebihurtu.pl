#!/usr/bin/perl
#Parametroak:
#$1 fitxategia: hainbat biko jasotzen ditu 
#   "sarrera   irteera"  edo  "sarrera    +?"
# Erantzuna "+?" bada, sarrerako hitzarekin ordeztuko du

 

use strict;
use warnings;

my ($lerro1);
my (@banatuta,);

binmode (STDOUT,":utf8");
open (FITX1,$ARGV[0]) or die ("Errorea lehen fitxategia zabaltzen: $!\n");
binmode (FITX1,":utf8");

while ($lerro1=<FITX1>){
  chomp($lerro1); 
  @banatuta = split (/\s+/,$lerro1); #bi hitzak banatu
  if ($banatuta[1] eq "+?") {
	printf("$banatuta[0]\t$banatuta[0]\n");
  } else {
	printf("$lerro1\n");
  }
}

close(FITX1);
