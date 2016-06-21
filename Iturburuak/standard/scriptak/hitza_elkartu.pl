#!/usr/bin/perl
#Parametroak:
# $1 hitzak dituen fitxategia. Lerro bakoitzean hitz bat baina karakteretan banatua.
# Adibidez:
# e m a t e n

# Programa honek zuriuneak kendu eta hitza itzultzen du.

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
  $lerroa =~ s/ //g;
  printf("$lerroa\n");
}
close (FITX1);



