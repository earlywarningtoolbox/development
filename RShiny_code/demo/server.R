library(shiny)
library(ggplot2)
 
shinyServer(function(input, output) {
 
dataset <- reactive(function() {
  #mydata[sample(nrow(mydata), input$sampleSize),]
  #mydata
  timeseries
})
 
output$plot <- reactivePlot(function() {
  #p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) + geom_point()
  #p <- ggplot(dataset(), aes_string(x=input$y)) + geom_histogram()

  #p <- qda_ews(timeseries, winsize=50, detrending="gaussian", bandwidth=NULL, cutoff=0.5, logtransform=FALSE, interpolate=FALSE)
  p <- ggplot(data.frame(list(x = timeseries)), aes(x = x)) + geom_histogram()

  #if (input$color != 'None')
  #  p <- p + aes_string(color=input$color)
  
  #facets <- paste(input$facet_row, '~', input$facet_col)
  #if (facets != '. ~ .')
  #  p <- p + facet_grid(facets)

  #if (input$jitter)
  #  p <- p + geom_jitter()

  #if (input$smooth)
  #  p <- p + geom_smooth()

  print(p)

}, height=700)
})
