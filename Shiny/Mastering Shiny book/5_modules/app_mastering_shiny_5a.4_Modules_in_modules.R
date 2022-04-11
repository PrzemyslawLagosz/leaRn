library(shiny)
# https://mastering-shiny.org/scaling-modules.html#getting-started-ui-input-server-output

# Jest to rozwiniecie app_mastering_shiny_5a.2_Inputs_and_outputs.R !!!!!!

### MODULES ###

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
# Zwraca zmienną reaktywną DataFrame[[wybrana zmienna]]

selectVarServer <- function(id, data, filter = is.numeric) {
  
  stopifnot(is.reactive(data))
  stopifnot(!is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), filter))
    })
    
    reactive(data()[[input$var]])
  })
}

# Margeing dataset abd selectVar UI module, in to one piece

selectDataVarUI <- function(id) {
  tagList(
    datasetInput(NS(id, "data"), filter = is.data.frame),
    selectVarInput(NS(id, "var"))
  )
}

# Margeing dataset abd selectVar SERVER module, in to one piece

selectDataVarServer <- function(id, filter = is.numeric) {
  moduleServer(id, function(input, output, session) {
    data <- datasetServer("data")
    var <- selectVarServer("var", data, filter = filter)
    var
  })
}

### APP ###

# Złączenie modułów, podpisanie pod zmienną. 
# Przypisanie data <- datasetServer pozwala wykorzystac ten modul serwera

selectDataVarApp <- function(filter = is.numeric) {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(selectDataVarUI("var")),
      mainPanel(verbatimTextOutput("out"))
    )
  )
  server <- function(input, output, session) {
    var <- selectDataVarServer("var", filter)
    output$out <- renderPrint(var(), width = 40)
  }
  shinyApp(ui, server)
}
# Uruchamia aplikacje

selectDataVarApp()

