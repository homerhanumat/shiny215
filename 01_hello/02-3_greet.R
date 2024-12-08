## You can use a reactive in more than one place

library(shiny)
library(tidyverse)

## set up the user interface
ui <- fluidPage(
  textInput(
    "name",
    label = "Tell me your name: "
  ),
  actionButton("submit", label = "Submit Name"),
  br(),
  br(),
  textOutput("greeting"),
  br(),
  plotOutput("sample_plot")
)

## define server logic

server <- function(input, output, session) {
  
  greeting_text <- eventReactive(input$submit, {
    str_c("Hello, ", input$name, "!", sep = "")
  })
  
  output$greeting <- renderText({
    greeting_text()
  })
  
  output$sample_plot <- renderPlot({
    ChickWeight %>% 
      group_by(Diet, Time) %>% 
      summarize(mean_weight = mean(weight, na.rm = TRUE)) %>% 
      ggplot(aes(x = Time, y = mean_weight)) +
      geom_line(aes(color = Diet)) +
      labs(
        y = "Mean Weight (grams)",
        x = "Days since hatched",
        title = str_c(greeting_text(), " Your chicks got bigger!", sep = "")
      )
  })
}

## run the app
shinyApp(ui, server)
