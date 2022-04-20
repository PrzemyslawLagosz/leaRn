library(shiny)


ui <- fluidPage(
  useShinyFeedback(),
  checkboxInput("box", "box"),
  textInput("username", "username")
)

server <- function(input, output, session) {
  
  observeEvent(input$box, {
    if (input$box == TRUE) {
      showFeedbackDanger("username", "DUPcia")
    } else {
        hideFeedback("username")
      }
    })
  
  observeEvent(input$box, message(input$box))
}

shinyApp(ui, server)