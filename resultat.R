#!/usr/bin/Rscript
args<-commandArgs(TRUE)
for (letter in c("b","c","d")){
for (nbloc in 500){
for (window in c(5000,10000,15000,20000,30000)){
for (minleaf in 5){
a<-read.csv(paste(letter,nbloc,window,minleaf,sep="."), sep=" " ,header=F)
ma<-mean(a[(nrow(a)-9):nrow(a),2])
system(paste("echo",args,letter,nbloc,window,minleaf,ma,">> ../resultatfinal"))
}}}}
