library(shiny)
library(choroplethr)
library(choroplethrZip)
library(dplyr)
library(zipcode)
library(plyr)
library(leaflet)
library(plotly)
library(rCharts)
library(grDevices)
library(graphics)
library(readxl)
library(XLConnect)
library(xlsx)
library(datasets)
library(ggplot2)
library(ggmap)
library(reshape2)

######################YOUNHYUK CHO#####################
data(zipcode)
energy<-read.csv("water_energy_2014_cleaned.csv",header=T)
mydata<-merge(energy,zipcode,by.x="Zip.Code",by.y="zip")
mydata$Zip.Code<-as.character(mydata$Zip.Code)
mydata<-mydata[,c(1,4,6,10,11,12,13,2,3)]
mydata.sum<-ddply(mydata,c("Zip.Code"),summarize,mean(ENERGY.STAR.Score))

unique_zipcodes<-unique(mydata[,1])
count<-rep(0,length(unique_zipcodes))

for (i in 1:length(unique_zipcodes)) {
  count[i]<-length(which(mydata$Zip.Code==unique_zipcodes[i]))
}

mydata.un<-mydata[!duplicated(mydata[c("Zip.Code")]),]
mydata.final<-merge(mydata.sum,mydata.un,by.x='Zip.Code',by.y='Zip.Code')

mydata<-mydata.final[,-4]
mydata<-cbind(mydata,count)

colnames(mydata)[c(1,2)]<-c("region","value")

recycle<-read.csv("Recycling_diversion_and_capture_rates.csv",header=T)
recycle<-recycle[,c(2,3,7)]
colnames(recycle)[3]<-"CaptureRate"
recycle<-as.matrix(recycle)

for (i in 1:nrow(recycle)) {
  if (grepl("Brooklyn",recycle[i,1])==TRUE) {
    recycle[i,1]<-"Brooklyn"
  }
}

for (i in 1:nrow(recycle)) {
  if (grepl("Queens",recycle[i,1])==TRUE) {
    recycle[i,1]<-"Queens"
  }
}

recycle<-as.data.frame(recycle)

nyc.bor<-c("Manhattan","Bronx","Queens","Brookyln","Staten Island")
##manhattan
man.comm<-c("all neighborhoods","MN01","MN02","MN03","MN04","MN05","MN06","MN07","MN08","MN09",
            "MN10","MN11","MN12")

zip.comm<-as.list(1:length(man.comm))

zip.comm[[1]]=as.character(c(10002, 10004, 10005, 10006, 10007, 10013, 10038, 10048, 10280, 10281, 10282))
zip.comm[[2]]=as.character(c(10002, 10003, 10011, 10012, 10013,10014))
zip.comm[[3]]=as.character(c(10002, 10003, 10007, 10009, 10012, 10013,10038))
zip.comm[[4]]=as.character(c(10001, 10010, 10011, 10014, 10018, 10019, 10023,10036))
zip.comm[[5]]=as.character(c(10001, 10003, 10010, 10011, 10016, 10017, 10018, 10019, 10020, 10022, 10023, 10036,10111))
zip.comm[[6]]=as.character(c(10002, 10003, 10009, 10010, 10016, 10017, 10018, 10022,10065))
zip.comm[[7]]=as.character(c(00083, 10019, 10023, 10024, 10025, 10026,10069))
zip.comm[[8]]=as.character(c(	00083, 10021, 10022, 10028, 10029, 10044, 10065, 10075,10128))
zip.comm[[9]]=as.character(c(10024, 10025, 10026, 10027, 10030, 10031, 10032, 10039,10115))
zip.comm[[10]]=as.character(c(00083, 10025, 10026, 10027, 10029, 10030, 10031, 10032, 10035, 10037,10039))           
zip.comm[[11]]=as.character(c(00083, 10026, 10027, 10029, 10035, 10037,10128))
zip.comm[[12]]=as.character(c(10031, 10032, 10033, 10034, 10039,10040))

##Bronx
bx.comm<-c("all neighborhoods","BX01","BX02","BX03","BX04","BX05","BX06","BX07","BX08","BX09",
           "BX10","BX11","BX12")
zip.bxcomm<-as.list(1:length(bx.comm))

zip.bxcomm[[1]]=as.character(c(10451, 10454, 10455, 10456, 10459))
zip.bxcomm[[2]]=as.character(c(10454, 10455, 10459, 10474))
zip.bxcomm[[3]]=as.character(c(10451, 10456, 10457, 10459, 10460))
zip.bxcomm[[4]]=as.character(c(10451, 10452, 10453, 10456, 10457))
zip.bxcomm[[5]]=as.character(c(10452, 10453, 10457, 10458, 10468))
zip.bxcomm[[6]]=as.character(c(10457, 10458, 10460, 10462, 10472))
zip.bxcomm[[7]]=as.character(c(10453, 10458, 10463, 10467, 10468, 10471))
zip.bxcomm[[8]]=as.character(c(10463, 10467, 10468, 10471))
zip.bxcomm[[9]]=as.character(c(10459, 10460, 10461, 10462, 10472, 10473))
zip.bxcomm[[10]]=as.character(c(10461, 10462, 10464, 10465, 10469, 10475))           
zip.bxcomm[[11]]=as.character(c(10460, 10461, 10462, 10467, 10469, 10475))
zip.bxcomm[[12]]=as.character(c(10464, 10466, 10467, 10469, 10470, 10471, 10475))

##Brookyln
br.comm<-c("all neighborhoods","BR01","BR02","BR03","BR04","BR05","BR06","BR07","BR08","BR09",
           "BR10","BR11","BR12","BR13","BR14","BR15","BR16","BR17","BR18")
zip.brcomm<-as.list(1:length(br.comm))

zip.brcomm[[1]]=as.character(c(11205, 11206, 11211, 11222, 11237, 11251, 11378, 11385))
zip.brcomm[[2]]=as.character(c(11201, 11205, 11211, 11217, 11238, 11251))
zip.brcomm[[3]]=as.character(c(11205, 11206, 11213, 11216, 11221, 11233, 11238))
zip.brcomm[[4]]=as.character(c(11206, 11207, 11221, 11233, 11237, 11385))
zip.brcomm[[5]]=as.character(c(	11207, 11208, 11233, 11236, 11239, 11385, 11414, 11416, 11421))
zip.brcomm[[6]]=as.character(c(11201, 11215, 11217, 11231, 11238))
zip.brcomm[[7]]=as.character(c(11215, 11218, 11219, 11220, 11232))
zip.brcomm[[8]]=as.character(c(11212, 11213, 11216, 11217, 11225, 11233, 11238))
zip.brcomm[[9]]=as.character(c(11203, 11213, 11215, 11216, 11225, 11226, 11238))
zip.brcomm[[10]]=as.character(c(11209, 11219, 11220, 11228))           
zip.brcomm[[11]]=as.character(c(11204, 11209, 11214, 11219, 11223, 11228, 11230))
zip.brcomm[[12]]=as.character(c(11204, 11218, 11219, 11220, 11223, 11230, 11232))
zip.brcomm[[13]]=as.character(c(11214, 11223, 11224, 11235))           
zip.brcomm[[14]]=as.character(c(11210, 11215, 11218, 11223, 11225, 11226, 11229, 11230))
zip.brcomm[[15]]=as.character(c(11210, 11223, 11229, 11234, 11235))
zip.brcomm[[16]]=as.character(c(11207, 11212, 11221, 11233, 11236))           
zip.brcomm[[17]]=as.character(c(11203, 11210, 11212, 11213, 11226, 11233, 11234, 11236))
zip.brcomm[[18]]=as.character(c(11203, 11207, 11210, 11212, 11229, 11234, 11235, 11236, 11239))

##Queens
qu.comm<-c("all neighborhoods","QU01","QU02","QU03","QU04","QU05","QU06","QU07","QU08","QU09",
           "QU10","QU11","QU12","QU13","QU14")
zip.qucomm<-as.list(1:length(qu.comm))

zip.qucomm[[1]]=as.character(c(11101, 11102, 11103, 11104, 11105, 11106, 11369, 11370, 11371, 11377))
zip.qucomm[[2]]=as.character(c(11101, 11104, 11109, 11372, 11373, 11377, 11378))
zip.qucomm[[3]]=as.character(c(11368, 11369, 11370, 11371, 11372, 11373, 11377))
zip.qucomm[[4]]=as.character(c(11368, 11372, 11373, 11374, 11375, 11377))
zip.qucomm[[5]]=as.character(c(11207, 11208, 11237, 11373, 11374, 11377, 11378, 11379, 11385))
zip.qucomm[[6]]=as.character(c(11367, 11368, 11373, 11374, 11375, 11379, 11385, 11415))
zip.qucomm[[7]]=as.character(c(11354, 11355, 11356, 11357, 11358, 11359, 11360, 11365, 11367, 11368))
zip.qucomm[[8]]=as.character(c(11355, 11364, 11365, 11366, 11367, 11368, 11415, 11423, 11427, 11432, 11435))
zip.qucomm[[9]]=as.character(c(11208, 11367, 11375, 11385, 11415, 11416, 11417, 11418, 11419, 11421, 11435))
zip.qucomm[[10]]=as.character(c(11208, 11239, 11414, 11416, 11417, 11419, 11420, 11430, 11435, 11436))           
zip.qucomm[[11]]=as.character(c(11005, 11357, 11358, 11360, 11361, 11362, 11363, 11364, 11365, 11426, 11427))
zip.qucomm[[12]]=as.character(c(11411, 11412, 11413, 11418, 11423, 11427, 11429, 11430, 11432, 11433, 11434, 11435, 11436, 11451))
zip.qucomm[[13]]=as.character(c(11001, 11004, 11005, 11040, 11364, 11411, 11413, 11422, 11423, 11426, 11427, 11428, 11429, 11430, 11434))           
zip.qucomm[[14]]=as.character(c(	11096, 11691, 11692, 11693, 11694, 11697))

##Queens
si.comm<-c("all neighborhoods","SI01","SI02","SI03")
zip.sicomm<-as.list(1:length(si.comm))

zip.sicomm[[1]]=as.character(c(10301, 10302, 10303, 10304, 10305, 10310, 10314))
zip.sicomm[[2]]=as.character(c(10301, 10303, 10304, 10305, 10306, 10308, 10312, 10314))
zip.sicomm[[3]]=as.character(c(10306, 10307, 10308, 10309, 10312, 10314))

#########################YOUNHYUK CHO######################################


#########################Jiani Tian########################################
water_complaints_10 <- read_excel("2010.xlsx")
water_complaints_11 <- read_excel("2011.xlsx")
water_complaints_12 <- read_excel("2012.xlsx")
water_complaints_13 <- read_excel("2013.xlsx")
water_complaints_14 <- read_excel("2014.xlsx")
water_complaints_15 <- read_excel("2015.xlsx")
water_complaints_16 <- read_excel("2016.xlsx")
tb_10 <- table(water_complaints_10$Borough)
tb_11 <- table(water_complaints_11$Borough)
tb_12 <- table(water_complaints_12$Borough)
tb_13 <- table(water_complaints_13$Borough)
tb_14 <- table(water_complaints_14$Borough)
tb_15 <- table(water_complaints_15$Borough)
tb_16 <- table(water_complaints_16$Borough)
df_10 <- as.data.frame(tb_10)
df_11 <- as.data.frame(tb_11)
df_12 <- as.data.frame(tb_12)
df_13 <- as.data.frame(tb_13)
df_14 <- as.data.frame(tb_14)
df_15 <- as.data.frame(tb_15)
df_16 <- as.data.frame(tb_16)
total_com<-cbind(df_10$Freq,df_11$Freq,df_12$Freq,df_13$Freq,df_14$Freq,df_15$Freq,df_16$Freq)
rownames(total_com)<-c("Manhattan","Bronx","Brooklyn","Queens","Staten_island")
colnames(total_com)<-c("2010","2011","2012","2013","2014","2015","2016")
#mdf <- melt(data.frame(total_com),id.vars = rownames(total_com),value.name = "value",variable.name = "Year")
###################################Jiani Tian################################################
