library(shiny)
#library(shinyapps)

ui <- fluidPage(theme = "bootstrap.css",
                  fluidRow(
                    column(8, align="center", offset = 2,
                           textInput("string", label="",value = ""),
                           tags$style(type="text/css", "#string { height: 50px; width: 100%; text-align:center; font-size: 30px;}")
                    )
                  ),
                  
                  fluidRow(
                    column(6, align="center", offset = 3,
                           actionButton("button",label = textOutput("prediction")),
                           tags$style(type='text/css', "#button { vertical-align: middle; height: 50px; width: 100%; font-size: 30px;}")
                    )
                  )
)



server <- function(input, output, session) {
  
}

shinyApp(ui, server)