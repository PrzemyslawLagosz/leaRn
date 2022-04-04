library(shiny)
library(shiny.semantic)
library(semantic.dashboard)

grid_demo <- function() {
  div(
    h1(class="ui header", id="grid", "Grid"),
    grid(grid_template(default = list(
      areas = rbind(
        c("header", "header", "header"),
        c("menu",   "main",   "right1"),
        c("menu",   "main",   "right2")
      ),
      rows_height = c("100px", "50px", "100px"),
      cols_width = c("100px", "2fr", "1fr")
    )),
    container_style = "border: 1px solid #3d7ea6",
    area_styles = list(header = "border-bottom: 3px solid #5c969e",
                       menu = "border-right: 3px solid #5c969e",
                       main = "border-right: 3px solid #5c969e",
                       right1 = "border-bottom: 3px solid #5c969e"),
    header = selectInput("dupa", "dupa", choices = c(1,2,3), selected = NULL),
    menu = div("menu"),
    main = grid(grid_template(default = list(
      areas = rbind(
        c("top_left", "top_right"),
        c("bottom_left", "bottom_right")
      ),
      rows_height = c("50%", "50%"),
      cols_width = c("50%", "50%")
    )),
    container_style = "padding: 5px;",
    area_styles = list(top_left = "border: 3px solid #ffa5a5;",
                       top_right = "border: 3px solid #ffa5a5;",
                       bottom_left = "border: 3px solid #ffa5a5;",
                       bottom_right = "border: 3px solid #ffa5a5;"),
    top_left = div("main top left"),
    top_right = div("main top right"),
    bottom_left = div("main bottom left"),
    bottom_right = div("main bottom right")
    ),
    right1 = div("right 1"),
    right2 = div("right 2")
    )
  )
}

ui <- dashboardPage(
  dashboardHeader(title = title, dropdownMenu(icon = icon("settings"), show_counter = FALSE)
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Fighter vs Fighter", tabName = "fighters", icon = icon("diamond")),
      menuItem("Weight comparision", tabName = "cars", icon = icon("settings")),
      menuItem("About", tabName = "about", icon = icon("info"))
    )
  ),
  dashboardBody(
    tabItems()))

server <- function(input, output, session) {
  
}

shinyApp(ui, server)