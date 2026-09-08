# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)
library(dplyr)

# Fit linear model on a subset of the diamonds dataset for responsiveness
data("diamonds")
set.seed(42)
diamonds_sample <- diamonds %>% sample_n(2000)
fit <- lm(price ~ carat + cut, data = diamonds_sample)

shinyServer(function(input, output) {
  
  # Reactive prediction
  price_prediction <- reactive({
    carat_val <- input$carat
    cut_val <- input$cut
    predict(fit, newdata = data.frame(carat = carat_val, cut = cut_val))
  })
  
  output$pred_price <- renderText({
    paste0("Estimated Market Price: $", round(price_prediction(), 2), " USD")
  })
  
  output$diamondPlot <- renderPlot({
    p <- ggplot(diamonds_sample, aes(x = carat, y = price, color = cut)) +
      geom_point(alpha = 0.4) +
      geom_point(aes(x = input$carat, y = price_prediction()), 
                 color = "red", size = 5, shape = 18) +
      labs(
        title = "Carat vs. Price Distribution",
        x = "Carat",
        y = "Price ($)"
      ) +
      theme_minimal()
    
    if (input$showModel) {
      p <- p + geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = "black")
    }
    
    p
  })
})