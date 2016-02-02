#!/bin/bash
#This script allows to get the results of PH PwoH and PHd.
touch resultatfinal
cd BD
for mal in BD CAD HT RA T1D T2D ; do 
cd ../$mal
Rscript ../resultat.R $mal
done
