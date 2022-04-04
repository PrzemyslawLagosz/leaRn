library(shiny)
library(semantic.dashboard)
library(DT)

ui <- dashboardPage(
  dashboardHeader(title = "Przemo ogarnia", dropdown_menu()),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Iris", tabName = "iris", icon = icon("dice")),
      menuItem("Cars", tabName = "cars", icon = icon("car"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "iris",
              fluidRow(
                column(width = 8,
                       box(title="Hello", title_side = "top left", ribbon = FALSE,
                           selectInput("example", "Example", selected = NULL, choices = c("1","2")))),
                column(width = 4,
                       box(title="Hello", title_side = "top left", ribbon = FALSE,
                           selectInput("example2", "Example2", selected = NULL, choices = c("1","2")))))
             ),
      tabItem(tabName = "cars",
              fluidRow(
                box(
                  dataTableOutput("carstable", width = "100%")
                )
              )
              )
            )
  )
  
)

server <- function(input, output, session) {
  
  output$carstable <- renderDataTable(mtcars)
}

shinyApp(ui, server)