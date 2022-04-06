library(shiny)
library(purrr)

### COLUMN with sliders on the LEFT!
sliderInput01 <- function(id) {
  sliderInput(id, label = id, min = 0, max = 1, value = 0.5, step = 0.1)
}

variables <- c('gamma', 'tetha')
sliders <- map(variables, sliderInput01) #Lista wewnatrz UI zostaje automatycznie rozpakowana ## 3

## 2
### COLUMN with sliders on the RIGHT
variables_2 <- tibble::tribble(
  ~ id,    ~ min, ~ max,
  "alpha",     0,     1,
  "beta",      0,    10,
  "gamma",    -1,     1,
  "delta",     0,     1,
)

mySliderInput <- function(id, label = id, min = 0, max = 1) {
  sliderInput(id, label, min = min, max = max, value = 0.5, step = 0.1)
}

sliders_2 <- pmap(variables_2, mySliderInput)

ui <- fluidPage(
  fluidRow(
    column(6,
      sliderInput01('alpha'),
      sliderInput01('beta'),
      sliders ## 3
   ),
  column(6,
         sliders_2 ## 2
  )
))

server <- function(input, output, session) {
  
}

shinyApp(ui, server)