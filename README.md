# Prediction-with-Haplotypes
Haplotype based estimation of gentic risk of complex diseases

This repository contains all the code that was used to obtain the results of the article "Haplotype-based estimation of genetic 
risk of complex diseases". As the data used is medical data, it is not available to the public. It can be accessed after a data 
request to the Wellcome trust Case Control Consortium.
This code is not designed for all systems : it was run on a scientific linux 5 server that uses Sun Grid Engine (SGE) for 
parallelisation. I have no idea of how portable the code. Here are a few requirements : 
moreutils (for sponge), conda, PLINK (as a command line), Shapeit v2 (as an executable in the parent directory).

Folder architecture:
./ : a parent directory containing all scripts as well as the shapeit 2 executable. Also a file rssnps containing the exclusion list provided by the WTCCC.

./BD ./CAD ./CD ./HT ./RA ./T1D ./T2D ./NBS ./58C : 9 folders containing each genetic data in bed bim fam format (plink format) and labelled BD_1.bed for the BD dataset of chromosome 1 and more generally mal_i.bed where mal is the acronym of disease or control dataset and i is the number of the chromosome. Also a file exclu_mal.txt containing the exclusion list for individuals provided by the WTCCC

./genetic_map : containing 22 files titled genetic_map_i_b36.txt where i goes from 1 to 22. Those files are needed for phase imputation and are available here : http://hapmap.ncbi.nlm.nih.gov/downloads/recombination/2008-03_rel22_B36/rates
The parent directory contained also the executable for Shapeit.

R libraries: AUC, RandomForest, glmnet.

The code is divided into 4 parts that should be used chronologically :
*The first one concerns quality control and phase imputation.* The scripts are :
QC.sh which calls 4 other scripts for parallelisation :
allchrsl.sh 
alldissl.sh 
phasesl.sh
subsetphasesl.sh

*The second one defines the fold definition for cross-validation as well as the association analysis for each fold.* Folds are defined once and for all and are used consistently in all settings :
The scripts are 
fold-assoc.sh which calls disco-valid-cv.R


*The third one is the comparison point in the article: lasso regression with pre-selection.* It consists of three scripts :
cv_lasso_preselct.sh which calls 
lasso_preselect.sh (parallelistaion script) which calls lasso_preselect.R

*The fourth one is the main one which documents PH PwoH and PHd, the proposed method and its two variants.*

Occurence of the letter b refers to Pwoh, the letter c to PH and the letter d to PHd.

cv_master_bcd.sh is a simple loop to call cv_bcd.sh with the corresponding values of L_w (window size),maximum number of blocks and fold in the CD folder.

cv_bcd.sh performs the calculations decribed in the article for a given value of L_w and fold. 
It calls disco-valid-hapssl.sh that calls shapeit to divide the phased data into discovery and validation sets.
It calls blockdef.R that defines the central SNPs of the block. This means excluding the lesser associated SNPs that are at less than half-window size from the SNP considered.
It then calls olmastercluster.R that defines the labels to be used for the training set and that calls blocprep.sh. That script uses shapeit to output the phased blocks.

Then the loop over different values of minleaf starts.
For each block, the summary variable for the three methods is then computed using randfor.py outputting a text file $l.disc.$blocn and $l.valid.$blocn
They are put together in $l.disc.1 or $l.valid.1
For the three method, a lasso regression is launched for values 300 500 and 700 of numbloc=N_b by calling lasso-cv.sh that calls lasso-cv.R.
The result is stored in the disease folder in a file named after the values of the parameter $l.$numbloc.$window.$minleaf
End of loop over minleaf

cv_bcd500.5.sh is a variant of cv_bcd.sh where the min_leaf parameter (internal parameter of random forests) has been set to 5 and the N_b (Number of blocks) parameter has been set to 500.
Therefore there is no loop over minleaf. And the lasso-cv.R is replaced by a lasso-cv500.R that does only one regression with numbloc=500 instead of three.

*The last part simply averages the results over the folds and group them in a file.*
The two scripts are resultat.sh and resultat.R

Feel free to contact me if you encounter any problem while trying to use this code. You might be the first one to read this 
readme :
institutionnal adress : felix.balazard[at]inserm.fr
permanent adress :felbalazard[at]hotmail.fr
