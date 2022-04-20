library(shiny)
library(tidyverse)
library(shinyFeedback)


ui <- fluidPage(
  useShinyFeedback(),
  checkboxInput("box", "box"),
  textInput("username", "username"),
  actionButton("enable", "Enable me")
)

server <- function(input, output, session) {
  
  observeEvent(input$username, {
    if (nchar(input$username) > 6 | input$username == "") {
      showFeedbackDanger("username", "DUPcia")
    } else {
      hideFeedback("username")
    }
  })
  
  
  observeEvent(input$box, message(input$box))
}

shinyApp(ui, server)