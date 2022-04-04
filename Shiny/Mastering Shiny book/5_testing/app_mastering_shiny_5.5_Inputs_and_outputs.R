library(shiny)
library(datasets)

# Pojedyncze zastosowanie get()
get("faithful", envir = as.environment("package:datasets"))

# I use a single additional argument so that you can limit the options to
# built-in datasets that are either data frames 
# (filter = is.data.frame) or matrices (filter = is.matrix)

datasetInput <- function(id, filter = NULL) {
  names <- ls("package:datasets")
  if (!is.null(filter)) {
    data <- lapply(names, get, "package:datasets")
    names <- names[vapply(data, filter, logical(1))]
  }
  
  selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}

datasetServer <- function(id) {
  moduleServer(id, module = function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

selectVarInput <- function(id) {
  selectInput(NS(id, "var"), "Variable", choices = NULL) 
}

  ui <- fluidPage(
    selectInput('my_filter', "DF or Matrix", choices = c("is.data.frane","is.matrix", "NULL")),
    datasetInput("dataset"),
    tableOutput("data")
  )
  server <- function(input, output, session) {
    
    # x <- reactive(input$my_filter)
    #   
    # updateSelectInput(session, "dataset", filter = x())
    
    data <- datasetServer("dataset")
    output$data <- renderTable(head(data()))
  }
  shinyApp(ui, server)
  
  