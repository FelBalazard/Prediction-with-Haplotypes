#!/bin/bash

#blocprep.sh

#This script is called by olmastercluster.R and then uses shapeit to output 
#the haplotypes in the block defined by the arguments.

#Input : discovery.phased.chr* validation.phased.chr* .haps and .sample
#Output : discovery.phased.** where ** is the number of the block
#The Shapeit executable has to be in the working directory.

#Parameters : 1 is the number of the chromosome 2 is the number of the block 
# 3 is the beginning  of the block and 4 the end (position in b)

#The following are options for qsub

#$ -N scriptslave
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V
../shapeit -convert \
        --input-haps discovery.phased.chr$1 \
        --output-haps discovery.phased.$2\
        --output-from $3\
        --output-to $4
wc discovery.phased.$2.haps
echo "$2" `wc -l discovery.phased.$2.haps|cut -d " " -f 1`  >>blocksize
wc discovery.phased.$2.sample
../shapeit -convert \
        --input-haps validation.phased.chr$1 \
        --output-haps validation.phased.$2\
        --output-from $3\
        --output-to $4
wc validation.phased.$2.haps
wc validation.phased.$2.sample
rm shapeit*.log
