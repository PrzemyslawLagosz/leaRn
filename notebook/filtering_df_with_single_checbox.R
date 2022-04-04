library(shiny)
library(ggplot2)
library(tidyverse)
#library(readr)
library(dplyr)

df <- data.frame(Column1 = c(1,2,3),
                 Column2 = c(1,2,3))
 
ui <- fluidPage(
  checkboxInput("checkbox1", "checkbox1"),
  checkboxInput("checkbox2", "checkbox2"),
  tableOutput("table"),
  plotOutput('plot1'),
  selectInput("select1", "Select1",
              choices = c("Column1", "Column2"),
              multiple = TRUE,
              selectize = FALSE,
              selected = c("Column1", "Column2"))
)

make_a_plot <- function(df, bolean_list) {
  
  df <- df[,bolean_list]
  print(df)
}


server <- function(input, output, session) {
  
  #observeEvent(input$checkbox2, message(v_checbox_1))
  
  v_checbox_1 <- reactive(c(input$checkbox1, input$checkbox2))
  
  
  
  output$table <- renderTable({
    
    df_next <- df[,v_checbox_1(), drop = F]
    
    df_next <- normalize_df(df_next)
    
    df_next <- df_to_coordinates(df_next)
    })
  
  # or like this
  # output$table <- renderTable(df[,c(v_checkboxes)])
}

shinyApp(ui, server)