
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Children Growth Charts"),
  helpText("Growth charts are tools that contribute to forming an overall clinical impression for the child being measured"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      p("In this application you can compare childrens' growth to WHO standards."), 
      p("For a certain (1) height, (2) weight and (3) age of a child, 
                the data points are displayed on any of the included WHO and CDC growth charts.  
               There are two tabs, one for infants and one for kids from 2 to 20 years. The last tab is for predicting the height of a child when he is adult from his parents height"),
      sliderInput("childWeight",
                  "Select a weight:",
                  min = 1,
                  max = 70,
                  value = 12),
      sliderInput("childLength",
                  "Select a body length:",
                  min = 48,
                  max = 180,
                  value = 90),
      selectInput(inputId="childGender", label= "Results for boys or girls?", choices= c("Boys", "Girls"), selected="Boys"),
      # actionButton("action", label = "Apply"),
      hr(),
      helpText("If you are not familiar with centimeters (cm), here is a small calculator for converting inches to cm."),
      tags$form( tags$div(
                 numericInput(inputId="fromInch", label="From Inch", value=60, min=45, max=85)
                 , textOutput("converted")
                 , actionButton(inputId="convertBtn", label = "Convert to centimeter", icon = icon("calculator"), style='background-color:#66ccff'), style='background-color:#ddd')
      ),
      img(src="balance.png", height=145, width=145, align='left')
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id="mytabs", type="pills",
                  tabPanel("infants", icon=icon("child"), value=1, 
                           br(),
                           helpText("In the graphs below a series of percentile curves illustrate the distribution of selected body measurements in children. 
                                    Use the WHO/CDC growth standards to monitor growth for infants and children ages 0 to 3 years of age."),
                           helpText("The selected body measures will be displayed as black points."),
                           p("If the black point lies near the blue line, it means that the child has normal weight/height for the given age."),
                           sliderInput("childAge",
                                       "Select childs' age in months:",
                                       min = 1,
                                       max = 36,
                                       value = 25),
                           h4("1) Length/height-for-age chart"),
                           plotOutput("lengthPlot"),
                           h4("2) Weight-for-age chart"),
                           plotOutput("weightPlot"),
                           br(),
                           br(),
                           h3("Disclaimer"),
                           helpText("These tables are published without warranty of any
kind, either express or implied. The responsibility for the use and interpretation
of the expanded tables and any product derived from them lies with the user."),
                           h5("Source:"),
                           helpText("http://www.cdc.gov/growthcharts/data/zscore/lenageinf.csv"),
                           helpText("http://www.cdc.gov/growthcharts/data/zscore/wtageinf.csv")
                  ),
                  tabPanel("2-20 years", icon=icon("male"), value=2,
                           hr(),
                           helpText("Below are the CDC growth charts for children age 2 years and older in the U.S."),
                           helpText("Select the age and maybe adjust the childrens' body measures in the left part so that the values will be displayed as black points."),
                           p("If the black point lies near the blue line, it means that the child has normal weight/height for the given age."),
                           sliderInput("childAge2",
                                       "Select age in years:",
                                       min = 2,
                                       max = 20,
                                       value = 10),
                           plotOutput("lengthPlot2"),
                           plotOutput("weightPlot2"),
                           br(),
                           br(),
                           h5("Source:"),
                           helpText("http://www.cdc.gov/growthcharts/data/zscore/statage.csv"),
                           helpText("http://www.cdc.gov/growthcharts/data/zscore/wtage.csv")
                  ),
                  tabPanel("Height prediction", icon=icon("asterisk"), value=3,
                           hr(),
                           helpText("Here you can get a prediction of the future height of a child, given a height of a parent. 
                                    This prediction is based on the dataset PearsonLee from the HistData package.
                                    In a simple linear model childrens height is related to the mothers/fathers height."),
                           icon("external-link"), a("R Dataset (PearsonLee) description", href="http://vincentarelbundock.github.io/Rdatasets/doc/HistData/PearsonLee.html" ),
                           hr(),
                           p("Select if the parent is the mother or the father and specify the body height."),
                           tags$form(
                             selectInput("yourgender", label="Parents gender", choices=c("female", "male") ),
                             numericInput("yourheight", label="Parents height in cm",value=0, min=130, max=210, step=0.5),
                            strong( textOutput("predictedHeight"), style='color:red'),
                            actionButton(inputId="predictBtn", label = "Predict height of child as adult", icon = icon("calculator"), style='background-color:#66ccff')
                           ),
                         plotOutput("sunflower"),
                         helpText("In the plot above the centimeter values are discrete because the original values are given in inch and always have the decimal place 5 (e.g. 58.5 inch). "),
                        br(),
                        br()# tableOutput("table"))
                  ) 
      )
    )
  )
))
