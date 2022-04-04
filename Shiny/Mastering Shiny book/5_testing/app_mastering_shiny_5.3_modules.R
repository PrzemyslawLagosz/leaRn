library(shiny)

histogramUI <- function(id) {
  tagList(
    selectInput(NS(id, "var"), "Variable", names(mtcars)),
    numericInput(NS(id, "bins"), "bins", 10, min = 1),
    plotOutput(NS(id, "hist"))
  )
}

histogramServer <- function(id) {
  
  moduleServer(id, function(input, output, session){
    data <- reactive(mtcars[[input$var]])
    
    output$hist <- renderPlot({
      hist(data(), breaks = input$bins, main = input$var)
    }, res = 96)
    
  })
}

ui <- fluidPage(
  fluidRow(
    column(6,
           histogramUI('histogram1')
    ),
    column(6,
           histogramUI('histogram2')
    )
  )
)

server <- function(input, output, session) {
  
  histogramServer('histogram1')
}

shinyApp(ui, server)