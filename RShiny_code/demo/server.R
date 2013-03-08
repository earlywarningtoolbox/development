library(shiny)
library(ggplot2)
 
shinyServer(function(input, output) {
 
dataset <- reactive(function() {
  timeseries
})
 
output$plot <- reactivePlot(function() {

  qda_ews(timeseries, winsize = input$winsize, detrending = input$detrending, logtransform = input$logtransform, interpolate = input$interpolate, analysis = input$analysis)

}, height=700)
})
