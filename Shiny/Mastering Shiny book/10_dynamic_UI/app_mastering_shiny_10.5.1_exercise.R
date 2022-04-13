library(shiny)
library(shinyjs)

# https://mastering-shiny-solutions.org/dynamic-ui.html !!

ui <- fluidPage(
  useShinyjs() ,
  numericInput("year", "year", value = 2020),
  dateInput("date", "date", value = Sys.Date())
)

server <- function(input, output, session) {
  
  observeEvent(input$year, {
    
    req(input$year) # stop if year is blank
    daterange <- range(as.Date(paste0(input$year, "-01-01")),as.Date(paste0(input$year, "-12-31")))
    updateDateInput(session, "date", min = daterange[1], max = daterange[2] )
    delay(250,  # delay 250ms
          updateDateInput(session,"date",
                          value = daterange[1]
          ))
  })
}

shinyApp(ui = ui, server = server)