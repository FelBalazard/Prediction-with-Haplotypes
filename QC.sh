#!/bin/bash
#Execute this file from the parent directory.

#This first loop exclude the individuals and SNPs excluded in the original paper of the WTCCC1
cd BD
for mal in BD CAD CD HT RA T1D T2D NBS 58C; do
cd ../$mal
for i in `seq 1 22`;do
plink --file ${mal}_$i --remove exclu_${mal}.txt --exclude ../rssnps --out ${mal}_$i --make-bed
done
done

#This part merges all chromosomes in a same file in each disease folder. This is used for
#preselection of SNPs/ central SNPs as well as for the comparison point.

for mal in BD CAD CD HT RA T1D T2D;do
cd ../$mal
qsub allchrsl.sh $mal
done

#This is to let this script wait while the merging takes place. There might be a more elegant way of doing it.
#Please tell me how.
a=`qstat |grep "allchr" |wc -l`
while [ "$a" != 0 ]; do
sleep 1m
a=`qstat |grep "allchr"|wc -l`
echo "allchr $a"
done

#This loop defines more stringent exclusion list for each disease. The exclusions are not implemented 
#right away in order to be able to phase all data together. This additionnal quality control is important to
#obtain reasonable results (and not over optimistic results) as shown in Botta et al. The threshold for HWE 
#were taken from Botta et al.
cd BD
for mal in BD CD CAD HT RA T1D T2D; do 
cd ../$mal
plink --bfile allchr --hwe 0.000001 --geno 0.05 --maf 0.0001 --write-snplist
plink --bfile allchr --keep ${mal}_1.fam --hwe 0.0000000001 --hwe-all --write-snplist --out hwecases
comm -12 <(sort plink.snplist) <(sort hwecases.snplist) >snpQC
done
cd ..

#This part is to merge all datasets together in order to have maximum phasing accuracy
for i in `seq 1 22`; do 
qsub alldissl.sh $i
done

#This is to let this script wait while the merging takes place.
a=`qstat |grep "alldis" |wc -l`
while [ "$a" != 0 ]; do
sleep 1m
a=`qstat |grep "alldis"|wc -l`
echo "alldis $a"
done


#Two snps have same position on chr 15 which prevents shapeit from running
awk -F"\t" '{OFS="\t"; if ($2=="rs4886982") $4=76054782;}1'  all_15.bim|sponge all_15.bim
for mal in BD CD CAD HT RA T1D T2D;do 
awk -F"\t" '{OFS="\t"; if ($2=="rs4886982") $4=76054782;}1'  $mal/allchr.bim|sponge $mal/allchr.bim
done

#This loop launches the lengthy calculations of shapeit. It is important to take advantage of 
#parallel computaion in order to have reasonable computation time (days instead of months).
#The number of threads used is set in phasesl.sh.
for chr in $(seq 1 22); do
qsub phasesl.sh $chr ;
done

#This is to let this script wait while the phasing takes place.
a=`qstat |grep "phasesl" |wc -l`
while [ "$a" != 0 ]; do
sleep 1h
a=`qstat |grep "phasesl"|wc -l`
echo "phasesl $a"
done

#This loop subsets the phased data into each disease folder.
for mal in BD CD CAD HT RA T1D T2D; do
cut -d " "  -f 2 $mal/allchr.fam > $mal/indQC
for i in `seq 1 22`;do
join -1 1 -2 2 $mal/snpQC <(sort -k 2 $mal/${mal}_$i.map) |cut -d " " -f 4 |sort > $mal/positionchr$i
qsub subsetphasesl.sh $mal $i
done 
done

#This loop deletes the now useless ped map file. Make sure you have a copy somewhere before
#uncommenting it.
#cd BD
#for mal in BD CD CAD HT RA T1D T2D;do
#cd ../$mal
#rm ${mal}*.ped ${mal}*.map
#done
