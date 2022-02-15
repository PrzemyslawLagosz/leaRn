library(shiny)
#* make sure to include session as an argument in order to use the update functions
server <- function(input, output, session) { 
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs), col = 'darkgray', border = 'white')
  })
  
  #* This observer will update checkboxes 1 - 4 to TRUE whenever selectAll is clicked
  observeEvent(
    eventExpr = input$selectAll,
    handlerExpr = 
      {
        lapply(paste0("checkbox", 1:4),
               function(x)
               {
                 updateCheckboxInput(session = session, 
                                     inputId = x, 
                                     value = TRUE)
               }
        )
      }
  )
  
  #* This observer will update checkboxes 1 - 4 to FALSE whenever deselectAll is clicked
  observeEvent(
    eventExpr = input$deselectAll,
    handlerExpr = 
      {
        lapply(paste0("checkbox", 1:4),
               function(x)
               {
                 updateCheckboxInput(session = session, 
                                     inputId = x, 
                                     value = FALSE)
               }
        )
      }
  )
  
  
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", "Number of observations:", min = 10, max = 500, value = 100),
      checkboxInput("checkbox1", label = "meanSNR", value= FALSE),
      checkboxInput("checkbox2", label = "t-statistics", value = FALSE),
      checkboxInput("checkbox3", label = "adjusted p-value", value = FALSE),
      checkboxInput("checkbox4", label = "log-odds", value = FALSE),
      actionButton("selectAll", label = "Select All"),
      actionButton("deselectAll", label = "Deselect All")
    ),
    mainPanel(plotOutput("distPlot"))
  )
)

shinyApp(ui = ui, server = server)