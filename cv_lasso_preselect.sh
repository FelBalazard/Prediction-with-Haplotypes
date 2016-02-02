#!/bin/bash
#This script performs cross-validation for lasso with pre-selection. It requires 
#that the QC.sh script has been run (the phasing is not used here) as well as the fold-assoc.sh script.
#In each disease folder there should be allchr(.bed .bim .fam) and $fold.sortedassoc $fold.validID for fold between 1 and 10.

cd T1D
for mal in T1D BD CD CAD HT RA T2D; do
for nvar in 500 1000 1500; do

cd ../$mal
touch methoda.$nvar #This is to store the result.
for fold in `seq 1 10` ; do 

echo "fold $fold"
head $fold.sortedassoc

awk '{ print $2; }' $fold.sortedassoc |head -$nvar > snplist

plink --bfile allchr --extract snplist --out addit$fold.$nvar --recodeA

qsub ../lasso_preselect.sh $fold $nvar
done 
done
done
