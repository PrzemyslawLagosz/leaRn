library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(dashboardthemes)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(title = "Dashboard Demo"),
    dashboardSidebar(),
    dashboardBody(
      dropdownButton(
        radioButtons(inputId = 'theme',
                     label = 'Dashboard Theme',
                     choices =  c('blue_gradient', 'boe_website', 'grey_light','grey_dark',
                                  'onenote', 'poor_mans_flatly', 'purple_gradient'))
      ),
      uiOutput("myTheme")
    )
  ),
  server = function(input, output) { 
    output$myTheme <- renderUI( shinyDashboardThemes(theme = input$theme))
  }
)