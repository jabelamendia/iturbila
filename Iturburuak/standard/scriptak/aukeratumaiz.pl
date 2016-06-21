#!/usr/bin/perl
#Parametroak:
# $1 fitxategia, hitzen maiztasuna duen fitxategia; 
# $2: aukerak dituen fitxategia. Maiztasunaren arabera aukeraketa bat egingo dugu.
#     Fitxategi honen formatua lerro bakoitzean:
#		sarrera		irteera
# Sarrera bera duten irteerak lerro jarraian daude, lerro zuririk gabe haien artean.
# Beti dago lerro zuria sarrera baten irteerak eta gero (HORI GARRANTZITSUA DA PROGRAMAK
# FUNTZIONA DEZAN!!).
 

use strict;
use warnings;

my ($lerro1,$galdera,$erantzuna,$maiztasuna,$atera);
my (@banatuta);
my %taula;

binmode STDOUT,":utf8";

if (@ARGV < 2) {
	die ("Bi parametro behar dira: maiztasunak dituenfitxategia eta galdera_erantzuna fitxategia\n\n");
}

open (FITX1,$ARGV[0]) or die ("Errorea lehen fitxategia zabaltzen: $!\n");
binmode (FITX1,":utf8");
open (FITX2,$ARGV[1]) or die ("Errorea bigarren fitxategia zabaltzen: $!\n");
binmode (FITX2,":utf8");

while ($lerro1=<FITX1>){
  chomp($lerro1); 
  @banatuta = split (/\s+/,$lerro1); #maiztasuna eta hitza banatu
  if ($banatuta[0]eq""){
       shift(@banatuta);
  }
  $banatuta[0]=int($banatuta[0]);

  if ($banatuta[0]>1){
      $taula{$banatuta[1]}=$banatuta[0]; # hash taulan kargatu
#  printf("AAA $taula{$banatuta[1]}\n");
  }
}

# galdera-erantzuna duen fitxategiaren tratamendua
while ($lerro1=<FITX2>) {
    chomp($lerro1);
    @banatuta = split (/\s+/,$lerro1); #galdera eta erantzuna banatu
    $galdera = $banatuta[0];
    $erantzuna = $banatuta[1];
    $maiztasuna = 0;
    if (exists($taula{$banatuta[1]})){
	$maiztasuna = $taula{$banatuta[1]};
    }
    $atera=0;
    while  ($atera==0) {
	$lerro1=<FITX2>; #lerro berri bat irakurri
	chomp($lerro1);
	if ($lerro1 ne "") { #ez bada lerro zuria badakigu galdera bera izango duela hasieran baina ziurtatzen dugu
	    @banatuta = split (/\s+/,$lerro1);
	    if (($banatuta[0] ne $galdera)){
		die("Arazoak bigarren fitxategiaren formatuarekin\n");
	    }
            if (exists($taula{$banatuta[1]})) {
		if ($taula{$banatuta[1]}>$maiztasuna) {
		    $maiztasuna = $taula{$banatuta[1]};
		    $erantzuna=$banatuta[1];
		}}}
        else { # lerro zuriak adierazten du galdera berria datorrela edo bukatu dela fitxategia
	      printf ("$galdera\t$erantzuna\n");
	      $atera=1;
	}
    }
}
  
#foreach $item (keys %taula)
#{
#   $taula{$item}=~ m/,/;
#   $taula{$item}= $'; 
#   printf ("$item\t$taula{$item}\n");
#}

close(FITX1);
close(FITX2);
