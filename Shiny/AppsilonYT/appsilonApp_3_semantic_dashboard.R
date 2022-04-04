library(shiny)
library(semantic.dashboard)

ui <- dashboardPage(
  dashboardHeader(color = "blue", title = "Dashboard Demo", inverted = TRUE,
                  dropdownMenu(type = "notifications",
                               taskItem("Project progress...", 50.777, color = "red"))),
  dashboardSidebar(
    size = "thin", color = "teal",
    sidebarMenu(
      menuItem(tabName = "main", "Main"),
      menuItem(tabName = "extra", "Extra")
    )
  ),
  dashboardBody(
    tabItems(
      #selected = 1,
      tabItem(
        tabName = "main",
        box(h1("main"), title = "A b ckk", width = 16, color = "orange")
      ),
      tabItem(
        tabName = "extra",
        h1("extra")
      )
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)