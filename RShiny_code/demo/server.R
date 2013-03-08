library(shiny)
library(ggplot2)
 
shinyServer(function(input, output) {
 
  output$plot <- reactivePlot(function() {

    qda_ews(mydata$obs, mydata$time, winsize = input$winsize, detrending = input$detrending, logtransform = input$logtransform, interpolate = input$interpolate, analysis = input$analysis, cutoff = input$cutoff, detection.threshold = input$detection.threshold, grid.size = input$grid.size)

  }, height=500)
})
