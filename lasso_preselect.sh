#!/bin/bash
#$ -N lassoclassic
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V
#This script is called by cv_lasso_preselect.sh
fold=$1
nvar=$2
 
Rscript ../lasso_preselect.R $fold $nvar
