## Better UI Appearance

library(shiny)
library(tidyverse)

## set up the user interface
ui <- fluidPage(
  titlePanel("Example of Better UI"),
  sidebarLayout(
    sidebarPanel(
      textInput(
        "name",
        label = "Tell me your name: "
      ),
      actionButton("submit", label = "Submit Name"),
      radioButtons(
        "diet",
        "Which diet do you want to study?",
        choices = list(
          `Diet 1` = "1",
          `Diet 2` = "2",
          `Diet 3` = "3",
          `Diet 4` = "4"
        ),
        selected = "2"
      )
    ), # end sidebar panel
    mainPanel(
      fluidRow(
        textOutput("greeting")
      ),
      br(),
      fluidRow(
        column(
          width = 6,
          plotOutput("sample_plot")
        ),
        column(
          width = 6,
          DT::dataTableOutput("chicks")
        )
      ) # end fluid row
    ) # end main panel
  ) # end sidebar layout
) # end ui

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
      filter(Diet == input$diet) %>%
      ggplot(aes(x = Time, y = weight)) +
      geom_line(aes(group = Chick)) +
      labs(
        y = "Weight (grams)",
        x = "Days since hatched",
        title = str_c(
          greeting_text(),
          " Here are the chicks on Diet ",
          input$diet, ".",
          sep = ""
        )
      )
  })

  output$chicks <- DT::renderDataTable({
    ChickWeight %>%
      filter(Diet == input$diet)
  })
}

## run the app
shinyApp(ui, server)
