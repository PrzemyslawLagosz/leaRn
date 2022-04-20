library(shiny)
library(shinydashboard)
ui <- dashboardPage(
  dashboardHeader(title = "My Dashboard"),
  dashboardSidebar(
    width = 0
  ),
  dashboardBody(
    fluidRow(
      column(2, offset = 1,
             actionButton("go", "Log")
      ),
      column(2, offset = 7,
             actionButton("go", "Zoom")
      )
    ),
    fluidRow(
      column(2, offset = 1,
             actionButton("go", "Case")
      ),
      column(2, offset = 7,
             actionButton("go", "Reset")
      )
    ),
    fluidRow(
      column(2, offset = 1,
             actionButton("go", "Resource")
      ),
      column(8, offset = 1,
             box()
      )
    ),
    fluidRow(
      column(2, offset = 1,
             actionButton("go", "Activity")
      )
    ),
    fluidRow(
      column(2, offset = 1,
             actionButton("go", "Resource-activity")
      )
    )
  )
)
server <- function(input, output) {}
shinyApp(ui, server)