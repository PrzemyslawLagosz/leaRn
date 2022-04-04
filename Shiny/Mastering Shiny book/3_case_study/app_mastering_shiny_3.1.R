library(shiny)
library(vroom)
library(tidyverse)
library(ggplot2)

prod_codes <- setNames(products$prod_code, products$title)

# Dlaczego {{}} i :=
count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

# UI definition

ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", choices = prod_codes))
  ),
  fluidRow(
    column(4, tableOutput('diag')),
    column(4, tableOutput('body_part')),
    column(4, tableOutput('location'))
  ),
  fluidRow(
    column(12, plotOutput('age_sex'))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  output$diag <- renderTable(
    selected () %>% count(diag, wt=weight, sort = TRUE), width = "100%"
  )
  
  output$body_part <- renderTable(
    selected () %>% count(body_part, wt=weight, sort = TRUE), width = "100%"
  )
  
  output$location <- renderTable(
    selected () %>% count(location, wt=weight, sort = TRUE), width = "100%"
  )
  
  summary <- reactive({selected() %>%
    count(age,sex, wt = weight) %>%
    left_join(population, by = c('age','sex')) %>%
    mutate(rate = n / population * 1e4)})
  
  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(x=age, y=rate, colour = sex))+
      geom_point()+
      geom_line()+
      labs(y = 'Injuries per 10,000 people')+
      xlim(0,80)
  })
  
}

shinyApp(ui, server)