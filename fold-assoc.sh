#!/bin/bash
#This script defines the folds and computes the associations used for pre-selection
#on each fold's training set. It should be executed in the parent directory.
#It requires data to be as left by QC.sh : allchr(.bed .bim .fam) and snpQC in the disease directory.
cd BD
for mal in BD CD CAD HT RA T1D T2D; do
cd ../$mal
for fold in `seq 1 10`; do 
Rscript ../disco-valid-cv.R $fold #This defines the folds

cut -d " " -f 2 $fold.validID > $fold.validID2 #This is for use with shapeit

plink --bfile allchr --extract snpQC --remove $fold.validID --assoc --out $fold #This computes the association

#The next two lines sort the associations according to p-value and formats the data appropriately.
sed -e '1d;s/NA/2/g' $fold.assoc |sort -g -k 9|head -20000 >$fold.sortedassoc 
sed -i 's/ * / /g;s/^ //;s/ $//' $fold.sortedassoc
head $fold.sortedassoc
done
done
