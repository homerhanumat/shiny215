## Action Buttons to control reactivity;
## eventReactive reacts to only one input

library(shiny)
library(stringr)

## set up the user interface
ui <- fluidPage(
  textInput(
    "name",
    label = "Tell me your name: "
  ),
  actionButton("submit", label = "Submit Name"),
  textOutput("greeting")
)

## define server logic

server <- function(input, output, session) {
  
  greeting_text <- eventReactive(input$submit, {
    str_c("Hello, ", input$name, "!", sep = "")
  })
  
  output$greeting <- renderText({
    greeting_text()
  })
}

## run the app
shinyApp(ui, server)
