library(shiny)
library(ggplot2)
 
shinyServer(function(input, output) {
 
dataset <- reactive(function() {
  timeseries
})
 
output$plot <- reactivePlot(function() {

  qda_ews(timeseries, winsize=50, detrending="gaussian", bandwidth=NULL, cutoff=0.5, logtransform=FALSE, interpolate=FALSE, analysis = input$analysis)

  #print(p)

}, height=700)
})
