#!/usr/bin/perl
# Parametroak: $1 fitxategia, hitza eta haren lema+atzizkiak ditu eta atzetik lema. 
# Izan dezake +? baldin eta analisirik ez badauka hitzak (edo denak RARE)
# Prgrama honek analisi bakarra uzten du hitz bakoitzeko: lema luzeena duena; berdinak balira,
# analisi-katea motzena duen lehen analisia (kate motzena parekatzen ari gara atzizki 
# gutxien duenarekin. 

# Hitz baten analisiak eta gero beti lerro zuria dago

use strict;
use warnings;

my ($lerro1,$lerro2,$lema,$analisia,$hitza);
my (@banatuta1,@banatuta2);
binmode (STDOUT,":utf8");

open (FITX,$ARGV[0]) or die ("Errorea fitxategia zabaltzen: $!\n");
binmode FITX,":utf8";

while ($lerro1=<FITX>) {
    chomp($lerro1);
    if (($lerro1 ne "") && ($lerro1 !~ /\+\?/)) {
	@banatuta1=split(/\s+/,$lerro1); #hitza, analisia eta lema lortu
	$lema= $banatuta1[2];
	$analisia = $banatuta1[1];
	$hitza = $banatuta1[0];
	$lerro2=<FITX>;
	chomp($lerro2);
	while ($lerro2 ne "") { #lerro txuriak adierazten du hitz berarekin jarraitzen dugula
	    @banatuta2=split(/\s+/,$lerro2); #hitza, analisia eta lema lortu
	    if (length($lema)<length($banatuta2[2])) {
		$lema=$banatuta2[2];
		$analisia = $banatuta2[1];
		$hitza = $banatuta2[0];
	    } elsif (length($lema)==length($banatuta2[2])){
		if (length($analisia)>length($banatuta2[1])) {
		    $lema=$banatuta2[2];
		    $analisia = $banatuta2[1];
		    $hitza = $banatuta2[0];
		}
	    }
	    $lerro2=<FITX>;
	    chomp($lerro2);
	}
	printf("$hitza\t$analisia\t$lema\n");
    } else {
	printf ("$lerro1\n") if ($lerro1 ne "");
    }
}
close (FITX);

