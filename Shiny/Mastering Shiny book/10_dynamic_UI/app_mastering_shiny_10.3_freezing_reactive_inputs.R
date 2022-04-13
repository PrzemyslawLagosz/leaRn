# https://mastering-shiny.org/action-dynamic.html#freezing-reactive-inputs

library(shiny)

# 1 -- This ensures that any reactives or outputs that use the input won’t be updated until the next full round of invalidation

ui <- fluidPage(
  selectInput("dataset", "Choose a dataset", c("pressure", "cars")),
  selectInput("column", "Choose column", character(0)),
  verbatimTextOutput("summary")
)

server <- function(input, output, session) {
  dataset <- reactive(get(input$dataset, "package:datasets"))
  
  observeEvent(input$dataset, {
    freezeReactiveValue(input, "column") # 1
    updateSelectInput(inputId = "column", choices = names(dataset()))
  })
  
  output$summary <- renderPrint({
    summary(dataset()[[input$column]])
  })
}

shinyApp(ui, server)