library(shiny)
library(stringr)

## set up the user interface
ui <- fluidPage(
  textInput(
    inputId = "name",
    label = "Tell me your name: "
  ),
  textOutput(outputId = "greeting")
)

## define server logic
server <- function(input, output, session) {
  output$greeting <- renderText({
    str_c("Hello, ", input$name, "!", sep = "")
  })
}

## run the app
shinyApp(ui, server)
