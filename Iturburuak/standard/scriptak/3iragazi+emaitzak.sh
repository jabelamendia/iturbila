#!/bin/bash

#######
# jarraitutako urratsen laburpena
# PARAMETROAK:
# $1: test-eko fitxategia, lerro bakoitzean hitza eta erantzuna
# $2: ikasteko dugun fitxategia, lerro bakoitzean bikote bat
# $3: phonetisaurus-entzat katalogoa
# $4: erabili behar den automata: hitz, hitz_bik
# $5: eskatu den erantzun kopurua (fitxategia identifikatzeko)


# IRAGAZKIAK  #
###############

# hirugarren zutabean dago ea ezaguna den aztertu behar duguna
if [ $4 = hitz ]
then
cut $1.sar.$5.phon2 -f3 | flookup ~jirxuxen/foma/rules/IZASKUN/xuxen_UTF_NOALD_NORARE_foma_hitz.fst >tmp
elif [ $4 = hitz_bik ]
then
cut $1.sar.$5.phon2 -f3 | flookup ~jirxuxen/foma/rules/IZASKUN/xuxen_UTF_NOALD_NORARE_foma_hitz_bik.fst >tmp
#elif [ $4 = banI ]
#then
#elif [ $4 = banII ]
#then
else
echo "AUTOMATA ADIERAZI BEHAR DUZU"
exit 1
fi
# aurreko fitxategiko lerro zuriak kendu eta automataren erantzuna soilik utzi
grep . tmp >tmp2

# $1 fitxategiko lehen zutabeak (testeko hitzak eta pisua)
cut -f1,2 $1.sar.$5.phon2 >tmp3

# elkartzen ditugu formatu egokiko fitxategia eta analisiaren emaitza duena
paste tmp3 tmp2 >tmp4

# erantzunak kendu baino lehen "ccc" sarrerak tratatu behar dira. horiek sartu ditugu hasieran hitz bera
# jarraian ageri bada
../scriptak/filtrobikoiz_atzetik.pl tmp4 >tmp5

# filtratzen da automataren arabera ("ccc" kateak ez aurreko filtroagatik) 
# grep -v "+?" tmp5 >tmp6

if [ $4 = hitz ]
then
../scriptak_hitza/iragaziazpimarra.pl tmp5 >tmp6
elif [ $4 = hitz_bik ]
then
grep -v "+?" tmp5 >tmp6
fi

# pisuaren arabera, erantzuna aukeratzen dugu
../scriptak/aukeratuprob.pl tmp6 >tmp7

# kendu ccc sarrerak
grep -v ccc tmp7 | cut -f1,3 >$1.sar.phon.$5.$4

# erantzunaren lehen letra aldatu sarrera larriz hasten bada
#/sc01a4/users/acpetuzi/2013_tweet/probaOSOA/scriptak/lehenletra.pl $1.sar $1.sar.xeh.phon >$1.sar.phon

rm tmp*

echo "*********************************************"
echo "EMAITZAK $1 erantzun-kop: $5 automata: $4"
echo "*********************************************"

../scriptak/sortu_txuria.pl $1.sar >txuria
../scriptak/konbiberria.pl $1.sar $1.sar.phon.$5.$4 txuria txuria txuria >$1.sar.phon.$5.$4.denak
../scriptak/kalkulatu.sh $1 $1.sar.phon.$5.$4.denak

echo "AZKEN URRATSA GEHITUTA"

../scriptak/azkenurratsa.pl $1.sar.phon.$5.$4.denak >$1.sar.phon.$5.$4.beti
../scriptak/kalkulatu.sh $1 $1.sar.phon.$5.$4.beti
echo
echo

