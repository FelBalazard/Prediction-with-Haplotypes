#!/bin/bash
#$ -N phasediscval
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V
#This script divides the phased data in validation and dicovery sets.
#It slows things down but makes for clearer separation between discovery and validation sets.

../shapeit -convert --input-haps phased.chr$1 --exclude-ind $2.validID2 --output-haps discovery.phased.chr$1

../shapeit -convert --input-haps phased.chr$1 --include-ind $2.validID2 --output-haps validation.phased.chr$1
