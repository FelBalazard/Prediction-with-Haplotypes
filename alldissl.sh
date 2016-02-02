#!/bin/bash
#$ -N alldisease
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V

#This script allows for parallel merging of the disease datasets.
i=$1
rm list$i
touch list$i
for mal in 58C BD CAD CD HT RA T1D T2D;do
echo ./$mal/${mal}_$i.bed ./$mal/${mal}_$i.bim ./$mal/${mal}_$i.fam >>list$i
done
plink --bfile NBS_$i --merge-list list$i --make-bed --out all_$i 
