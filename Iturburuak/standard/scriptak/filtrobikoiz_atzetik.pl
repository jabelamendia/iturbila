#!/usr/bin/perl
# Parametroak: $1 fitxategia, hitz zerrenda bat du formatu honekin
#     hitza pisua automataren_erantzuna (ezagutzen ez duenean, +?)
# Programa honek detektatzen du "ccc" katearekin hasten diren
# lerroak eta ordezten ditu: ccc 1 ccc katearekin.


use strict;
use warnings;

my ($lerro1);
binmode (STDOUT,":utf8");

open (FITX,$ARGV[0]) or die ("Errorea fitxategia zabaltzen: $!\n");
binmode FITX,":utf8";

while ($lerro1=<FITX>) {
   chomp($lerro1);
   if ($lerro1=~/^ccc/) {
      printf("ccc\t1\tccc\n");
   } else {
      printf ("$lerro1\n");
   }
}


close (FITX);
