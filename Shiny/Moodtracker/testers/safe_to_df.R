library(shiny)

saved_df <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\testers\\test_safe.csv")

ui <- fluidPage(
  textInput("username", "username"),
  actionButton("save", "Save!"),
  textOutput("confirmation")
)

server <- function(input, output, session) {
  
  df <- reactiveVal(saved_df)
  
  exist <- reactive(input$username %in% df()$column1)
  
  observeEvent(input$save, {
    if (exist() == TRUE) {
      output$confirmation <- renderText("Username already exists!")
    } else {
      output$confirmation <- renderText("")
      df(rbind(df(), input$username))
      write_csv(df(), "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\testers\\test_safe.csv")
    }
  })
}

shinyApp(ui, server)

