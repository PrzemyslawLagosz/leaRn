library(shiny)

# https://mastering-shiny.org/action-feedback.html#transient-notification

ui <- fluidPage(
  actionButton("goodnight", "Good night")
)

server <- function(input, output, session) {
  observeEvent(input$goodnight, {
    showNotification("So long")
    Sys.sleep(1)
    showNotification("Farewell", type = "message")
    Sys.sleep(0)
    showNotification("Auf Wiedersehen", type = "warning")
    Sys.sleep(1)
    showNotification("Adieu", type = "error")
  })
}


# https://mastering-shiny.org/action-feedback.html#progressive-updates
# want to show the notification when the task starts, and remove the notification when the task completes.

server1 <- function(input, output, session) {
  data <- reactive({
    id <- showNotification("Reading data...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id), add = TRUE)
    
    read.csv(input$file$datapath)
  })
}

shinyApp(ui, server)