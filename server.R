##  26.04.2015  Developing Data Products Project for the Coursera course
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(RCurl)
library(Hmisc)
library(HistData)

shinyServer(function(input, output) {
  ha <<- NA
  wa <<- NA
  haa <<- NA
  waa <<- NA
  

  
  getDatatables <- function(type='length'){
    ## small children or kids?
    if(input$mytabs == 1) {
      if(type=="length"){
        ## for small children, is the length data allready loaded?
        if(any(is.na(ha)) ){
          uri <- "http://www.cdc.gov/growthcharts/data/zscore/lenageinf.csv"
          ha <- read.table(textConnection(getURL(uri,
                                                 userpwd = "user:pass")), sep=",", header=TRUE, stringsAsFactors=F)
          ha <- ha[-38,]
          ha <- apply(ha, 2, as.numeric)
          ha <<- data.frame(ha)
          return(ha)
        }else{
          return(ha)
        }
      }else if(type=="weight"){ 
        if(any(is.na(wa)) ){
          uri <- "http://www.cdc.gov/growthcharts/data/zscore/wtageinf.csv"
          wa <<- read.table(textConnection(getURL(uri,
                                                  userpwd = "user:pass")), sep=",", header=TRUE, stringsAsFactors=FALSE)
          return(wa)
        }else{
          return(wa)
        }
      }
    } ## end of small childs
    if(input$mytabs == 2) {  # get data for children 2 or more years old
      if(type=="length"){
        if(any(is.na(haa)) ){ # only fetch data for first time, when its NA
          uri <- "http://www.cdc.gov/growthcharts/data/zscore/statage.csv"
          haa <- read.table(textConnection(getURL(uri,
                                                  userpwd = "user:pass")), sep=",", header=TRUE, stringsAsFactors=F)
          haa <- apply(haa, 2, as.numeric)
          haa <<- data.frame(haa)
          return(haa)
        }else{
          return(haa)
        }
      }else if(type=="weight"){ 
        if(any(is.na(waa)) ){
          uri <- "http://www.cdc.gov/growthcharts/data/zscore/wtage.csv"
          waa <- read.table(textConnection(getURL(uri,
                                                  userpwd = "user:pass")), sep=",", header=TRUE, stringsAsFactors=F)
          return(waa)
        }else{
          return(waa)
        }
      }
    }
    
    
  }
  
  output$lengthPlot <- renderPlot({
    ## Length for age charts
    ha <- getDatatables("length")
    if(class(ha) == "matrix") ha <- data.frame(ha)
    if(input$childGender=="Boys") selectgender <- 1
    if(input$childGender=="Girls") selectgender <- 2
    plot(ha$Agemos[ha$Sex==selectgender], ha$P50[ha$Sex==selectgender], col="blue", ylim=c(45,105),
         type='l', main=paste(input$childGender, "length"), xlab="Age in months", ylab="Body length in centimeters")
    ## M = P50
    lines(ha$Agemos[ha$Sex==selectgender], ha$P25[ha$Sex==selectgender], col=2, lty=2)
    lines(ha$Agemos[ha$Sex==selectgender], ha$P75[ha$Sex==selectgender], col=2, lty=2)
    lines(ha$Agemos[ha$Sex==selectgender], ha$P10[ha$Sex==selectgender], col='grey54', lty=2)
    lines(ha$Agemos[ha$Sex==selectgender], ha$P90[ha$Sex==selectgender], col='grey54', lty=2)
    grid(nx = 36)
    legend("topleft", c("P90","P75","P50", "P25","P10"), lty=c(2,2,1,2,2), col=c("grey54","red","blue", "red", "grey54"))
    points( input$childAge, input$childLength, pch=13, col=1)
  })
  
  output$lengthPlot2 <- renderPlot({
    ## Length for age charts
    haa <- getDatatables("length")
    if(class(haa) == "matrix") haa <- data.frame(haa)
    if(input$childGender=="Boys") selectgender <- 1
    if(input$childGender=="Girls") selectgender <- 2
    plot(haa$Agemos[haa$Sex==selectgender], haa$P50[haa$Sex==selectgender], col="blue",
         type='l', main=paste(input$childGender, "length"), xlab="Age in years", ylab="Body length in centimeters",ylim=c(80,185), axes=FALSE)
    axis(1, at=12*2:20, labels = 2:20)
    axis(2, las=1)
    box()
    ## M = P50
    lines(haa$Agemos[haa$Sex==selectgender], haa$P25[haa$Sex==selectgender], col=2, lty=2)
    lines(haa$Agemos[haa$Sex==selectgender], haa$P75[haa$Sex==selectgender], col=2, lty=2)
    lines(haa$Agemos[haa$Sex==selectgender], haa$P10[haa$Sex==selectgender], col='grey54', lty=2)
    lines(haa$Agemos[haa$Sex==selectgender], haa$P90[haa$Sex==selectgender], col='grey54', lty=2)
    grid(nx = 36)
    legend("topleft", c("P90","P75","P50", "P25","P10"), lty=c(2,2,1,2,2), col=c("grey54","red","blue", "red", "grey54"))
    points( input$childAge2*12, input$childLength, pch=13, col=1)
  })
  
  output$weightPlot <- renderPlot({
    ## Length for age charts
    wa <- getDatatables("weight") 
    if(input$childGender=="Boys") selectgender <- 1
    if(input$childGender=="Girls") selectgender <- 2
    plot(wa$Agemos[wa$Sex==selectgender], wa$M[wa$Sex==selectgender], col="blue", ylim=c(3,16),
         main=paste(input$childGender, "weight"), type='l', xlab="Age in months", ylab="weight in kilograms")
    
    lines(wa$Agemos[wa$Sex==selectgender], wa$P25[wa$Sex==selectgender], col=2, lty=2)
    lines(wa$Agemos[wa$Sex==selectgender], wa$P75[wa$Sex==selectgender], col=2, lty=2)
    
    grid(nx = 36)
    lines(wa$Agemos[wa$Sex==selectgender], wa$P10[wa$Sex==selectgender], col='grey54', lty=2)
    lines(wa$Agemos[wa$Sex==selectgender], wa$P90[wa$Sex==selectgender], col='grey54', lty=2)
    legend("topleft", c("P90","P75","P50", "P25","P10"), lty=c(2,2,1,2,2), col=c("grey54","red","blue", "red", "grey54"))
    points( input$childAge, input$childWeight, pch=13, col=1)
  })
  
  
  output$weightPlot2 <- renderPlot({
    ## Length for age charts
    waa <- getDatatables("weight") 
    if(input$childGender=="Boys") selectgender <- 1
    if(input$childGender=="Girls") selectgender <- 2
    plot(waa$Agemos[waa$Sex==selectgender], waa$P50[waa$Sex==selectgender], col="blue", ylim=c(10,82),
         main=paste(input$childGender, "weight"), type='l', xlab="Age in years", ylab="weight in kilograms", axes=FALSE, xlim=c(24,240))
    
    axis(1, at=12*2:20, labels = 2:20)
    axis(2, las=1)
    box() 
    lines(waa$Agemos[waa$Sex==selectgender], waa$P25[waa$Sex==selectgender], col=2, lty=2)
    lines(waa$Agemos[waa$Sex==selectgender], waa$P75[waa$Sex==selectgender], col=2, lty=2)
    grid(nx = 22 )
    lines(waa$Agemos[waa$Sex==selectgender], waa$P10[waa$Sex==selectgender], col='grey54', lty=2)
    lines(waa$Agemos[waa$Sex==selectgender], waa$P90[waa$Sex==selectgender], col='grey54', lty=2)
    legend("topleft", c("P90","P75","P50", "P25","P10"), lty=c(2,2,1,2,2), col=c("grey54","red","blue", "red", "grey54"))
    points( input$childAge2*12, input$childWeight, pch=13, col=1)
    
  })
  
 
  ## PLot of  Childs height against parents height with linear model and prediction
  output$sunflower <- renderPlot({
    input$predictBtn
    x <- getparentsdata()
    lmfit <- lm(childkg ~ parentkg, data=x)
    if(input$yourgender == "female") titleword <- "Mother"
    if(input$yourgender == "male") titleword <- "Father"
    plot(x[, c( "parentkg", "childkg")], ylab="childs height in cm", xlab="parents height in cm", 
         las=1, main=paste("Height of child and", titleword), pch=20, col= "blue" , ylim=c(140, 208)) # xlim=c(130,200), ylim=c(140,200),
    grid()
    abline(lmfit, col='lightblue')
    isolate({
    resultheight <- predict(lmfit, newdata = data.frame(parentkg= input$yourheight))
    points(input$yourheight, resultheight,  col=2, lwd=2) 
    })
    
  })
  
  output$predictedHeight <- renderText({
    input$predictBtn
    x <- getparentsdata()
    lmfit <- lm(childkg ~ parentkg, data=x)
    resultheight <- predict(lmfit, newdata = data.frame(parentkg= isolate({input$yourheight})  )) 
    k <- isolate({ 
      if(input$yourheight == 0){
        k <- paste(" ")
      } else if(input$yourheight > 130 & input$yourheight < 230) {
        k <- paste("Predicted height of child:", round(resultheight), "cm") 
      }else{
        k <- paste("Please, check the input value.")
      }
      k
    })
    
  })
  
  getparentsdata <- function(){
    data(PearsonLee) # 746 x 6
    pea <- PearsonLee; 
    pea$childkg <- pea$child*2.54
    pea$parentkg <- pea$parent * 2.54
    if(input$yourgender == "female") x <- pea[pea$par=="Mother", ]
    if(input$yourgender == "male") x <- subset(pea, par=="Father")
    if(input$childGender == "Boys") x <- x[x$chl=="Son", ]
    if(input$childGender == "Girls") x <- x[x$chl=="Daughter", ]
    return(x)
    
  }  
  

  
  ## small helfer for converting inch to centimeters
  ## result Text
  output$converted <- renderText({
    input$convertBtn
    isolate(paste("Result = ", input$fromInch*2.54,"cm") )
  })
  

})
