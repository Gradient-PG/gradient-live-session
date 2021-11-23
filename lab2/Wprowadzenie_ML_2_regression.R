#install.packages("ggplot2")
#install.packages("plyr")
#install.packages("Hmisc")
library(ggplot2)
library(plyr)
library(Hmisc)


extract<-read.csv("C:/Users/dawid/OneDrive/Pulpit/Dawid/Gradient/Github/gradient-live-session/lab2/extract.csv")

to_corr<-na.omit(data.frame(extract$class,extract$age,extract$education,extract$income,extract$height))
rcorr(as.matrix(to_corr))
count(extract,"sex")
count(extract,"education")
extract$woje<-as.factor(extract$woje)
extract$class<-as.factor(extract$class)
extract$education<-as.factor(extract$education)
extract$class = revalue(extract$class, c('1'= ' city more than 500 thou.','2'=' city 200-500 thou.','3'=' city 100-200 thou.','4'=' city 20-100 thou.','5'=' city less than 20 thou.','6'=' village'))
extract$education = revalue(extract$education, c('70'=" without",'60'=' primary','50' = ' basic vocational', '51'=' middle school','40'=' secondary','30'=' vocational','20'=' postsecondary','12'=' bachelor','11'=' master','10'=' doctor'))
########################
extract$sex<-(extract$sex==1)*1
extract$weight_m<-extract$sex*extract$weight
extract$weight_f<-extract$weight-extract$weight_m
extract$height_m<-extract$sex*extract$height
extract$height_f<-extract$height-extract$height_m
#############################

extract$height_ms<-(extract$height-mean(extract$height[extract$sex==1]))*(extract$sex)
extract$weight_ms<-(extract$weight-mean(extract$weight[extract$sex==1]))*(extract$sex)
extract$height_fs<-(extract$height-mean(extract$height[extract$sex==0]))*(extract$sex==0)
extract$weight_fs<-(extract$weight-mean(extract$weight[extract$sex==0]))*(extract$sex==0)


############ model for age ####################

tmp<-summary(
  lm(income~sex+as.factor(age)+class+height_ms+height_fs + education, data=extract, weights=waga) 
)
lata <- c(17:96,98,99,100,103)
lata_income<-data.frame(lata,tmp$coefficients[3:86,1])
ggplot(lata_income, aes(x=lata,y=tmp$coefficients[3:86,1])) + 
  geom_point() + geom_smooth()+ labs(x = "Age", y = "Beta coefficient")

###### age transformation ######
extract$ageabove16upto40<-(extract$age<=40)*(extract$age-16)
extract$ageabove16upto40cap<-(extract$age<=40)*(extract$age-16)+(extract$age>40)*(40-16)
extract$age40flag<-(extract$age>40)&(extract$age<=60)
extract$ageafter40<-extract$age40flag*(extract$age-40)
extract$age60plusflag<-(extract$age>60)
extract$ageafter60<-(extract$age60plusflag)*(extract$age-60)

########### creating model ##########
#Step 1
summary(
  lm(income~sex, data=extract, weights=waga) 
)
#Step 2
summary(
  lm(income~sex+ageabove16upto40+age40flag+ageafter40+age60plusflag+
       +height_ms+height_fs, data=extract, weights=waga) 
)
#Step 3
summary(
  lm(income~sex+ageabove16upto40+age40flag+ageafter40+age60plusflag+height_ms+ height_fs+relevel(education, ref = " without")
       + relevel(class, ref = " village"), data=extract, weights=waga)
)

