library(dplyr)
library(shiny)
library(shinythemes)

ui <- fluidPage(
  uiOutput("style"),
  mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel(
        title = "Table",
        icon = icon("table"),
        tags$br(),
        DT::DTOutput("table")
      )
    ),
    checkboxInput("style", "Dark theme")
  )
)

server <- function(input, output) {
  output$table <- DT::renderDT({
    iris
  })
  
  output$style <- renderUI({
    if (!is.null(input$style)) {
      if (input$style) {
        includeCSS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\main_app\\www\\flatly.css")
      } else {
        includeCSS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\main_app\\www\\slate.css")
      }
    }
  })
}

shinyApp(ui = ui, server = server)