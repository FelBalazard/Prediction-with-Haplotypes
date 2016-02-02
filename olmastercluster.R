#!/usr/bin/Rscript
args<-commandArgs(TRUE)

#olmastercluster.R (ol stands for overlap as blocks can share some SNPs)

#This script allows to prepare the dataset for each block prior to running randomForests 
#on it. It also handles the labels so that each haplotype is considered independently. It calls 
#blocprep.sh.

#Input : discovery.phased.chr$chr .haps and .sample bloc.info 
#Output : discovery.double.label where the labels are duplicated (used in ranFor.py)
#discovery.label where the labels are simply extracted.
#discovery.phased.$blocn and validation.phased.$blocn

window<-as.numeric(args[1])

disc.sample<-read.csv("discovery.phased.chr1.sample",sep=" ")
disc.sample<-disc.sample[-1,]
double.label<-as.integer(disc.sample[floor(seq(1,nrow(disc.sample)+0.5,0.5)),7])
write.table(double.label, file = "discovery.double.label",row.names=FALSE,col.names=FALSE)
label<-as.integer(disc.sample[,7])
write.table(label, file = "discovery.label",row.names=FALSE,col.names=FALSE)
bloc.info<-read.csv("bloc.info", sep=" ",header=F)
for (i in 1:nrow(bloc.info)){
  chr<-bloc.info[i,1]
  head<-bloc.info[i,3] -window
  tail<-bloc.info[i,3] +window
  command<-paste("qsub ../blocprep.sh",chr,i,head,tail)
  system(command)
}
