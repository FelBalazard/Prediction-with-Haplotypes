#!/usr/bin/Rscript
#This script takes as input the list of the most associated snps and outputs the list of 
#the central snps. It does so by starting with the most associated snp, excluding all snps 
#in the list that are too close to it and then moving to the next snp on the new list.

args<-commandArgs(TRUE)

window=as.numeric(args[1]) #in bp
nbloc<-as.numeric(args[2])
fold<-args[3]
assoc.info<-read.csv(paste(fold,".sortedassoc",sep=""),sep=" ",header=F)
i=1
while (i<nbloc){
  block<-which(assoc.info[,1]==assoc.info[i,1] & assoc.info[,3]>assoc.info[i,3]-window & assoc.info[,3]<assoc.info[i,3]+window)
  block<-block[block[]!=i]
  if(length(block)>0){
  assoc.info<-assoc.info[-block,]}
  i=i+1
}

write.table(assoc.info[1:nbloc,],file="bloc.info",quote=F,row.names=F, col.names=F)
