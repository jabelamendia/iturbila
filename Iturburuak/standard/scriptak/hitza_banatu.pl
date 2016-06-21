#!/usr/bin/perl
#Parametroak:
# $1 hitz bikoteak dituen fitxategia. Lerro bakoitzean bi hitz (sarrera/erantzuna)
# tabuladore batez banatuak.
# Adibidez:
# emaiten   ematen

# Programa honek lehen hitza bere horretan uzten du eta bigarrena karakteretan banatzen du.
# Adibidez:
# emaiten   e m a t e n

use strict;
use warnings;
use locale;

my ($lerroa,$i,$aldatuta);
my (@hitzak,@karak);

binmode (STDOUT,":utf8");

open (FITX1,$ARGV[0]) or die ("Errorea lehen fitxategia zabaltzen: $!\n");
binmode FITX1, ":utf8";

while ($lerroa=<FITX1>)
{
  chomp ($lerroa);
  @hitzak =  split (/\s+/,$lerroa);
  @karak = split (//,$hitzak[1]); #karakteretan banatu bigarren hitza
  printf("$hitzak[0]\t"); #lehen hitza daogen bezala
  for ($i=0 ;$i<((scalar @karak)-1);$i++) # bigarren hitza karakterez karaktere
        { 
         printf("$karak[$i] ");
        }
  printf("$karak[$i]\n"); #azken karakterea eta return
}

#printf("c\tc\n"); # c letrak eman dituen arazoak konpontzeko. NOVAK-ek proposatua
		  # eta funtzionatzen du
close (FITX1);



