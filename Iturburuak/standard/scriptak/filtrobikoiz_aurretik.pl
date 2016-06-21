#!/usr/bin/perl
# Parametroak: $1 fitxategia, hitz zerrenda bat du.
# Programa honek detektatzen du hitz jarraiak berdinak direla eta
# horien tartean "ccc" katea sartzen du.


use strict;
use warnings;

my ($lerro1,$lerro2);
binmode (STDOUT, ":utf8");

open (FITX,$ARGV[0]) or die ("Errorea fitxategia zabaltzen: $!\n");
binmode FITX,":utf8";


$lerro1=<FITX>;

while ($lerro2=<FITX>) {
   printf ($lerro1);
   if ($lerro1 eq $lerro2) {
      printf("ccc\n");
   }
   $lerro1=$lerro2;
}

printf($lerro1);

close (FITX);
