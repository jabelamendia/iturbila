#!/usr/bin/perl
# Parametroak: $1 fitxategia, hitza eta haren lema+atzizkiak ditu baina hitz bakoitzeko bat baino.
# Analisi bakoitzaren lema ateratzen du programa honek.
# Azkenik, 0ak badaude kendu egiten ditu.


use strict;
use warnings;

my ($lerro1,$lema);
my @banatuta;
binmode (STDOUT,":utf8");

open (FITX,$ARGV[0]) or die ("Errorea fitxategia zabaltzen: $!\n");
binmode FITX,":utf8";

while ($lerro1=<FITX>) {
    chomp($lerro1); 
    if ($lerro1 ne "") {
	@banatuta=split(/\s+/,$lerro1); #hitza eta analisia lortu
	$lema= lemalortu ($banatuta[1]);
        $lerro1 =~ s/\+0//g;
	printf ("$lerro1\t$lema\n");
    } else {
	printf("$lerro1\n");
    }
}
close (FITX);

#---- AZPIERRUTINA

sub lemalortu {
    my $katea=shift;
    my @osagaiak;
    my ($aukeratua,$i);

    if ($katea=~/\+/){ 
	@osagaiak = split(/\+/,$katea);
	$aukeratua= $osagaiak[0];
        if (($osagaiak[0] eq "ez-")||($osagaiak[0] eq "ba")||($osagaiak[0] eq "bait")||($osagaiak[0] eq "beR")) {
	    $aukeratua= $osagaiak[1] if ($osagaiak[1] ne "0");
	} else {
	    $aukeratua=$osagaiak[0]
	}
    } else {
	    $aukeratua=$katea;
    }
    return ($aukeratua);
}

