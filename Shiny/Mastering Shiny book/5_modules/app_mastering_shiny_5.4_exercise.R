library(shiny)
library(glue)


randomUI <- function(id,number) {
  tagList(
    textOutput(NS(id,"val")),
    actionButton(NS(id, 'go'), glue("Go {number} !"))
  )
}
randomServer <- function(id) {
  
  moduleServer(id, module = function(input, output, session) {
    rand <- eventReactive(input$go, sample(100,1))
    output$val <- renderText(rand())
})
}


ui <- fluidPage(
  randomUI('exercise1','1'),
  randomUI('exercise2','2'),
  randomUI('exercise3','3'),
  randomUI('exercise4','4')
)

server <- function(input, output, session) {
  randomServer('exercise1')
  randomServer('exercise2')
  randomServer('exercise3')
  randomServer('exercise4')
}

shinyApp(ui, server)


# Tue Mar 01 14:03:04 2022 ------------------------------
