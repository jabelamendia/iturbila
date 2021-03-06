#!/bin/bash

# PARAMETROAK

# $1: aldaera-estandarra bikoteak dituen fitxategia, tabuladorez banatuak.
# eskuzko anotaziotik lortua.

# Prozesua: aldaerako hitzak automatu hedatu batetik pasa ea analizatzen diren ikusteko.
# IRTEERA

# hartu aldaerako hitz zerrenda
cut -f1 $1 >$1.ald

# aztertu hitzak automata hedatuarekin.
# AGIAN HOBE automata parametro gisa???????

#cat $1.ald | flookup /sc01a7/sisx09/sx09a1/jirxuxen/foma/rules/IZASKUN/XUXEN_HEDATUA/xuxen_UTF_hedatua_hitz.fst >$1.hed.hitz.ana

cat $1.ald | flookup /sc01a7/sisx09/sx09a1/jirxuxen/foma/rules/IZASKUN/XUXEN_HEDATUA/xuxen_UTF_hedatua_hitz_NOALD.fst  >$1.hed.hitz.NOALD.tmp1

# automatak onartzen badu hitza bi lerro bueltatzen ditu beti.
# Bat letra larriz hasita eta bestea letra xehez hasita.
# BADAKIGUNEZ sarrera beti letra xehez eman zaiola, letra larriz hasten diren
# erantzunak kenduko ditugu.

grep -Pv "\t[A-ZÑ]" $1.hed.hitz.NOALD.tmp1 > $1.hed.hitz.NOALD.tmp2


# Badira hitzak irteera bat baino gehiago ematen dutenak. Batzuetan irteera bera da,
# baina errepikatua. Beste batzuetan ezberdinak dira. Badugu aurretik egindako programa
# bat maiztasunaren arabera aukeratzeko bat eta hori bera berrerabiliko dugu hemen.
# hitzen maiztasuna duen fitxategia: EB_hitzak.sort.utf.
# Programa horrek lerro zuriak ere kentzen ditu. Lortzen den fitxategiaren lerro kopurua
# $1 fitxategiarena izan behar du

../scriptak/aukeratumaiz.pl /sc01a4/users/acpetuzi/orokorrak/EB_hitzak.sort.utf $1.hed.hitz.NOALD.tmp2 >$1.hed.hitz.NOALD.tmp3

LERROKOP1=`cat $1 | wc -l `
echo $LERROKOP1

LERROKOP2=`cat $1.hed.hitz.NOALD.tmp3 | wc -l `
echo $LERROKOP2

if [ "$LERROKOP1" -ne "$LERROKOP2" ]
then echo "ARAZOAK ERANTZUN KOPURUAN. AZTERTU $1.hed.hitz.NOALD.tmp3 FITXATEGIA"
else echo "KOPURU BERDINAK"
fi

