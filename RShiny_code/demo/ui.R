library(shiny)
library(ggplot2)
 
shinyUI(pageWithSidebar(
 
headerPanel("Diamonds Explorer"),
sidebarPanel(
 
  #sliderInput('sampleSize', 'Sample Size', min=1, max=nrow(mydata),
  #	       value=min(1000, nrow(mydata)), step=500, round=0)

  #selectInput('x', 'X', names(dataset)),
  #selectInput('y', 'Y', names(mydata), names(mydata)[[2]])
  selectInput('y', 'Title', names(mydata), 'y')
  #selectInput('color', 'Color', c('None', names(dataset))),

  #checkboxInput('jitter', 'Jitter'),
  #checkboxInput('smooth', 'Smooth')

  #selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
  #selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
),
 
mainPanel(
plotOutput('plot')
)
))
