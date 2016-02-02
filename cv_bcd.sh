#!/bin/bash
window=$1
nbloc=$2
fold=$3
date
echo "fold $fold half window size $window number of blocks $nbloc"

#This part subsets the phased data in discovery and validation sets.
for i in `seq 1 22`; do
qsub ../disco-valid-hapssl.sh $i $fold
done

head $fold.sortedassoc

#This defines the center of the blocks. It takes the list of the most associated snps
#and it excludes the snps that are too close to the most associated snp and then the ones
#too close to the remaining second, etc.
Rscript ../blocdef.R $window $nbloc $fold
echo `wc bloc.info`
head bloc.info

a=`qstat |grep "phasedisc" |wc -l`
while [ "$a" != 0 ]; do
sleep 30
a=`qstat |grep "phasedisc"|wc -l`
echo "phasediscval $a"
done


touch blocksize #This can be used to find out how many snps are in each block.

#This script subsets the discovery and validation phased sets into blocks.

Rscript ../olmastercluster.R $window
a=`qstat |grep "scriptslav" |wc -l`
while [ "$a" != 0 ]; do
sleep 30
a=`qstat |grep "scriptslav"|wc -l`
echo "scriptslave $a"
done

#Unlike in cv_bcd500.5.sh, minleaf is allowed to take different values. This means more calculations.
for minleaf in 1 5 10 15 25 50 100 ; do 
date
echo "minleaf $minleaf"
#This loop trains randomforests on the dicovery blocks (discovery.phased.$blocn) and predicts on the validation blocks
#for the three variants of the method. It outputs a one line file called b(or c or d).disc(or valid).$blocn
for blocn in `seq 1 $nbloc` ; do
qsub ../randfor.sh $blocn $minleaf
done

a=`qstat |grep "randfor" |wc -l`
while [ "$a" != 0 ]; do
sleep 30
a=`qstat |grep "randfor"|wc -l`
echo "randfor $a"
done

sed -i 's/ $/\n/' *.bloc*

#We regroup all the variables in the file of the first block
for l in b c d ; do
for i in `seq 2 $nbloc`; do
cat ${l}.disc.bloc$i >>${l}.disc.bloc1
cat ${l}.valid.bloc$i >>${l}.valid.bloc1
done
sed -i 's/Inf/12/g' ${l}.disc.bloc1
sed -i 's/Inf/12/g' ${l}.valid.bloc1
for numbloc in 300 500 700 ; do
touch $l.$numbloc.$window.$minleaf #This is to store the results
done
qsub ../lasso-cv.sh $fold $l $window $minleaf #This performs lasso regression with $numbloc=300 500 and 700

done

sleep 3m #This is to make sure that the lasso script has loaded the blocks before removing it.
rm -f b.*.bloc* c.*.bloc* d.*.bloc* #It is important to remove the blocks because if randfor.sh fails for some reason
#the old block will not be overwritten.
done
rm blocksize #This can be commented out if you want to access the blocksizes. 
#Another way to have more information on what is happening is to save the R environment of the lasso script
