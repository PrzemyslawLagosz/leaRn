library(shiny)

# Saved_users_list normally came from external file
# saved_users_list_reprex <- list(
#   data.frame(
#     date = c(as.Date("2022-04-18"), as.Date("2022-04-19")),
#     rate = c(8,1),
#     day_comment = c("Found a gf", "Broke my arm")
#   ),
#   data.frame(
#     date = c(as.Date("2022-04-18"), as.Date("2022-04-19")),
#     rate = c(10,1),
#     day_comment = c("Found a job", "They fired me")
#   )
# )

# saveRDS(saved_users_list_reprex, "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\testers\\users_list_reprex.RData")

saved_users_list_reprex <- readRDS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\testers\\users_list_reprex.RData")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("userId", "userId", choices = c(1:2)),
      sliderInput("day_rate", "Rate your day", min = 0, max = 10, value = 5, step = 0.5),
      dateInput("date", "Pick a date"),
      textAreaInput("comment", "Comment", placeholder = "Add a description (OPTIONAL)"),
      actionButton("add", "Add"),
      actionButton("test", "Test values") # Button to test inputs values
    ),
    mainPanel(
      tableOutput("test_table")
    )
  )
)

server <- function(input, output, session) {
  cache <- reactiveValues(saved_users = saved_users_list_reprex)
  selected_user <- reactive(as.numeric(input$userId))
  
  output$test_table <- renderTable({
    cache$saved_users[selected_user()]
  })
  
  new_day_rate <- reactive(
    data.frame(
      date = as.Date(input$date),
      rate = input$day_rate,
      day_comment = input$comment
    )
  )
  
  observeEvent(input$add, {
    cache$saved_users[[selected_user()]] <- rbind(cache$saved_users[[selected_user()]], new_day_rate())
    saveRDS(cache$saved_users, "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\testers\\users_list_reprex.RData")
  })
  
  observeEvent(input$test, {
    # message("userId: ", input$userId, " ", class(input$userId))
    # message("selected_user(): ", selected_user())
    # message("new_day_rate(): ", new_day_rate())
    # message("str(new_day_rate()): ", str(new_day_rate()))
    message("users_list()[[selected_user()]]: ", cache$saved_users[[selected_user()]])
    message("cache: ", cache$saved_users)
  })
}

shinyApp(ui, server)