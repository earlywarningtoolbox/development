library(shiny)
library(ggplot2)
 
shinyUI(bootstrapPage(
 
    selectInput(inputId = 'analysis', 
    		label = 'Analysis', 
		choices = c("generic", "potential"), 
		selected = "generic"),

    plotOutput(outputId = "plot", height = "300px")
))


