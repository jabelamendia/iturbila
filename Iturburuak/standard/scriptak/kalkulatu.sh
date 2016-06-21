#!/bin/bash

#PARAMETROAK:
#$1: lortu nahi genukeena duen fitxategia
#$2: lortu duguna duen fitxategia

#Contar Relevant.
RELEVANT=`cat $1 | wc -l `

# Contar Relevant&Retrieved. Ficheros ordenados alfabeticamente.
#RELRETR=`diff -y --left-column $1 $2 | grep '(' | wc -l`
echo "NIREDIFF"
RELRETR=`../scriptak/nirediff.pl $1 $2 | grep '(' | wc -l`

#Contar Retrieved
RETRIEVED=`cat $2| grep -v "\+" | wc -l`

echo "RELEVANT: $RELEVANT, RELEVRETR: $RELRETR, RETRIEVED: $RETRIEVED"
echo
PRECISION=`perl -e 'print $ARGV[0]/$ARGV[1]' $RELRETR $RETRIEVED`
echo "     PRECISION=$PRECISION"
RECALL=`perl -e 'print $ARGV[0]/$ARGV[1]' $RELRETR $RELEVANT`
echo "     RECALL=$RECALL"
FSCORE=`perl -e 'print 2 * $ARGV[0] * $ARGV[1]/($ARGV[0] + $ARGV[1])' $PRECISION $RECALL`
echo "     FSCORE=$FSCORE"
echo


# irteera konprobatu ahal izateko fitxategi batzuk sortuko ditugu

../scriptak/nirediff.pl $1 $2 | grep '('  >$2_onak
../scriptak/nirediff.pl $1 $2 | grep -v '(' >$2_txarrak
