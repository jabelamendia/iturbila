#!/bin/bash

#######
# jarraitutako urratsen laburpena
# PARAMETROAK:
# $1: test-eko fitxategia
# $2: phonetisaurus-entzat katalogoa
# $3: eskatutako erantzun kopurua
# $4: erantzunak iragazteko automata

KOKALEKUA="standard/"
# testeko zerrendan hitz bera jarraian ageri bada, tratatu (ccc katea sartzen da tartean)
#scriptak/filtrobikoiz_aurretik.pl $1 >$1.berria

# phonetisaurus-i galdetu $3 erantzun eman ditzan
#echo "ESKATUTAKO ERANTZUNAK: $3"
phonetisaurus-g2p --model=${KOKALEKUA}datuak/$2/$2.fst --input=$1 --isfile --words --nbest=$3  --beam=5000 >$1.phon2

#erantzuna egokitu
cut -f3 $1.phon2 >${KOKALEKUA}tmp
${KOKALEKUA}scriptak/hitza_elkartu.pl ${KOKALEKUA}tmp >${KOKALEKUA}tmp2

cut -f1,2 $1.phon2 >${KOKALEKUA}tmp
paste ${KOKALEKUA}tmp ${KOKALEKUA}tmp2 >$1.phon2

# begiratu phonetisaurus-ek itzulitakoa onartzen duen automatak
cut $1.phon2 -f3 | flookup ${KOKALEKUA}$4 >${KOKALEKUA}tmp

# aurreko fitxategiko lerro zuriak kendu eta automataren erantzuna soilik utzi
grep . ${KOKALEKUA}tmp >${KOKALEKUA}tmp2

# $1 fitxategiko lehen zutabeak (testeko hitzak eta pisua)
cut -f1,2 $1.phon2 >${KOKALEKUA}tmp3

# elkartzen ditugu formatu egokiko fitxategia eta analisiaren emaitza duena
paste ${KOKALEKUA}tmp3 ${KOKALEKUA}tmp2 >${KOKALEKUA}tmp4

# onartzen ez direnak kendu
grep -v "+?" ${KOKALEKUA}tmp4 >${KOKALEKUA}tmp6

# pisuaren arabera, erantzuna aukeratzen dugu
${KOKALEKUA}scriptak/aukeratuprob.pl ${KOKALEKUA}tmp6 >${KOKALEKUA}tmp7

# kendu ccc sarrerak eta pisua azken erantzuna emateko
cut -f1,3 ${KOKALEKUA}tmp7 > $1.phon3

${KOKALEKUA}scriptak/sortu_txuria.pl $1 >txuria

${KOKALEKUA}scriptak/konbiberria.pl $1 $1.phon3 txuria txuria txuria >$1.phon4
chmod -R 666 $1.*

rm ${KOKALEKUA}tmp*
