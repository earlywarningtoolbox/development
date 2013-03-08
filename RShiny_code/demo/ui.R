library(shiny)
library(ggplot2)
 
shinyUI(pageWithSidebar(

  headerPanel("Early warnings"),
    sidebarPanel(
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

      # Display this only with analysis = "generic"
      conditionalPanel(condition = "input.analysis == 'potential'",

        sliderInput(inputId = "detection.threshold",
        	label = "Threshold for local minima detection",
        	min = 0, max = 0.5, value = 0.002, step = 0.001),

        sliderInput(inputId = 'grid.size', 
    		label = 'Grid size', 
        	min = 10, max = 200, value = 25, step = 5),

        sliderInput(inputId = 'cutoff', 
    		label = 'Cutoff for visualizing the potential landscape', 
        	min = 0, max = 1, value = 0.5, step = 0.01)

      )

    ),

    mainPanel(
      plotOutput(outputId = "plot", height = "500px")
    )
  )
)






