#!/bin/bash
#This script loops over the window size parameter and the folds.
#It can be rather long so one should call it using nohup ./cv_master_bcd.sh & in the parent directory.
cd CD
for window in 5000 10000 15000 20000 30000 40000 50000 750000; do
for i in `seq 1 10` ; do 
../cv_bcdsh $window 700 $i
done
done
done
