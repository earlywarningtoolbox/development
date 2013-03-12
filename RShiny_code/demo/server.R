library(shiny)
library(ggplot2)

# Simulated data
simulateddata <- read.csv("fold_simulated_data.csv")

# Real data
climatedata <- read.csv("climate_data.csv")

 
shinyServer(function(input, output) {
 
    datasetInput <- reactive({
        switch(input$timeseries,
        "simulated - overharvested resource" = simulateddata,
        "real-world - climate data" = climatedata)
    })
    
  output$plot <- reactivePlot(function() {

    qda_ews(datasetInput(), winsize = input$winsize, detrending = input$detrending, logtransform = input$logtransform, interpolate = input$interpolate, analysis = input$analysis, cutoff = input$cutoff, detection.threshold = input$detection.threshold, grid.size = input$grid.size)

  }, height=500)
})
