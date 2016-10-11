#install.packages("xlsx")
#install.packages("XLConnect")
#install.packages("devtools")
#install.packages("readxl")
#devtools::install_github("hadley/readxl")
#install.packages("graphics")
#install.packages("grDevices")
#install.packages("ggplot2")
#install.packages("rCharts")
#install.packages("ggmap")
#install.packages("plotly")
#install.packages("reshape2")
library(plotly)
library(rCharts)
library(grDevices)
library(graphics)
library(readxl)
library(XLConnect)
library(xlsx)
library(shiny)
library(datasets)
library(ggplot2)
library(plyr)
library(ggmap)
library(reshape2)
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

function(input, output) {
  
  datasetInput <- reactive({
    switch(input$dataset,
           "2010" = water_complaints_10,
           "2011" = water_complaints_11,
           "2012" = water_complaints_12,
           "2013" = water_complaints_13,
           "2014" = water_complaints_14,
           "2015" = water_complaints_15,
           "2016" = water_complaints_16)
  })
  areaInput <- reactive({
    switch (input$area,
            "Manhattan" = "Manhattan",
            "Bronx" = "Bronx",
            "Brooklyn" = "Brooklyn",
            "Queens" = "Queens",
            "Staten_island" = "Staten_island")
  })
  
  output$caption <- renderText({
    input$caption
  })
  output$heat_text = renderText({
    paste("Heat Graph of All Complaints")
  })
  
  output$bar_test = renderText({
    paste("Bar Graph of different complaints in different areas")
  })
  
  output$pie_text = renderText({
    paste("Donut Chart of Borough Complaints")
  })
  
  output$pie_text = renderText({
    paste("Pie Chart of Borough Complaints")
  })
  
  output$table_text = renderText({
    paste("Table of Borough in different areas")
  })
  
  output$heatmap  <- renderPlot({
    dataset <- datasetInput()
    names(dataset)<-c("UniqueKey","CreatedDate","ClosedDate","Descriptor",
                      "IncidentZip","AddressType","City","Status","ResolutionActionApdatedDate",
                      "CommunityBoard","Borough","XCoordinate","YCoordinate","Latitude","Longitude","Location")
    borough <- ddply(dataset,.(Borough),"nrow")
    map <- get_map(location = c(lon=-73.95,lat=40.79),zoom=12)
    p <-ggmap(map,extent = "device") + geom_density2d(data = dataset,
          aes( x = Longitude, y = Latitude),size=0.1) + stat_density2d(data = dataset,
          aes(x=Longitude,y=Latitude,fill=..level..,alpha=..level..),size = 0.01,
          bins=16, geom = "polygon") + scale_fill_gradient(low = "green",high = "red") +
          scale_alpha(range=c(0,0.3),guide=FALSE)
    p
  })
  
  #output$summary <- renderPrint({
    #dataset <- datasetInput()
    #summary(dataset)
  #head(datasetInput(), n = input$obs)
  #})
 
  #bar chart about six categories problems in five areas
  output$barcharts <- renderPlot({
    dataset <- datasetInput()
    Manhattan <- filter(dataset,Borough=="MANHATTAN")
    Bronx <- filter(dataset,Borough=="BRONX")
    Brooklyn <- filter(dataset,Borough=="BROOKLYN")
    Queens <- filter(dataset,Borough=="QUEENS")
    Staten_island <- filter(dataset,Borough=="STATEN ISLAND")
    Manhattan_A <- filter(Manhattan,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5" |Descriptor=="QA6" )
    Manhattan_B <- filter(Manhattan,Descriptor=="QB1" | Descriptor=="QBZ")
    Manhattan_D <- filter(Manhattan,Descriptor=="QD1")
    Manhattan_E <- filter(Manhattan,Descriptor=="QE2" | Descriptor=="QEZ")
    Manhattan_G <- filter(Manhattan,Descriptor=="QG2")
    Manhattan_S <- filter(Manhattan,Descriptor=="QSS")
    Manhattan_Z <- filter(Manhattan,Descriptor=="QZZ")
    Bronx_A <- filter(Bronx,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5"|Descriptor=="QA6" )
    Bronx_B <- filter(Bronx,Descriptor=="QB1" | Descriptor=="QBZ")
    Bronx_D <- filter(Bronx,Descriptor=="QD1")
    Bronx_E <- filter(Bronx,Descriptor=="QE2" | Descriptor=="QEZ")
    Bronx_G <- filter(Bronx,Descriptor=="QG2")
    Bronx_S <- filter(Bronx,Descriptor=="QSS")
    Bronx_Z <- filter(Bronx,Descriptor=="QZZ")
    Brooklyn_A <- filter(Brooklyn,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5"|Descriptor=="QA6" )
    Brooklyn_B <- filter(Brooklyn,Descriptor=="QB1" | Descriptor=="QBZ")
    Brooklyn_D <- filter(Brooklyn,Descriptor=="QD1")
    Brooklyn_E <- filter(Brooklyn,Descriptor=="QE2" | Descriptor=="QEZ")
    Brooklyn_G <- filter(Brooklyn,Descriptor=="QG2")
    Brooklyn_S <- filter(Brooklyn,Descriptor=="QSS")
    Brooklyn_Z <- filter(Brooklyn,Descriptor=="QZZ")
    Queens_A <- filter(Queens,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5"|Descriptor=="QA6")
    Queens_B <- filter(Queens,Descriptor=="QB1" | Descriptor=="QBZ")
    Queens_D <- filter(Queens,Descriptor=="QD1")
    Queens_E <- filter(Queens,Descriptor=="QE2" | Descriptor=="QEZ")
    Queens_G <- filter(Queens,Descriptor=="QG2")
    Queens_S <- filter(Queens,Descriptor=="QSS")
    Queens_Z <- filter(Queens,Descriptor=="QZZ")
    Staten_island_A <- filter(Staten_island,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5"|Descriptor=="QA6")
    Staten_island_B <- filter(Staten_island,Descriptor=="QB1" | Descriptor=="QBZ")
    Staten_island_D <- filter(Staten_island,Descriptor=="QD1")
    Staten_island_E <- filter(Staten_island,Descriptor=="QE2" | Descriptor=="QEZ")
    Staten_island_G <- filter(Staten_island,Descriptor=="QG2")
    Staten_island_S <- filter(Staten_island,Descriptor=="QSS")
    Staten_island_Z <- filter(Staten_island,Descriptor=="QZZ")
    specie = c(rep("Manhattan",7),rep("Bronx",7),rep("Brooklyn",7),rep("Queens",7),rep("Staten_island",7))
    condition = rep(c("Taste/Odor","Cloudy or Milky","Oil&Grease","Organisms or other particles","requested information","defective water sampling station","other water problem"),5)
    value <- c(dim(Manhattan_A)[1],dim(Manhattan_B)[1],dim(Manhattan_D)[1],dim(Manhattan_E)[1],
               dim(Manhattan_G)[1],dim(Manhattan_S)[1],dim(Manhattan_Z)[1],
               dim(Bronx_A)[1],dim(Bronx_B)[1],dim(Bronx_D)[1],dim(Bronx_E)[1],
               dim(Bronx_G)[1],dim(Bronx_S)[1],dim(Bronx_Z)[1],
               dim(Brooklyn_A)[1],dim(Brooklyn_B)[1],dim(Brooklyn_D)[1],dim(Brooklyn_E)[1],
               dim(Brooklyn_G)[1],dim(Brooklyn_S)[1],dim(Brooklyn_Z)[1],
               dim(Queens_A)[1],dim(Queens_B)[1],dim(Queens_D)[1],dim(Queens_E)[1],
               dim(Queens_G)[1],dim(Queens_S)[1],dim(Queens_Z)[1],
               dim(Staten_island_A)[1],dim(Staten_island_B)[1],dim(Staten_island_D)[1],dim(Staten_island_E)[1],
               dim(Staten_island_G)[1],dim(Staten_island_S)[1],dim(Staten_island_Z)[1])
    data = data.frame(specie,condition,value)
    p<-ggplot(data,aes(fill=condition,y=value,x=specie))
    p+geom_bar(position = "dodge",stat = "identity")+
      theme(
        #theme_blank(),
        panel.grid.major = element_blank()
        #plot.backgroud = element_rect(fill = "transparent",color = NA)
      )+
      xlab("Borough")+ylab("water complaints")+
      ggtitle("Different types of water complaints in Five New York Borough")
  })
  
  output$view <- renderTable({
    dataset <- datasetInput()
    Manhattan <- filter(dataset,Borough=="MANHATTAN")
    Bronx <- filter(dataset,Borough=="BRONX")
    Brooklyn <- filter(dataset,Borough=="BROOKLYN")
    Queens <- filter(dataset,Borough=="QUEENS")
    Staten_island <- filter(dataset,Borough=="STATEN ISLAND")
    Manhattan_A <- filter(Manhattan,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5" |Descriptor=="QA6" )
    Manhattan_B <- filter(Manhattan,Descriptor=="QB1" | Descriptor=="QBZ")
    Manhattan_D <- filter(Manhattan,Descriptor=="QD1")
    Manhattan_E <- filter(Manhattan,Descriptor=="QE2" | Descriptor=="QEZ")
    Manhattan_G <- filter(Manhattan,Descriptor=="QG2")
    Manhattan_S <- filter(Manhattan,Descriptor=="QSS")
    Manhattan_Z <- filter(Manhattan,Descriptor=="QZZ")
    Bronx_A <- filter(Bronx,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5"|Descriptor=="QA6" )
    Bronx_B <- filter(Bronx,Descriptor=="QB1" | Descriptor=="QBZ")
    Bronx_D <- filter(Bronx,Descriptor=="QD1")
    Bronx_E <- filter(Bronx,Descriptor=="QE2" | Descriptor=="QEZ")
    Bronx_G <- filter(Bronx,Descriptor=="QG2")
    Bronx_S <- filter(Bronx,Descriptor=="QSS")
    Bronx_Z <- filter(Bronx,Descriptor=="QZZ")
    Brooklyn_A <- filter(Brooklyn,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5"|Descriptor=="QA6" )
    Brooklyn_B <- filter(Brooklyn,Descriptor=="QB1" | Descriptor=="QBZ")
    Brooklyn_D <- filter(Brooklyn,Descriptor=="QD1")
    Brooklyn_E <- filter(Brooklyn,Descriptor=="QE2" | Descriptor=="QEZ")
    Brooklyn_G <- filter(Brooklyn,Descriptor=="QG2")
    Brooklyn_S <- filter(Brooklyn,Descriptor=="QSS")
    Brooklyn_Z <- filter(Brooklyn,Descriptor=="QZZ")
    Queens_A <- filter(Queens,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5"|Descriptor=="QA6")
    Queens_B <- filter(Queens,Descriptor=="QB1" | Descriptor=="QBZ")
    Queens_D <- filter(Queens,Descriptor=="QD1")
    Queens_E <- filter(Queens,Descriptor=="QE2" | Descriptor=="QEZ")
    Queens_G <- filter(Queens,Descriptor=="QG2")
    Queens_S <- filter(Queens,Descriptor=="QSS")
    Queens_Z <- filter(Queens,Descriptor=="QZZ")
    Staten_island_A <- filter(Staten_island,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5"|Descriptor=="QA6")
    Staten_island_B <- filter(Staten_island,Descriptor=="QB1" | Descriptor=="QBZ")
    Staten_island_D <- filter(Staten_island,Descriptor=="QD1")
    Staten_island_E <- filter(Staten_island,Descriptor=="QE2" | Descriptor=="QEZ")
    Staten_island_G <- filter(Staten_island,Descriptor=="QG2")
    Staten_island_S <- filter(Staten_island,Descriptor=="QSS")
    Staten_island_Z <- filter(Staten_island,Descriptor=="QZZ")
    value <- c(dim(Manhattan_A)[1],dim(Manhattan_B)[1],dim(Manhattan_D)[1],dim(Manhattan_E)[1],
               dim(Manhattan_G)[1],dim(Manhattan_S)[1],dim(Manhattan_Z)[1],
               dim(Bronx_A)[1],dim(Bronx_B)[1],dim(Bronx_D)[1],dim(Bronx_E)[1],
               dim(Bronx_G)[1],dim(Bronx_S)[1],dim(Bronx_Z)[1],
               dim(Brooklyn_A)[1],dim(Brooklyn_B)[1],dim(Brooklyn_D)[1],dim(Brooklyn_E)[1],
               dim(Brooklyn_G)[1],dim(Brooklyn_S)[1],dim(Brooklyn_Z)[1],
               dim(Queens_A)[1],dim(Queens_B)[1],dim(Queens_D)[1],dim(Queens_E)[1],
               dim(Queens_G)[1],dim(Queens_S)[1],dim(Queens_Z)[1],
               dim(Staten_island_A)[1],dim(Staten_island_B)[1],dim(Staten_island_D)[1],dim(Staten_island_E)[1],
               dim(Staten_island_G)[1],dim(Staten_island_S)[1],dim(Staten_island_Z)[1])
    A<-matrix(value,nrow = 5,ncol = 7,byrow = TRUE)
    rownames(A)<-c("Manhattan","Bronx","Brooklyn","Queens","Staten_island")
    colnames(A)<-c("Taste/Odor","Cloudy or Milky","Oil&Grease","Organisms or other particles",
                   "requested information","defective water sampling station","other water problem")
    A
    
  })
  
  output$piecharts <- renderPlot({
    dataset <- datasetInput()
    area_data <- filter(dataset,Borough==input$area)
    
    data1 <- as.data.frame(table(area_data$Descriptor))
    data1$fraction <- data1$Freq / sum(data1$Freq)
    data1 <- data1[order(data1$fraction),]
    data1$ymax <- cumsum(data1$fraction)
    data1$ymin <- c(0,head(data1$ymax,n=-1))
    
    ggplot(data1,aes(fill=data1$Var1,ymax = ymax, ymin=ymin,xmax=4,xmin=3))+
      geom_rect()+
      coord_polar(theta = "y")+
      xlim(c(0,4)) + 
      theme(panel.grid=element_blank()) +
      theme(axis.text=element_blank())+
      theme(axis.ticks=element_blank())+
      annotate('text',x=0,y=0,label = "Ring Plot!")+
      #labs(title=paste("Distribution of",input$area))
      labs(title=paste("Distribution of",input$area))
  })
  
  output$piechart <- renderPlot({
    dataset <- datasetInput()
    area_data <- filter(dataset,Borough==input$area)
    area_dataset_A <- filter(area_data,Descriptor=="QA1" | Descriptor=="QA2" | Descriptor=="QA3" | Descriptor=="QA4" |Descriptor=="QA5" |Descriptor=="QA6" )
    area_dataset_B <- filter(area_data,Descriptor=="QB1" | Descriptor=="QBZ")
    area_dataset_D <- filter(area_data,Descriptor=="QD1")
    area_dataset_E <- filter(area_data,Descriptor=="QE2" | Descriptor=="QEZ")
    area_dataset_G <- filter(area_data,Descriptor=="QG2")
    area_dataset_S <- filter(area_data,Descriptor=="QSS")
    area_dataset_Z <- filter(area_data,Descriptor=="QZZ")
    df <- data.frame(
      group <- c("Taste/Odor","Cloudy or Milky","Oil&Grease","Organisms or other particles",
                "requested information","defective water sampling station","other water problem"),
      value <- c(dim(area_dataset_A)[1],dim(area_dataset_B)[1],dim(area_dataset_D)[1],dim(area_dataset_E)[1],
                 dim(area_dataset_G)[1],dim(area_dataset_S)[1],dim(area_dataset_Z)[1])
    )
    bp<-ggplot(df,aes(x="",y=value,fill=group))+
      geom_bar(width = 1,stat = "identity")
    pie <- bp+coord_polar("y",start = 0)
    pie
  })
  
  output$totle_com_time <- renderPlot({
    trick_off <- total_com[as.data.frame(rownames(total_com)) %in% input$area_timeline,]
    value_y <- matrix(t(trick_off),ncol = 1)
    value<-data.frame(value_y)
    ggplot(data = data.frame(trick_off),
      aes(x=total_com,y=value,
      group =data.frame(rownames(total_com)),
      color=as.data.frame(rownames(total_com))))+
      geom_line(size=2,alpha=0.75)+
      geom_point(size=3,alpha=0.75)+
      ggtitle(paste("Total complaints in","hh")) +
      labs(x="Time",y="Number of Complaints") +
      theme(plot.title = element_text(family = "Trebuchet MS",colour = "#666666",face = "bold",size = 32,hjust = 0.5))+
      theme(axis.title = element_text(family = "Trebuchet MS",colour = "#666666",face = "bold",size = 22))+
      theme_classic()
  })
  
}
