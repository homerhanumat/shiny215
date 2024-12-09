## guessing game (save results)

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
    tabsetPanel(
      tabPanel(
        "Game",
        textOutput("response")
      ),
      tabPanel(
        "Results",
        DT::dataTableOutput("previous")
      )
    )
  )
)

server <- function(input, output, session) {
  
  rv <- reactiveValues(
    secret = NULL,
    game = 0,
    n = NULL,
    guesses = 0,
    finished = FALSE,
    prevs = data.frame(
      game = numeric(),
      n = numeric(),
      secret = numeric(),
      guesses = numeric(),
      finished = logical()
    )
  )
  
  output$guess <- renderUI({
    req(input$n > 0)
    numericInput("guess", "Guess a number: ", min = 1, max = input$n, value = 0)
  })
  
  observeEvent(input$submit_highest, {
    req(input$n > 0)
    hide("setup")
    show("guess")
    rv$n <- input$n
    rv$secret <- sample(1:input$n, size = 1)
    rv$finished <- FALSE
    rv$guesses <- 0
    rv$game <- rv$game + 1
  })
  
  result <- eventReactive(input$guess, {
    req(input$guess > 0)
    rv$guesses <- rv$guesses + 1
    if (input$guess < rv$secret) {
      "low"
    } else if (input$guess > rv$secret) {
      "high"
    } else {
      hide("guess")
      show("restart")
      rv$finished <- TRUE
      "correct"
    }
  })
  
  observeEvent(rv$finished, {
    req(rv$finished)
    rv$prevs <- rv$prevs |>
      rbind(data.frame(
        game = rv$game,
        n = rv$n,
        secret = rv$secret,
        guesses = rv$guesses,
        finished = TRUE
      ))
  })
  
  observeEvent(input$restart, {
    if (!rv$finished) {
      rv$prevs <- rv$prevs |>
        rbind(data.frame(
          game = rv$game,
          n = rv$n,
          secret = rv$secret,
          guesses = rv$guesses,
          finished = FALSE
        ))
    }
    hide("restart")
    updateNumericInput(session, "n", value = 0)
    show("setup")
  })
  
  output$response <- renderText({
    str_c("Your guess was ", result(), ".", sep = "")
  })
  
  output$previous <- DT::renderDataTable({
    rv$prevs
  }, rownames = FALSE)
  
}

shinyApp(ui, server)