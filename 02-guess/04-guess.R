## guessing game (choose highest number)

## user picks a positive integer n
## computer chooses number from 1 to n
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
    div(
      id = "setup",
      numericInput("n", "Highest possible number: ", min = 1, value = 0),
      actionButton("submit_highest", "I choose this!")
    ),
    hidden(uiOutput("guess")),
    hidden(actionButton("restart", "Play Again"))
  ),
  mainPanel(
    textOutput("response")
  )
)

server <- function(input, output, session) {
  
  rv <- reactiveValues(
    # secret = sample(1:5, size = 1)
    secret = NULL
  )
  
  output$guess <- renderUI({
    req(input$n > 0)
    numericInput("guess", "Guess a number: ", min = 1, max = input$n, value = 0)
  })
  
  observeEvent(input$submit_highest, {
    req(input$n > 0)
    hide("setup")
    show("guess")
    rv$secret <- sample(1:input$n, size = 1)
  })
  
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
    # rv$secret <- sample(1:5, size = 1)
    # updateNumericInput(session, "guess", value = 0)
    hide("restart")
    updateNumericInput(session, "n", value = 0)
    show("setup")
  })
  
  output$response <- renderText({
    str_c("Your guess was ", result(), ".", sep = "")
  })
  
}

shinyApp(ui, server)