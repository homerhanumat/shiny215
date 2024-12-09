## guessing game (show/hide elements)

## computer chooses number from 1 to 5
## user enters a guess
##   - if correct, congratulate user
##   - if incorrect, ask user to guess again
## when user is correct, ask to play again

library(shiny)
library(stringr)
library(shinyjs)

ui <- pageWithSidebar(
  headerPanel("Guess the Number!"),
  sidebarPanel(
    useShinyjs(),
    numericInput(
      "guess", "Enter your guess: ",
      min = 1, max = 5, step = 1, value = 0
    ),
    hidden(actionButton("restart", "Play Again"))
  ),
  mainPanel(
    textOutput("response")
  )
)

server <- function(input, output, session) {
  
  rv <- reactiveValues(
    secret = sample(1:5, size = 1)
  )
  
  result <- eventReactive(input$guess, {
    req(input$guess > 0)
    if (input$guess < rv$secret) {
      "low"
    } else if (input$guess > rv$secret) {
      "high"
    } else {
      hide("guess")
      show("restart")
      "correct"
    }
  })
  
  observeEvent(input$restart, {
    rv$secret <- sample(1:5, size = 1)
    updateNumericInput(session, "guess", value = 0)
    hide("restart")
    show("guess")
  })
  
  output$response <- renderText({
    str_c("Your guess was ", result(), ".", sep = "")
  })
  
}

shinyApp(ui, server)