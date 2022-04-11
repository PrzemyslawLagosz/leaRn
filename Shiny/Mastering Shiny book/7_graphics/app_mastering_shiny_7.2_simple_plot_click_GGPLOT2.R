library(shiny)
library(ggplot2)

# https://mastering-shiny.org/action-graphics.html#brushing

ui <- fluidPage(
  plotOutput("plot", click = "plot_click"),
  verbatimTextOutput("info"),
  tableOutput("data")
)

server <- function(input, output) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) +
    geom_point()
  }, res = 96)
  
  output$info <- renderPrint({
    req(input$plot_click)
    x <- round(input$plot_click$x, 2)
    y <- round(input$plot_click$y, 2)
    cat("[", x, ", ", y, "]", sep = "")
  })
  
  output$data <- renderTable({
    req(input$plot_click)
    browser()
    nearPoints(mtcars, input$plot_click)
  })
}

shinyApp(ui, server)