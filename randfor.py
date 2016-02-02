#!/usr/bin/env python
#This script performs randomforests on the blocks for the three variation of the method.
import sys
blocn=sys.argv[1]
min_samples_leaf=int(sys.argv[2])

import math
#The function evi for evidence is meant to make the result homogeneous to 
#logistic regression. The if loop avoids having any infinity in the output as
#evidence is not defined for 0 or 1.
def evi(x):
 if x<0.001:
  return -7
 elif x>0.999:
  return 7
 else:
  return math.log(x/(1-x))

import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

dischaps=pd.read_csv("discovery.phased."+str(blocn)+".haps",sep=" ",header=None)
validhaps=pd.read_csv("validation.phased."+str(blocn)+".haps",sep=" ",header=None)
dischaps=dischaps.ix[:,5:]
validhaps=validhaps.ix[:,5:]
dischaps=dischaps.T
validhaps=validhaps.T
dischaps=np.array(dischaps)
validhaps=np.array(validhaps)

label=pd.read_csv("discovery.double.label",header=None)
label=np.array(label)

#c refers to PH. Each haplotype is treated as an observation and then the evidence is combined
#to create a new variable.
rfc = RandomForestClassifier(n_estimators=500, max_features="auto",min_samples_leaf=min_samples_leaf,oob_score=True)
rfc.fit(dischaps,np.ravel(label))
predc=rfc.oob_decision_function_
predc=predc[:,1]
predc=map(evi,predc)
predc=np.array([predc[i] for i in range(0,len(predc),2)]) +np.array([predc[i] for i  in range(1,len(predc),2)])
predc=pd.DataFrame(predc)
predc.to_csv("c.disc.bloc"+str(blocn),na_rep='NA',sep=" ",line_terminator=" ",header=False,index=False)

validc=rfc.predict_proba(validhaps)
validc=validc[:,1]
validc=map(evi,validc)
validc=np.array([validc[i] for i in range(0,len(validc),2)])+np.array([validc[i] for i in range(1,len(validc),2)])
validc=pd.DataFrame(validc)
validc.to_csv("c.valid.bloc"+str(blocn),na_rep='NA',sep=" ",line_terminator=" ",header=False,index=False)

#To see the interest of using haplotypes, we take this information out and see what happens.
disc=np.array([dischaps[i,:] for i in range(0,len(dischaps),2)])+np.array([dischaps[i,:] for i in range(1,len(dischaps),2)])
valid=np.array([validhaps[i,:] for i in range(0,len(validhaps),2)])+np.array([validhaps[i,:] for i in range(1,len(validhaps),2)])
labelsimple=[label[i] for i in range(0,len(label),2)]

#b refers to PwoH
rfc = RandomForestClassifier(n_estimators=500, max_features="auto", min_samples_leaf=min_samples_leaf,oob_score=True)
rfc.fit(disc,np.ravel(labelsimple))
predb=rfc.oob_decision_function_
predb=predb[:,1]
predb=map(evi,predb)
predb=pd.DataFrame(predb)
predb.to_csv("b.disc.bloc"+str(blocn),na_rep='NA',sep=" ",line_terminator=" ",header=False,index=False)

validb=rfc.predict_proba(valid)
validb=validb[:,1]
validb=map(evi,validb)
validb=pd.DataFrame(validb)
validb.to_csv("b.valid.bloc"+str(blocn),na_rep='NA',sep=" ",line_terminator=" ",header=False,index=False)

#This is to try and capture dominace effect. We concatenate the two haplotypes twice (in the two possible orders)
#and we take the mean of the prediction. d refers to PHd
swch=[1,-1]*len(disc)
swch=np.array(range(len(dischaps)))+swch
discd=np.concatenate((dischaps,dischaps[swch,:]),axis=1)
swch=[1,-1]*len(valid)
swch=np.array(range(len(validhaps)))+swch
validd=np.concatenate((validhaps,validhaps[swch,:]),axis=1)

rfc = RandomForestClassifier(n_estimators=500, max_features="auto", min_samples_leaf=min_samples_leaf,oob_score=True)
rfc.fit(dischaps,np.ravel(label))
predd=rfc.oob_decision_function_
predd=predd[:,1]
predd=map(evi,predd)
predd=np.array([predd[i] for i in range(0,len(predd),2)]) +np.array([predd[i] for i  in range(1,len(predd),2)])
predd=pd.DataFrame(predd)
predd.to_csv("d.disc.bloc"+str(blocn),na_rep='NA',sep=" ",line_terminator=" ",header=False,index=False)

validd=rfc.predict_proba(validhaps)
validd=validd[:,1]
validd=map(evi,validd)
validd=np.array([validd[i] for i in range(0,len(validd),2)])+np.array([validd[i] for i in range(1,len(validd),2)])
validd=pd.DataFrame(validd)
validd.to_csv("d.valid.bloc"+str(blocn),na_rep='NA',sep=" ",line_terminator=" ",header=False,index=False)
