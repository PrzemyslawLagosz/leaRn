
library(shiny)
#funkcje musza byc tworzone poza UI
usWeekDateInput <- function(inputId, ...) {
  dateInput(inputId = inputId, ..., format = "DD-MM-yy", daysofweekdisabled = c(0, 6))
}

ui <- fluidPage(
  
  usWeekDateInput('date2', 'my date')
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)