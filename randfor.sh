#!/bin/bash
#$ -N randfor
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -V
#This calls the python script and passes it the arguments

python ../randfor.py $1 $2
