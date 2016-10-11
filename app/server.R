library(shiny)
library(choroplethr)
library(choroplethrZip)
library(dplyr)
library(zipcode)
library(plyr)
library(leaflet)
library(plotly)


energy<-read.csv("C:/Users/YounHyuk/Desktop/ADS/excel files-awareness/cleaned/water_energy_2014_cleaned.csv",header=T)
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

recycle<-read.csv("C:/Users/YounHyuk/Desktop/ADS/excel files-awareness/cleaned/Recycling_diversion_and_capture_rates.csv",header=T)
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


shinyServer(function(input, output) {
  output$distPlot1 <- renderPlot({
    if(input$bor==1) {
      endat<-mydata[which(mydata$Borough=="MANHATTAN"),]
      endat.sel=endat[,c(1,2)]
      if(input$comm>0){
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.comm[[as.numeric(input$comm)]])
      }
      zip_choropleth(endat.sel,
                     title       = "Map of Energy Star Score",
                     legend      = "Average Energy Star Score",
                     county_zoom = 36061)
    }
    else if(input$bor==2) {
      endat<-mydata[which(mydata$Borough=="BRONX               "),]
      endat.sel=endat[,c(1,2)]
      if(input$bxcomm>0){
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.bxcomm[[as.numeric(input$bxcomm)]])
      }
      zip_choropleth(endat.sel,
                     title       = "Energy Rating",
                     legend      = "Average Energy Star Score",
                     county_zoom = 36005)
    }
    else if(input$bor==3) {
      endat<-mydata[which(mydata$Borough=="BROOKLYN            "),]
      endat.sel=endat[,c(1,2)]
      if(input$brcomm>0){
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.brcomm[[as.numeric(input$brcomm)]])
      }
      zip_choropleth(endat.sel,
                     title       = "Energy Rating",
                     legend      = "Average Energy Star Score",
                     county_zoom = 36047)
    }
    else if(input$bor==4) {
      endat<-mydata[which(mydata$Borough=="QUEENS"),]
      endat.sel=endat[,c(1,2)]
      if(input$qucomm>0){
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.qucomm[[as.numeric(input$qucomm)]])
      }
      zip_choropleth(endat.sel,
                     title       = "Energy Rating",
                     legend      = "Average Energy Star Score",
                     county_zoom = 36081)
    }
    else{
      endat<-mydata[which(mydata$Borough=="STATEN ISLAND       "),]
      endat.sel=endat[,c(1,2)]
      if(input$sicomm>0){
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.sicomm[[as.numeric(input$sicomm)]])
      }
      zip_choropleth(endat.sel,
                     title       = "Energy Rating",
                     legend      = "Average Energy Star Score",
                     county_zoom = 36085)
    }
  })
  
  
  output$loc_map1<-renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -73.958, lat = 40.801453, zoom = 10)
    
    
  })
  observe({
    leafletProxy("loc_map1",data=mydata) %>%
      clearShapes()%>%
      addMarkers(lng=mydata$longitude,lat=mydata$latitude,popup=paste("Zipcde:",mydata$region, ",Count:",mydata$count,
                                                                      ",Average Score:",round(mydata$value,2)))
    
  })
  
  output$barPlot<-renderPlot({
    if(input$Type==0) {
    if(input$bor1==1) {
      bardat<-recycle[which(recycle$Zone=="Manhattan"),]
    }
    else if(input$bor1==2) {
      bardat<-recycle[which(recycle$Zone=="Bronx"),]
    }
    else if(input$bor1==3) {
      bardat<-recycle[which(recycle$Zone=="Brooklyn"),]
    }
    else if(input$bor1==4) {
      bardat<-recycle[which(recycle$Zone=="Queens"),]
    }
    else{
      bardat<-recycle[which(recycle$Zone=="Staten Island"),]
    }
    gg<-ggplot(bardat,aes(x=District,y=CaptureRate))+geom_bar(colour="blue",fill="blue",stat="identity")
    print(gg)
    }
    else {
      recycle$CaptureRate<-as.numeric(as.character(recycle$CaptureRate))
      newRecycle<-ddply(recycle,c("Zone"),summarise,mean(CaptureRate))
      colnames(newRecycle)[2]<-"CaptureRate"
      gg<-ggplot(newRecycle,aes(x=Zone,y=CaptureRate))+geom_bar(colour="blue",fill="blue",stat="identity")
      print(gg)
    }
    
    
  })
  
  output$barPlot2 <- renderPlot({
    if(input$Type==0) {
    if(input$bor1==1) {
      endat<-mydata[which(mydata$Borough=="MANHATTAN"),]
      newdata<-vector()
      for (i in 1:12) {
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.comm[[as.numeric(i)]])
        newdata<-rbind(newdata,cbind(mean(endat.sel$value),man.comm[as.numeric(i)+1]))
        final_data<-as.data.frame(newdata)
        final_data[,1]<-as.numeric(as.character(final_data[,1]))
        colnames(final_data)[c(1,2)]<-c("star.bar","district")
        
      }
      gg2<-ggplot(final_data,aes(x=district,y=star.bar))+geom_bar(colour="red",fill="red",stat="identity")
      print(gg2)
    }
    if(input$bor1==2) {
      endat<-mydata[which(mydata$Borough=="BRONX               "),]
      newdata<-vector()
      for (i in 1:12) {
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.bxcomm[[as.numeric(i)]])
        newdata<-rbind(newdata,cbind(mean(endat.sel$value),bx.comm[as.numeric(i)+1]))
        final_data<-as.data.frame(newdata)
        final_data[,1]<-as.numeric(as.character(final_data[,1]))
        colnames(final_data)[c(1,2)]<-c("star.bar","district")
        
      }
      gg2<-ggplot(final_data,aes(x=district,y=star.bar))+geom_bar(colour="red",fill="red",stat="identity")
      print(gg2)
    }
    if(input$bor1==3) {
      endat<-mydata[which(mydata$Borough=="BROOKLYN            "),]
      newdata<-vector()
      for (i in 1:18) {
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.brcomm[[as.numeric(i)]])
        newdata<-rbind(newdata,cbind(mean(endat.sel$value),br.comm[as.numeric(i)+1]))
        final_data<-as.data.frame(newdata)
        final_data[,1]<-as.numeric(as.character(final_data[,1]))
        colnames(final_data)[c(1,2)]<-c("star.bar","district")
        
      }
      gg2<-ggplot(final_data,aes(x=district,y=star.bar))+geom_bar(colour="red",fill="red",stat="identity")
      print(gg2)
    }
    if(input$bor1==4) {
      endat<-mydata[which(mydata$Borough=="QUEENS"),]
      newdata<-vector()
      for (i in 1:14) {
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.qucomm[[as.numeric(i)]])
        newdata<-rbind(newdata,cbind(mean(endat.sel$value),qu.comm[as.numeric(i)+1]))
        final_data<-as.data.frame(newdata)
        final_data[,1]<-as.numeric(as.character(final_data[,1]))
        colnames(final_data)[c(1,2)]<-c("star.bar","district")
        
      }
      gg2<-ggplot(final_data,aes(x=district,y=star.bar))+geom_bar(colour="red",fill="red",stat="identity")
      print(gg2)
    }
    if(input$bor1==5) {
      endat<-mydata[which(mydata$Borough=="STATEN ISLAND       "),]
      newdata<-vector()
      for (i in 1:3) {
        endat.sel=endat[,c(1,2)]%>%
          filter(region %in% zip.sicomm[[as.numeric(i)]])
        newdata<-rbind(newdata,cbind(mean(endat.sel$value),si.comm[as.numeric(i)+1]))
        final_data<-as.data.frame(newdata)
        final_data[,1]<-as.numeric(as.character(final_data[,1]))
        colnames(final_data)[c(1,2)]<-c("star.bar","district")
        
      }
      gg2<-ggplot(final_data,aes(x=district,y=star.bar))+geom_bar(colour="red",fill="red",stat="identity")
      print(gg2)
    }
    }
    else {
      newEScore<-ddply(mydata,c("Borough"),summarise,mean(value))
      colnames(newEScore)[c(1,2)]<-c("district","star.bar")
      gg2<-ggplot(newEScore,aes(x=district,y=star.bar))+geom_bar(colour="red",fill="red",stat="identity")
      print(gg2)
    }
  })
  
  output$barplot_text=renderText({
    paste("Barplot of Recycling Capture Rates")
  })
  
  output$barplot_text2=renderText({
    paste("Barplot of Energy Star Score")
  })
  

})


  
    
  
