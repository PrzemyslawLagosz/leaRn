library(shiny)

ui <- fluidPage(
  numericInput("x", "x", value = 50, min = 0, max = 100),
  actionButton("capture", "capture"),
  textOutput("out")
)


server <- function(input, output, session) {
  
  a <- reactive(input$x)
 
  observeEvent(input$capture, {
    
    output$out <- renderText(isolate(a()))
    
  })
}

shinyApp(ui, server)