
library(tidyverse)
library(shiny)
library(ggplot2)
data(airquality)

df <- airquality
df <- drop_na(airquality,Ozone) #Usunięcie wszytskich wierszy, gdy w kolumnie Ozone wystepuje NA

ui <- fluidPage(
  titlePanel("Fun with graphs"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "chart_style", #1
                   label = "Style of chart",
                   choices = c("base","ggplot2")),
      
      radioButtons(inputId = "color", 
                   label = "Pick style",
                   choices = c("1","2")),
      
      sliderInput(inputId = 'bins',
                  label = 'Number of bins:',
                  min = 1,
                  max = 100,
                  value = 50),
      hr(),
      checkboxGroupInput(inputId = "region",
                         label = h4('Chose region!'),
                         choices = c("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3))
                ),
    
    mainPanel(plotOutput(outputId = 'histogramPlot')
    )))
  

palete1 = c('black', "#75AADB")
palete2 = c('#FFCCFF', "#FF99FF")

server <- function(input, output) {
  
  output$histogramPlot <- renderPlot({
    
    x <- na.omit(airquality$Ozone) # Stworzenie wektora i drop wartosci NA
    bins <- seq(from = min(x), to = max(x), length.out = input$bins + 1)
    
    if (input$color == 1){
      chosen_color = palete1[1]
      chosen_fill = palete1[2]
    } else if (input$color == 2){
      chosen_color = palete2[1]
      chosen_fill = palete2[2]
    }
      
    
    if (input$chart_style == "base") {
    hist(x, 
         breaks = bins, 
         border = chosen_color,
         col = chosen_fill,
         xlab = "Ozone level",
         main = "Histogram of Ozone level")
    } else if (input$chart_style == "ggplot2"){
      ggplot(data = df, aes(x = Ozone))+
        geom_histogram(bins = input$bins, 
                       color=chosen_color, 
                       fill = chosen_fill)+
        xlab("Level of Ozone")
        
      }
  })
}


# Create shiny app

shinyApp(ui = ui, server = server)