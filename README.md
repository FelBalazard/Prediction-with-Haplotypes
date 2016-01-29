# Prediction-with-Haplotypes
Haplotype based estimation of gentic risk of complex diseases

This repository contains all the code that was used to obtain the results of the article "Haplotype-based estimation of genetic 
risk of complex diseases". As the data used is medical data, it is not available to the public. It can be accessed after a data 
request to the Wellcome trust Case Control Consortium.
This code is not designed for all systems : it was run on a scientific linux 5 server that uses Sun Grid Engine (SGE) for 
parallelisation. I have no idea of how portable the code. Here are a few requirements : 
moreutils (for sponge), conda, PLINK, Shapeit v2.

Folder architecture : All the code is in the parent directory which contained disease directories. For the WTCCC the seven 
diseases/directories were : BD, CAD, CD, HT, RA, T1D, T2D. The parent directory contained also the executable for Plink, Shapeit.
R libraries: AUC, RandomForest, glmnet.

The code is divided into 4 folders that should be used chronologically :
The first one is QC_phase which documents the quality control filters and phase imputation steps.
The second one is fold_def which documents the fold definition for cross-validation. Folds are defined once and for all and are 
used consistently in all settings.
The third one is lasso which documents the comparison point in the article: lasso regression with pre-selection.
The fourth one is main which documents PH PwoH and PHd, the proposed method and its two variants.

Feel free to contact me if you encounter any problem while trying to use this code. You might be the first one to read this 
readme :
institutionnal adress : felix.balazard[at]inserm.fr
permanent adress :felbalazard[at]hotmail.fr
