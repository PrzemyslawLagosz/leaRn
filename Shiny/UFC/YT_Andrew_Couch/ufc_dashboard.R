library(shiny)
library(tidyverse)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "UFC Dashboardz"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Weight Class",
               tabName = "weight_class_tab",
               icon = icon("dashboard")),
      menuItem("Head to Head",
               tabName = "head_tab")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "weight_class_tab"),
      tabItem(tabName = "head_tab")
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)