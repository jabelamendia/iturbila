#!/usr/bin/perl
# 
# $1: testeko zerrenda duen fitxategia

# Erantzun "tontoa" ematen duten programa: aldaerako hitz bakoitzaren ondoan +? erantzuna.

use strict;
use warnings;

my ($lerro1);

binmode (STDOUT,":utf8");

open (FITX1,$ARGV[0]) or die ("Errorea zerrendako fitxategia zabaltzen: $!\n");
binmode (FITX1,":utf8");

# 1. urratsa
while ($lerro1=<FITX1>) {
 chomp ($lerro1);
 printf ("$lerro1\t+?\n");
}

close (FITX1); 


