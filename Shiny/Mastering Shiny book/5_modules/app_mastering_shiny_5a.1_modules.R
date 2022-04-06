library(shiny)

# https://mastering-shiny.org/scaling-modules.html#module-ui

histogramUI <- function(id) {
  tagList(
    selectInput(NS(id, "var"), "Variable", choices = names(mtcars)),
    numericInput(NS(id, "bins"), "bins", 10, min = 1),
    plotOutput(NS(id, "hist"))
  )
}

# Module Server

histogramServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    data <- reactive(mtcars[[input$var]])
    
    output$hist <- renderPlot({
      hist(data(), breaks = input$bins, main = input$var)
    }, res = 96)
  })
}


ui <- fluidPage(
  histogramUI("hist1")
)

server <- function(input, output, session) {
  histogramServer("hist1")
}

shinyApp(ui, server)