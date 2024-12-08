## guessing game (first stab at it)

## computer chooses number from 1 to 5
## user enters a guess
##   - if correct, congratulate user
##   - if incorrect, ask user to guess again

library(shiny)
library(stringr)

ui <- pageWithSidebar(
  headerPanel("Guess the Number!"),
  sidebarPanel(
    numericInput(
      "guess", "Enter your guess: ",
      min = 1, max = 5, step = 1, value = 1
    )
  ),
  mainPanel(
    textOutput("response")
  )
)

server <- function(input, output, session) {
  
  secret <- sample(1:5, size = 1)
  
  result <- eventReactive(input$guess, {
    if (input$guess < secret) {
      "low"
    } else if (input$guess > secret) {
      "high"
    } else {
      "correct"
    }
  })
  
  output$response <- renderText({
    print(secret)
    str_c("Your guess was ", result(), ".", sep = "")
  })
  
}

shinyApp(ui, server)