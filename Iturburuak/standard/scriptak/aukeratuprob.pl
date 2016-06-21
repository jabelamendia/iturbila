#!/usr/bin/perl
#Parametroak:
# $1 phonetisaurusek lortu duen emaitza jadanik BATUA ez direnak kenduta:
# 	sarrera pisua irteera ...
# Sarrera bera duten lerroen artean pisu TXIKIENA duena utziko du
# soilik.
 

use strict;
use warnings;

my ($lerro1,$aldhitz,$stdhitz,$probhitz,$prob2);
my (@banatuta);
binmode (STDOUT,":utf8");

open (FITX1,$ARGV[0]) or die ("Errorea lehen fitxategia zabaltzen: $!\n");
binmode FITX1, ":utf8";

$lerro1=<FITX1>;
chomp($lerro1);
@banatuta = split (/\s+/,$lerro1); #aldaera,estandarra eta probabilitatea banatu
$aldhitz = $banatuta[0];
$stdhitz = $banatuta[2];
$probhitz = $banatuta[1];

while ($lerro1=<FITX1>) {
    chomp($lerro1);
    @banatuta = split (/\s+/,$lerro1);
    if (($banatuta[0] eq $aldhitz)){ #hitz beraren beste irteera bada
	$prob2=$banatuta[1];
        if ($prob2<$probhitz) { # probabilitate txikienarekin geratu
              $probhitz = $prob2; 
              $stdhitz=$banatuta[2];
	}}
    else {
	printf ("$aldhitz\t$probhitz\t$stdhitz\n");
        $aldhitz = $banatuta[0];
	$stdhitz = $banatuta[2];
	$probhitz = $banatuta[1];
    }
}             
printf ("$aldhitz\t$probhitz\t$stdhitz\n");

close(FITX1);

