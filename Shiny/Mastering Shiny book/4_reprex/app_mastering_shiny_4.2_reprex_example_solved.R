#install.packages("xts")
library(xts)
library(lubridate)
library(shiny)

ui <- fluidPage(
  sliderInput(
    "slider",
    "Select Range:",
    min   = min(datetime),
    max   = max(datetime),
    value = range(datetime)
  ),
  verbatimTextOutput("breaks")
)

datetime <- Sys.time() + (86400 * 1:10)

server <- function(input, output, session) {
  
  brks <- reactive({
    req(input$slider)
    seq(input$slider[1], input$slider[2], length.out = 10)
  })
  
  output$breaks <- brks
}
shinyApp(ui, server)