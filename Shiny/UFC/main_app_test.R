library(shiny)
library(ggplot2)
library(tidyverse)
#library(readr)
library(dplyr)
#library(shinydashboard)
library(semantic.dashboard)
library(shiny.semantic)

source("C:/Users/Przemo/Documents/R/leaRn/Shiny/my_functions.R")

raw_fighter_details_EU <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_EU.csv")
raw_fighter_details_USA <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_USA.csv")

# df <- raw_fighter_details_EU[, c(2, 3, 4, 7, 10, 11, 12, 14)]


title <- tags$a(tags$img(src = "ufc_logo.jpg", height = "60", width = "90"))


# icon = icon("settings"), show_counter = FALSE,
ui <-  dashboardPage (
  dashboardHeader(title = title, toggle("theme", "Dark mode ", is_marked = FALSE), icon(class="moon")
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Fighter vs Fighter", tabName = "fighters", icon = icon("diamond")),
      menuItem("Weight comparision", tabName = "cars", icon = icon("settings")),
      menuItem("About", tabName = "about", icon = icon("info"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "fighters",
              fluidRow(
                column(width = 14,
                       box(title = "Decription", title_side = "top left", ribbon = FALSE,
                           p("ELO TU BEDZIE OPIS"), hr(), p("ELO TU BEDZIE OPIS")
                           
                       )
                ),
                column(width = 2,
                       box(title = "Settings", title_side = "top left", ribbon = FALSE,
                           
                           multiple_radio("units", "Choose Units", choices = c("EU", "USA"))
                       )
                )
              ),
              sidebar_layout(
                sidebar_panel(
                  
                  box(title="Stats", title_side = "top left", ribbon = FALSE, collapsible = FALSE,
                      div(checkbox_input("Height", "Height", is_marked = TRUE)),
                      div(checkbox_input("Weight", "Weight", is_marked = TRUE)),
                      div(checkbox_input("Reach", "Reach", is_marked = TRUE)),
                      div(checkbox_input("SLpM", "Significant Strikes Landed per Minute", is_marked = TRUE)),
                      div(checkbox_input("Str_Def", "Significant Strike Defence (the % of opponents strikes that did not land)", is_marked = TRUE)),
                      div(checkbox_input("Sub_Avg", "Average Submissions Attempted per 15 minutes", is_marked = TRUE)),
                      div(checkbox_input("TD_Acc", "Takedown Accuracy", is_marked = TRUE)),
                      div(checkbox_input("TD_Avg", "Average Takedowns Landed per 15 minutes", is_marked = TRUE))),
                  
                  box(title="Weight Class", title_side = "top left", ribbon = FALSE, collapsible = FALSE,
                      uiOutput("weight_class_selector")
                  ),
                  
                  box(title="Fighter 1", title_side = "top left", ribbon = FALSE, collapsible = FALSE,
                      uiOutput("fighter_1_selector")
                  ),
                  
                  box(title="Fighter 2", title_side = "top left", ribbon = FALSE, collapsible = FALSE,
                      selectInput("example2", "Example2", selected = NULL, choices = c("1","2")))
                ),
                
                main_panel(
                  
                  column(width = 6,
                         box(title="Plot", title_side = "top left", ribbon = FALSE)),
                  
                  column(width = 6,
                         box(title="Legend", title_side = "top left", ribbon = FALSE))
                )
              ),
              
              
              tabItem(tabName = "cars",
                      p("DUPA"))
      )
    )
  ))#dashboardPage



server <- function(input, output, session) {
  
  observeEvent(input$units, message(input$units))
  
  main_df <- reactive(if (input$units == "EU") {
      raw_fighter_details_EU
    } else {
      raw_fighter_details_USA
    }
    )
  
  output$weight_class_selector <- renderUI({
    
    selected_columns <- c(2, 3, 4, 7, 10, 11, 12, 14)
    
    
    
    selectInput("v_weight_class_selector", label = "dupa", selected = NULL, choices = sort(unique(main_df()$Weight)))}
  )
  
  output$fighter_1_selector <- renderUI({
    
    fighter_1_selector_df <- df %>%
      
    
    selectInput("v_fighter_1_selector", "Fighter 1", selected = NULL, choices = c("1","2"))
    
  })
}

shinyApp(ui, server)