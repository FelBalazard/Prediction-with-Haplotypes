#!/bin/bash
#$ -N lasso
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V
Rscript ../lasso-cv500.R $1 $2 $3 $4
