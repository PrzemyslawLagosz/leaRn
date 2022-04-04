library(shiny)

ui <- fluidPage(
  textInput('a','a'),
  textInput('b','b'),
  textInput('d','d'),
  textOutput('f')
  
)

server1 <- function(input, output, session) {
  c <- reactive(paste(input$a, input$b, sep = "-"))
  e <- reactive(paste(c(), input$d))
  output$f <- renderText(e())
}


shinyApp(ui, server1)