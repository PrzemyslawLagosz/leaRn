library(shiny)
library(openintro, warn.conflicts = FALSE)
library(tidyverse)

 # https://community.rstudio.com/t/mutually-dependent-numericinput-in-shiny/29307
 # https://mastering-shiny.org/action-dynamic.html#exercises-8

states <- unique(county$state)


ui <- fluidPage(
  selectInput("state", "State", choices = c("ALL", as.character(states))),
  selectInput("county", "County", choices = NULL)
)

server <- function(input, output, session) {
  
  choices_county <- reactive({
    req(input$state)
    
    if (input$state %in% states) {
      county %>% 
        filter(state == input$state) %>%
        select(name) %>%
        distinct()
    } else {
      county$name
    }
  })
  
  
  label <- reactive({
    switch(input$state,
           "Alaska" = "Burrough",
           "Louisiana" = "Parish",
           "County")
  })
  
  #browser()
  observeEvent(input$state, {
    updateSelectInput(inputId = "county", label = label(), choices = choices_county())
  })
 
}

shinyApp(ui = ui, server = server)


  #unique(filter(county,state == "Alabama")$name)

# county %>% 
#   filter(state == "Alabama") %>%
#   select(name) %>%
#   distinct()
