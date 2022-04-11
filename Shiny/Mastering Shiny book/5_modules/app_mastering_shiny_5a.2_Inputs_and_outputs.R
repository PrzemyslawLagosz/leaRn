library(shiny)
# https://mastering-shiny.org/scaling-modules.html#getting-started-ui-input-server-output

# Definicja UI z opcja filtra by pokazywac tylko matrix albo tylko DF
datasetInput <- function(id, filter = NULL) {
  names <- ls("package:datasets")
  if (!is.null(filter)) {
    data <- lapply(names, get, "package:datasets")
    names <- names[vapply(data, filter, logical(1))]
  }
  
  selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}

# Ostatnia wartosc jest zwracana jak w przy[adku zastosowanie funkcji return(), dlatego reactive by moc to pozniej wykorzystac
datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

# Złączenie modułów, podpisanie pod zmienną. 
# Przypisanie data <- datasetServer pozwala wykorzystac ten modul serwera

datasetApp <- function(filter = NULL) {
  ui <- fluidPage(
    datasetInput("dataset", filter = filter),
    tableOutput("data")
  )
  server <- function(input, output, session) {
    data <- datasetServer("dataset")
    output$data <- renderTable(head(data()))
  }
  shinyApp(ui, server)
}

# Uruchamia aplikacje
datasetApp(filter = NULL)
