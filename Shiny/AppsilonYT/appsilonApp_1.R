library(shiny)
#library(shinydashboard)
library(shiny.semantic)
library(semantic.dashboard)
library(DT)
#<i class="fa-solid fa-person-simple"></i>

ui <- dashboardPage(
  dashboardHeader(title = "Przemo"),
  dashboardSidebar(
    sidebarMenu(
      # tags$style("@import url(https://use.fontawesome.com/releases/v5.7.2/css/all.css);"),
      # Setting id makes input$tabs give the tabName of currently-selected tab
      id = "tabs",
      menuItem("Iris", tabName = "iris", icon = icon("dice")),
      menuItem("Cares", tabName = "cars", icon = icon("th")),
      menuItem("Charts", icon = icon("bar-chart-o"),
               menuSubItem("Sub-item 1", tabName = "subitem1"),
               menuSubItem("Sub-item 2", tabName = "subitem2")
      )
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "iris",
              box(plotOutput("correlation_plot"), width = 8),
              box(
                selectInput("features", "Features:", 
                            choices = c("Sepal.Width", "Petal.Length", "Petal.Width")), width = 4
              )),
      tabItem(tabName = "cars",
              fluidPage(
                h3('Cars'),
                dataTableOutput("carstable")
              )
              )
    )
    
  )
)

server <- function(input, output, session) {
  
  output$correlation_plot <- renderPlot({
    plot(iris$Sepal.Length, iris[[input$features]],
         xlab = "Sepal Length",
         ylab = input$features)
  })
  
  output$carstable <- renderDataTable(mtcars)
}

shinyApp(ui, server)