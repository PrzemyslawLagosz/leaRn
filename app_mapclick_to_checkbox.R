library(ggplot2)
# library(Cairo)   # For nicer ggplot2 output when deployed on Linux

# We'll use a subset of the mtcars data set, with fewer columns
# so that it prints nicely
mtcars2 <- mtcars[, c("mpg", "cyl", "disp", "hp", "wt", "am", "gear")]

df <- data.frame(x = c(1,2,3,4),
                 y = c(2,4,6,8))
df$Id <- df$x

ui <- fluidPage(
  fluidRow(
    column(width = 4,
           plotOutput("plot1", height = 300,
                      # Equivalent to: click = clickOpts(id = "plot_click")
                      click = "plot1_click",
                      brush = brushOpts(id = "plot1_brush")
           )
    ),
    column(width = 4,
           wellPanel(
           h3("Klikaj"),
           hr(),
           checkboxInput("checkbox1", label = "meanSNR", value= FALSE),
           checkboxInput("checkbox2", label = "t-statistics", value = FALSE),
           checkboxInput("checkbox3", label = "adjusted p-value", value = FALSE),
           checkboxInput("checkbox4", label = "log-odds", value = FALSE))
           )
  ),
  fluidRow(
    column(width = 6,
           h4("Points near click"),
           verbatimTextOutput("click_info")
    ),
    column(width = 6,
           h4("Brushed points"),
           verbatimTextOutput("brush_info")
    )
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(df, aes(x, y)) + geom_point()
  })
  
  output$click_info <- renderPrint({
    # Because it's a ggplot2, we don't need to supply xvar or yvar; if this
    # were a base graphics plot, we'd need those.
    nearPoints(df, input$plot1_click, addDist = FALSE, threshold = 50)
  })
  
  output$brush_info <- renderPrint({
    brushedPoints(df, input$plot1_brush)
  })
}

shinyApp(ui, server)