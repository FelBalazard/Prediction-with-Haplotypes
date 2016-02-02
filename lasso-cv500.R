 #!/usr/bin/Rscript

args<-commandArgs(TRUE)

fold<-as.numeric(args[1])
letter<-args[2]
window<-args[3]
minsample<-args[4]

#lasso.R by Félix Balazard UPMC/INSERM

#This script performs logistic regression with L1 penalization on the evidence from
#each block. It starts by regrouping the results of disc.bloc* in disc.bloc1 
#(respectively valid).
#It then performs lasso as implemented by glmnet and calculates AUC as implemented 
#by AUC. The resulting R workspace is saved under resultat.Rdata.

#Input : disc.bloc* valid.bloc*
#Output : resultat.Rdata resultat (the AUC in the validation set)
#Packages needed : glmnet and AUC

#bloc.info<-read.csv("bloc.info", sep=" ",header=F)
#blocksize<-read.csv("blocksize",sep=" ",header=F)

disc<-t(read.csv(paste(letter,".disc.bloc1",sep=""),sep=" ",header=F))
1
disc.label<-as.matrix(read.csv("discovery.label",sep=" ",header=F))
2
valid<-t(read.csv(paste(letter,".valid.bloc1",sep=""),sep=" ",header=F))
3
library("glmnet")

#save.image(paste("resultat_",letter,"_",fold,".Rdata",sep=""))

numbloc=500
model<-cv.glmnet(disc[,1:numbloc],disc.label,family="binomial",type.measure="auc")
nzero=model$nzero[which(model$lambda==model$lambda.1se)]
pred<-predict(model,valid[,1:numbloc])
valid.sample<-read.csv("validation.phased.chr1.sample",sep=" ",header=T)
4
valid.sample<-valid.sample[-1,]
library("AUC")
resultat<-auc(roc(pred,valid.sample[,7]))
resultat
system(paste("echo",fold,resultat,nzero,">>",paste(letter,numbloc,window,minsample,sep="."),sep=" "))
#save.image(paste("resultat_",letter,"_",fold,".Rdata",sep=""))
