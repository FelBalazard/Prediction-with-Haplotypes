#!/bin/bash
#This script loops over the window size parameter and the folds.
#It can be rather long so one should call it using nohup ./cv_master_bcd500.5.sh & in the parent directory.
cd BD
for mal in  BD CAD HT RA T1D T2D ; do
cd ../$mal
for window in 5000 10000 15000 20000 30000 ; do
for i in `seq 1 10` ; do 
../cv_bcd500.5.sh $window 500 $i
done
done
done
