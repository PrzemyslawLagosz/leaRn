library(shiny)

# Saved_users_list normally came from external file
saved_users_list <- list(data.frame(
                                    rate = c(8,1),
                                    day_comment = c("Found a gf",
                                                    "Broke my arm")),
                         data.frame(
                                    rate = c(10,1),
                                    day_comment = c("Found a job",
                                                    "They fired me")))


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
  
  users_list <- reactiveVal(saved_users_list)
  selected_user <- reactive(as.numeric(input$userId))
  
  output$test_table <- renderTable({
    users_list()[selected_user()]
  })
  
  new_day_rate <- reactive(list(data.frame(
                                           rate = input$day_rate,
                                           day_comment = input$comment)))
  
  choosen_user <- reactive(users_list()[[selected_user()]])
  
  # Button to add values to the data frame inside users_list
  observeEvent(input$add, {
    # users_list()[[selected_user()]]  <- rbind(users_list()[[selected_user()]], as.data.frame(new_day_rate())) # Error in <-: invalid (NULL) left side of assignment
    
    browser()
    choosen_user(rbind(choosen_user(), new_day_rate()[[1]])) # Here I tried to implement a solution from linked question 
  })
  
  # Button to test inputs values
  observeEvent(input$test, {
    # message("userId: ", input$userId, " ", class(input$userId))
    # message("selected_user(): ", selected_user())
    # message("new_day_rate(): ", new_day_rate())
    # message("str(new_day_rate()): ", str(new_day_rate()))
    # message("users_list()[[selected_user()]]: ",users_list()[[selected_user()]])
    message("AA:   ", rbind(choosen_user(), new_day_rate()[[1]]))
  })
}

shinyApp(ui, server)