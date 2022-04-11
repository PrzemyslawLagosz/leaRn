library(shiny)
library(ggplot2)
  

ui <- fluidPage(
  sliderInput("height", "height", min = 0, max = 100, value = c(10,20)),
  sliderInput("width", "width", min = 100, max = 500, value = 250),
  plotOutput("plot", width = 250, height = 250),
  textOutput("text")
)


server2 <- function(input, output, session) {
  
  #width <- reactive(input$width)
  #height <- reactive(input$height)
  
  
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + 
      geom_point() +
      xlim(c(0,10))+
      ylim(c(input$height[1],input$height[2]))
    
  }, res = 96)
  
  my_range <- reactive({cbind(input$height[1],input$height[2])})
  
  #browser()
  
  output$text <- renderText(my_range())  
    
}

shinyApp(ui, server2)