shinyUI(navbarPage("Exploring NYC's Water", theme = "style.css",
                   
#library(shiny)

tabPanel("General intuition",
         sidebarLayout(position="right",
                       sidebarPanel(
                                   #textInput("caption", "Caption:", "Data Summary"),
                                    selectInput("dataset", "Choose a dataset:", 
                                                 choices = c("2010", "2011", "2012","2013","2014","2015","2016"),selected = "2010"),
      
                                    numericInput("obs", "Number of observations to view:", 10),
      
                                    selectInput("area","Choose an area:", 
                                                 choices = list("Manhattan"="MANHATTAN",
                                                                "Bronx"="BRONX",
                                                                "Brooklyn"="BROOKLYN",
                                                                "Queens"="QUEENS",
                                                                "Staten_island"="STATEN ISLAND"),selected = "MANHATTAN"),
      
                                    selectInput("area_timeline","Select Plots:",
                                                choices = list("Manhattan"="MANHATTAN",
                                                                "Bronx"="BRONX",
                                                                "Brooklyn"="BROOKLYN",
                                                                "Queens"="QUEENS",
                                                                "Staten_island"="STATEN ISLAND"),selected = "MANHATTAN",multiple = TRUE)
                                    ),
    
                                    mainPanel(
                                      tabsetPanel(type="pill",
                                                  tabPanel("Basic Information",br(),tags$div(class="descrip_text",
                                                                                             textOutput("heat_text")),br(),
      
      
                                                            plotOutput("heatmap"),value = 1),
                                                   tabPanel("Basic Information",br(),tags$div(class="descrip_text",
                                                                                              textOutput("bar_text")),br(),
                                                            plotOutput("barcharts"),value = 2)
                                                  ),
                                      tabsetPanel(type="pill",
                                        
                                                  tabPanel("Specific Information",br(),tags$div(class="descrip_text",
                                                                                             textOutput("pies_text")),br(),
                                                           
                                                           
                                                           plotOutput("piecharts"),value = 1),
                                                  tabPanel("Specific Information",br(),tags$div(class="descrip_text",
                                                                                                      textOutput("pie_text")),br(),
                                                           plotOutput("piechart"),value = 2),
                                                           
                                                  tabPanel("Specific Information",br(),tags$div(class="descrip_text",
                                                                                                         textOutput("table_text")),br(),
                                                           tableOutput("view"),value = 3)
                                      )
                                              
                                     #plotOutput("totle_com_time"),
      
                                     #h3(textOutput("caption", container = span)),
      
                                    #verbatimTextOutput("summary"), 
                                   )
                                  )
)))