library(shiny)

## set up the user interface
ui <- fluidPage(
  "Hello, world!"
)

## define server logic
server <- function(input, output, session) {
  
}

## run the app
shinyApp(ui, server)
