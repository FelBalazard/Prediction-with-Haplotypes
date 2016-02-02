#!/usr/bin/Rscript
#This script performs lasso regression on the addit$fold.$nvar.raw file
args<-commandArgs(TRUE)
dataset<-read.csv(paste("addit",args[1],".",args[2],".raw",sep=""),sep=" ",header=T)
validID<-read.table(paste(args[1],".validID",sep=""),header=F)
valid<-which(dataset[,1] %in% validID[,1])
discovery<-dataset[-valid,]
validation<-dataset[valid,]
library(randomForest)#Only to use na.roughfix
library(glmnet)
discovery<-na.roughfix(discovery)
modelglm<- cv.glmnet(as.matrix(discovery[,7:ncol(discovery)]),factor(discovery[,6]),family="binomial",type.measure="auc")

validation<-na.roughfix(validation)

#save.image(paste("lasso_",args[1],".Rdata",sep=""))

predglm<-predict(modelglm,as.matrix(validation[,7:ncol(discovery)]))


library("AUC")
resultatglm<-auc(roc(predglm,factor(validation[,6])))
system(paste("echo ",args[1]," ",resultatglm," >>methoda",args[2],sep=""))
