library(shiny)
library(ggplot2)
 
shinyUI(pageWithSidebar(
 
  headerPanel("Early warnings"),
    sidebarPanel(
 
    #sliderInput('sampleSize', 'Sample Size', min=1, max=nrow(mydata),
    #	       value=min(1000, nrow(mydata)), step=500, round=0)

    #selectInput('y', 'Title', names(timeseries), 'y')
    selectInput('analysis', 'Analysis', c("generic", "potential"), "generic")

    #checkboxInput('analysis', 'Analysis'),

  ),
 
  mainPanel(
    plotOutput('plot')
  )
))
