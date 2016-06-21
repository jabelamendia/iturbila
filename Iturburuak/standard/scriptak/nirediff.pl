#!/usr/bin/perl
#Parametroak:
#$1 lehen fitxategia; $2: bigarren fitxategia
 

use strict;
use warnings;

my ($lerro1,$lerro2);


binmode (STDOUT,":utf8");

open (FITX1,$ARGV[0]) or die ("Errorea lehen fitxategia zabaltzen: $!\n");
binmode (FITX1,":utf8");
open (FITX2,$ARGV[1]) or die ("Errorea bigarren fitxategia zabaltzen: $!\n");
binmode (FITX2,":utf8");

while ($lerro1=<FITX1>){
  chomp($lerro1); 
  $lerro2=<FITX2>;
  chomp($lerro2);
  if ($lerro1 eq $lerro2) {
    printf("$lerro1\t\t\t\t\t(\n");
    } else {
             printf("$lerro1\t\t\t\t\t|\t$lerro2\n");
    }
}

close(FITX1);
close(FITX2);
