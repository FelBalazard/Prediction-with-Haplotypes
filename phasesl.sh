#!/bin/bash
#$ -N phaseslave
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V

#This script allows for parallel computation of the phasing.
#The recommended value for thread is the number of cores per node.

./shapeit --input-bed all_$1.bed all_$1.bim all_$1.fam\
        --input-map genetic_map/genetic_map_chr${1}_b36.txt \
        --output-max phased.chr$1 \
        --thread 8
