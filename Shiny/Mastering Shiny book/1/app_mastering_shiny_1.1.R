
library(shiny)

ui <- fluidPage(
  textInput(inputId = 'name', label = "What's your name?", value = 'Your name'),
  textOutput(outputId = 'greeting')
  
)

server <- function(input, output, session) {
  
  output$greeting <- renderText({
    paste('Hello', input$name)
  })
  
}

shinyApp(ui, server)