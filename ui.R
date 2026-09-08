# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)
library(ggplot2)

shinyUI(fluidPage(
  titlePanel("Diamond Price Predictor & Visualizer"),
  
  sidebarLayout(
    sidebarPanel(
      h4("1. User Instructions & Documentation"),
      helpText(
        "This tool predicts diamond price based on carat size and cut quality ",
        "using a linear regression model trained on the standard 'diamonds' dataset.",
        "Adjust the controls below to dynamically update the prediction and visual exploration."
      ),
      hr(),
      
      h4("2. Input Controls"),
      sliderInput("carat", "Select Diamond Carat Weight:", 
                  min = 0.2, max = 3.0, value = 1.0, step = 0.05),
      
      selectInput("cut", "Choose Cut Quality:", 
                  choices = levels(diamonds$cut), 
                  selected = "Ideal"),
      
      checkboxInput("showModel", "Show Regression Line on Plot", value = TRUE),
      submitButton("Calculate & Update")
    ),
    
    mainPanel(
      h3("Predicted Diamond Value"),
      verbatimTextOutput("pred_price"),
      hr(),
      h3("Exploratory Data Distribution"),
      plotOutput("diamondPlot")
    )
  )
))