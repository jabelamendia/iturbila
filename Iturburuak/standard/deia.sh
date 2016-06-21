#!/bin/bash

FITXATEGIA=$1
KATALOGOA="phonetis"
ERANTZUN_KOPURUA=5
AUTOMATA="datuak/xuxen_UTF_NOALD_NORARE_foma.fst"

if [ -z $FITXATEGIA ]; then 
	echo "Fitxategia pasatu behar da!" 
else
	standard/scriptak/2testphon.sh $FITXATEGIA $KATALOGOA $ERANTZUN_KOPURUA $AUTOMATA
fi

