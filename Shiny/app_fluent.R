# install.packages('remotes')

# remotes::install_github("Appsilon/shiny.react")
# remotes::install_github("Appsilon/shiny.fluent")
# 
# install.packages("shiny.router")
# install.packages("shiny.i18n")
# install.packages("leaflet")
# install.packages("plotly")


library(shiny.react)
library(shiny.fluent)


shinyApp(
  ui = div(
    Checkbox.shinyInput("checkbox", value = TRUE),
    textOutput("checkboxValue")
  ),
  server = function(input, output) {
    output$checkboxValue <- renderText({
      sprintf("Value: %s", input$checkbox)
    })
  }
)