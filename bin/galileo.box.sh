#!/bin/bash

GALILEOHOME=/home/rodrigo/galileo2018
PYTHON=/usr/local/anaconda2/bin/python
VMD=/usr/local/bin/vmd
VINA=/usr/bin/vina
AUTODOCK4=/usr/bin/autodock4
AUTOGRID4=/usr/bin/autogrid4
BC=/usr/bin/bc

#---------------------------------------
#  Parsing arguments
#---------------------------------------

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -r|--receptor)
    INPUT="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--center)
    x="$2"
    y="$3"
    z="$4"
    shift 
    shift 
    shift
    shift
    ;;
    -s|--size)
    dx="$2"
    dy="$3"
    dz="$4"
    shift 
    shift 
    shift
    shift
    ;;
esac
done


#---------------------------------------
#    Creating .PDB and .VMD
#---------------------------------------
PREFIX=_TEMP_

cat $INPUT > $PREFIX.pdb
$PYTHON $GALILEOHOME/bin/galileo.box.py $x $y $z $dx $dy $dz >> $PREFIX.pdb

VMDTEMPLATE=$GALILEOHOME/bin/galileo.box.vmd
sed -e "s/TEMPLATE/$PREFIX/g" $VMDTEMPLATE > $PREFIX.vmd


#---------------------------------------
#    Run VMD
#---------------------------------------
$VMD -e $PREFIX.vmd

#---------------------------------------
#    Show information and close
#---------------------------------------
/bin/rm $PREFIX.vmd
/bin/rm $PREFIX.pdb

echo "Galileo: You have visualized a box with the following properties:"
echo "CENTER  $x $y $z"
echo "SIZE    $dx $dy $dz"

