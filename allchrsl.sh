#!/bin/bash
#$ -N allchr
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V

#This script allows for parallel merging of the disease datasets.
mal=$1
rm  mergelist
touch mergelist
for i in `seq 2 22`; do
echo ${mal}_$i.bed ${mal}_$i.bim ${mal}_$i.fam >>mergelist
done
for i in `seq 1 22`; do 
echo ../58C/58C_$i.bed ../58C/58C_$i.bim ../58C/58C_$i.fam >> mergelist
done
for i in `seq 1 22`; do
echo ../NBS/NBS_$i.bed ../NBS/NBS_$i.bim ../NBS/NBS_$i.fam >> mergelist
done

plink --bfile ${mal}_1 --merge-list mergelist --make-bed --out allchr
