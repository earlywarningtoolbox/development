library(shiny)
library(ggplot2)
 
shinyUI(bootstrapPage(
 
  selectInput(inputId = 'analysis', 
    		label = 'Analysis', 
		choices = c("generic", "potential"), 
		selected = "generic"),

  # Display this only with analysis = "generic"
  conditionalPanel(condition = "input.analysis == 'generic'",

    sliderInput(inputId = "winsize",
        	label = "Sliding window size (percentage of the time series):",
        	min = 5, max = 100, value = 50, step = 0.2),

    selectInput(inputId = 'detrending', 
    		label = 'Detrending', 
		choices = c("no", "gaussian", "linear", "first-diff"), 
		selected = "no"),

    checkboxInput('logtransform', 'Logarithmize'),
    checkboxInput('interpolate', 'Interpolate')

  ),

  plotOutput(outputId = "plot", height = "300px")
))
