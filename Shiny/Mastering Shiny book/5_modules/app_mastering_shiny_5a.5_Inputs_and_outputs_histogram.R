library(shiny)
library(zeallot)

histogramOutput <- function(id) {
  tagList(
    numericInput(NS(id, "bins"), "bins", 10, min = 1, step = 1),
    plotOutput(NS(id, "hist"))
  )
}

histogramServer <- function(id, x, title = reactive("Histogram")) {
  stopifnot(is.reactive(x))
  stopifnot(is.reactive(title))
  
  moduleServer(id, function(input, output, session) {
    output$hist <- renderPlot({
      req(is.numeric(x()))
      main <- paste0(title(), " [", input$bins, "]")
      hist(x(), breaks = input$bins, main = main)
    }, res = 96)
  })
}

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

# Because we want the dataset to be reactive, we can’t fill in the choices when we start the app. NULL

selectVarInput <- function(id) {
  selectInput(NS(id, "var"), "Variable", choices = NULL)
}

# Funkcja pomocnicza. Zwraca NAZWY zmiennych spełniajace warunek podany w filter =.

find_vars <- function(data, filter) {
  names(data)[vapply(data, filter, logical(1))]
}

# observeEvent() sprawdza jaki Data Frame jest podany w zmiennej funkcji DATE, 
# nastpenie aktualizuje selectVarInput (który domyslnie ma podany choices = NULL), wykorzystujac funkcje find_vars.
# Zwraca zmienną reaktywną DataFrame[[wybrana zmienna]] oraz NAZWE wybrana zmienna w postaci listy

selectVarServer <- function(id, data, filter = is.numeric) {
  stopifnot(is.reactive(data))
  stopifnot(!is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), filter))
    })
    
    list(
      name = reactive(input$var),
      value = reactive(data()[[input$var]])
    )
  })
}


### APP ###
histogramApp <- function() {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        datasetInput("data", is.data.frame),
        selectVarInput("var"),
      ),
      mainPanel(
        histogramOutput("hist")    
      )
    )
  )

# %<-% multiple asigment from zeallot package, becouse selectVarServer returns list of reactive values
  
  server <- function(input, output, session) {
    data <- datasetServer("data")
    
    c(name, value) %<-% selectVarServer("var", data)
    
    histogramServer("hist", value, name)
  }
  shinyApp(ui, server)
} 

histogramApp()

