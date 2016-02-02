#!/usr/bin/Rscript
#This script defines the validation set for each fold. It is called by fold-assoc.sh
args<-commandArgs(TRUE)
i<-as.numeric(args[1])
fam<-read.csv("allchr.fam", sep=" ",header=F)
set.seed(8)
mal<- sum(fam[,6]==2)
sain<-sum(fam[,6]==1)
mal.ind<-sample(which(fam[,6]==2),mal)
sain.ind<-sample(which(fam[,6]==1),sain)
if (i==10){
  valid.mal<-fam[mal.ind[((i-1)*floor(mal/10)+1):mal],1:2]
  valid.sain<-fam[sain.ind[((i-1)*floor(sain/10)+1):sain],1:2]
  }else {
  valid.mal<-fam[mal.ind[((i-1)*floor(mal/10)+1):(i*floor(mal/10))],1:2]
  valid.sain<-fam[sain.ind[((i-1)*floor(sain/10)+1):(i*floor(sain/10))],1:2]}

validID<-rbind(valid.mal,valid.sain)
write.table(validID,file=paste(args[1],".validID",sep=""),quote=F,row.names=F, col.names=F)
