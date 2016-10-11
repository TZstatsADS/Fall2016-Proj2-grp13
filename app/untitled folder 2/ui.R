#library(shiny)
#library(rCharts)
#library(plotly)

shinyUI(navbarPage("Environment in NYC",theme="style.css",
                   tabPanel("Awareness",
                            sidebarLayout(
                              sidebarPanel(
                                conditionalPanel("input.condPanel==1",
                                                 helpText("Interactive map of the location by zipcode. Click to view zipcode and number of buildings belong to that zipcode along with its average Energy Star Score")),
                                
                                conditionalPanel("input.condPanel==2",
                                                 radioButtons("bor",label=h3("Choose Borough"),
                                             choices=c("Manhattan"=1,"Bronx"=2,"Brooklyn"=3,
                                                       "Queens"=4,"Staten Island"=5),
                                             selected=1),
                                
                                conditionalPanel("input.bor==1",
                                  selectInput("comm", "Choose a Manhattan District", 
                                              choices = c("All Districts"=0,
                                                          "MN01"=1, 
                                                          "MN02"=2,
                                                          "MN03"=3, 
                                                          "MN04"=4,
                                                          "MN05"=5, 
                                                          "MN06"=6,
                                                          "MN07"=7, 
                                                          "MN08"=8, 
                                                          "MN00"=9,
                                                          "MN10"=10,
                                                          "MN11"=11,
                                                          "MN12"=12), 
                                              selected = 0)),
                                conditionalPanel("input.bor==2",
                                  selectInput("bxcomm", "Choose a Bronx District", 
                                              choices = c("All Districts"=0,
                                                          "BX01"=1, 
                                                          "BX02"=2,
                                                          "BX03"=3, 
                                                          "BX04"=4,
                                                          "BX05"=5, 
                                                          "BX06"=6,
                                                          "BX07"=7, 
                                                          "BX08"=8, 
                                                          "BX00"=9,
                                                          "BX10"=10,
                                                          "BX11"=11,
                                                          "BX12"=12), 
                                              selected = 0)),
                                conditionalPanel("input.bor==3",
                                  selectInput("brcomm", "Choose a Brooklyn District", 
                                              choices = c("All Districts"=0,
                                                          "BR01"=1, 
                                                          "BR02"=2,
                                                          "BR03"=3, 
                                                          "BR04"=4,
                                                          "BR05"=5, 
                                                          "BR06"=6,
                                                          "BR07"=7, 
                                                          "BR08"=8, 
                                                          "BR09"=9,
                                                          "BR10"=10,
                                                          "BR11"=11,
                                                          "BR12"=12,
                                                          "BR13"=13,
                                                          "BR14"=14,
                                                          "BR15"=15,
                                                          "BR16"=16,
                                                          "BR17"=17,
                                                          "BR18"=18), 
                                              selected = 0)),
                                conditionalPanel("input.bor==4",
                                  selectInput("qucomm", "Choose a Queens District", 
                                              choices = c("All Districts"=0,
                                                          "QU01"=1, 
                                                          "QU02"=2,
                                                          "QU03"=3, 
                                                          "QU04"=4,
                                                          "QU05"=5, 
                                                          "QU06"=6,
                                                          "QU07"=7, 
                                                          "QU08"=8, 
                                                          "QU09"=9,
                                                          "QU10"=10,
                                                          "QU11"=11,
                                                          "QU12"=12,
                                                          "QU13"=13,
                                                          "QU14"=14), 
                                              selected = 0)),
                                conditionalPanel("input.bor==5",
                                  selectInput("sicomm", "Choose a Stanten Island District", 
                                              choices = c("All Districts"=0,
                                                          "SI01"=1, 
                                                          "SI02"=2,
                                                          "SI03"=3), 
                                              selected = 0))
                                ,helpText("Map of energy usage(score) by each borough and district")),
                                conditionalPanel("input.condPanel==3",
                                                 selectInput("Type","Choose Data Type",
                                                 choices=c("District"=0,"Borough"=1),
                                                          selected=0),
                                                 conditionalPanel("input.Type==0",
                                                                  radioButtons("bor1",label=h3("Choose Borough"),
                                                                               choices=c("Manhattan"=1,"Bronx"=2,"Brooklyn"=3,
                                                                                         "Queens"=4,"Staten Island"=5),
                                                                               selected=1))
                                                 
                                                 
                                
                              )
                              ),
                              mainPanel(
                                tabsetPanel(id="condPanel",
                                            tabPanel("Location",leafletOutput("loc_map1",  height = 800),value=1),
                                            tabPanel("Energy map", plotOutput("distPlot1"),value=2),
                                            tabPanel("Bar Chart", tags$div(class="descrip_text", textOutput("barplot_text")),br(),plotOutput("barPlot"),tags$div(class="descrip_text", textOutput("barplot_text2")),br(),plotOutput("barPlot2"),value=3)
                                )
                              )
                   )
                   
                  
),
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
         ))

)
)

