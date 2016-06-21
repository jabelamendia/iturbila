#!/usr/bin/perl

use strict;
use warnings;

my ($lerro1);

binmode STDOUT, ":utf8";

open (FITX,$ARGV[0]) or die ("Errorea fitxategia zabaltzen: $!\n");
binmode FITX, ":utf8";

while ($lerro1=<FITX>) {
 $lerro1= lc($lerro1);
 printf ($lerro1);
}
close (FITX);

