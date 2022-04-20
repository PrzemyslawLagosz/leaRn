library(shiny)
library(shinyFeedback)

ui <- fluidPage(
  useShinyFeedback(), # include shinyFeedback
  
  selectInput(
    "dataset",
    "Dataset",
    choices = c(
      "airquality",
      "Unknown dataset"
    )
  ),
  actionButton("DUPA", "DUPA"),
  
  tableOutput('data_table')
)

server <- function(input, output, session) {
  
  data_out <- reactive({
    req(input$dataset)
    
    dataset_exists <- exists(input$dataset, "package:datasets")
    
    dataset_exists_2 <- input$dataset %in% ls("package:datasets")
    observeEvent(input$DUPA, message(input$dataset, dataset_exists_2))
    
    feedbackWarning("dataset", !dataset_exists, "Unknown dataset")
    req(dataset_exists, cancelOutput = TRUE)
    
    get(input$dataset, "package:datasets")
  })
  
  output$data_table <- renderTable({
    head(data_out())
  })
}

shinyApp(ui, server)