library(shiny)
library(purrr)

# https://mastering-shiny.org/action-dynamic.html#multiple-controls
# 1 -- map() podobnie jak lapply(). to kazdego elementu z listy (1 arg), stosuje funkcje (2 arg). ZWRACA LISTE

# 2
#> So far we’ve always accessed the components of input with $, e.g. input$col1. 
#> But here we have the input names in a character vector, 
#> like var <- "col1". $ no longer works in this scenario, so we need to swich to [[, i.e. input[[var]].

# 3
#> %||% function: it returns the right-hand side whenever the left-hand side is NULL.

col <- paste0("col", seq_len(3))

ui <- fluidPage(
  numericInput("n", "Number of colours", value = 5, min = 1),
  uiOutput("col"),
  textOutput("palette")
)

server <- function(input, output, session) {
  col_names <- reactive(paste0("col", seq_len(input$n)))
  output$col <- renderUI({
    map(col_names(), ~ textInput(.x, NULL)) # 1
  })
  
  output$palette <- renderText({
    map_chr(col_names(), ~ input[[.x]] %||% "") # 2 & # 3
  })

}

shinyApp(ui, server)