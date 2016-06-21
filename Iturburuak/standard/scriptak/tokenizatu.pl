#!/usr/bin/perl
# Parametroak: $1 fitxategia. 
# Fitxategia paragrafotan banatuta dago eta haien hitzak lortu behar ditugu.
# Programa honek paragrafoak hitzetan banatu, puntuazio ikurrak kendu eta
# hitzeka inprimatzen ditu (lerro bat hitz bat).

use strict;
use warnings;
use utf8;

my ($lerro1,$i,$garbitu,$token);
my (@esaldhitzak);

binmode (STDOUT,":utf8");

open (FITX,$ARGV[0]) or die ("Errorea fitxategia zabaltzen: $!\n");
binmode (FITX,":utf8");

while ($lerro1=<FITX>){
	chomp ($lerro1);
	if ($lerro1 =~ /\w/) { # ziurtatu hitzen bat dagoela paragrafoan
		@esaldhitzak = split (/\s+/,$lerro1); #hitzetan banandu
		for ($i=0;$i<scalar @esaldhitzak; $i++) {
	   $token= GARBITU($esaldhitzak[$i]);
			if ($token =~ /[a-zA-Z0-9Ññ]+/) { #ziurtatu karaktereren bat geratzen dela
				printf ("%s\n",$token);
			}
		}
	}
}
close(FITX);

sub GARBITU {
	my $token=shift;
	my  $garbitu=1;

#bukaeran edota hasieran egon daitezkeen puntuazio-ikurrak kendu
 while ($token=~ s/[\,|\.|\;|\:||\¿|\?|\¡|\!|\(|\)|\-|\"|\—|\»|\«]$//g) {
	}
 while ($token=~ s/^[\,|\.|\;|\:||\¿|\?|\¡|\!|\(|\)|\-|\"|\—|\»|\«]//g) {
	}

	return ($token);
}


