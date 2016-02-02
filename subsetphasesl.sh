#!/bin/bash
#$ -N subsetphasesl
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V

#This script subsets the phased data in each disease folder.

./shapeit -convert --input-haps phased.chr$2 --include-ind $1/indQC --include-snp $1/positionchr$2 --output-log subset$1.chr$2.log --output-haps $1/phased.chr$2
