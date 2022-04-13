library(shiny)
# https://mastering-shiny.org/action-transfer.html#ui

ui <- fluidPage(
  fileInput("upload", NULL, accept = c(".csv", ".tsv")),
  numericInput("n", "Rows", value = 5, min = 1, step = 1),
  tableOutput("head")
)

server <- function(input, output, session) {
  data <- reactive({
    req(input$upload)
    
    ext <- tools::file_ext(input$upload$name)
    switch(ext,
           csv = vroom::vroom(input$upload$datapath, delim = ","),
           tsv = vroom::vroom(input$upload$datapath, delim = "\t"),
           validate(glue::glue("Invalid file - {ext}; Please upload a .csv or .tsv file"))
    )
  })
  
  output$head <- renderTable({
    head(data(), input$n)
  })
}
shinyApp(ui, server)