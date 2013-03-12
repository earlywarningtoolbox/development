library(shiny)
library(ggplot2)
#library(devtools); install_github(repo = "earlywarnings-R", username = "earlywarningtoolbox", subdir = "earlywarnings", ref = "master")
library(earlywarnings)

source("qda_ews.R")
source("generic_RShiny.R")
source("surrogates_RShiny.R")
source("potential_RShiny.R")

# Simulated data
# mydata <- read.csv("fold_simulated_data.csv")

# Real data
# mydata <- read.csv("climate_data.csv")

# Run locally
shiny::runApp("demo")

