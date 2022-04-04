library(shiny)

 library(shiny)
 
 ui <- fluidPage(
   textInput("name", "What's your name?"),
   textOutput("greeting"), # 1
   passwordInput("password", "What's your password?"),
   textAreaInput("story", "Tell me about yourself", rows = 3),
   sliderInput('date', 'Dates:', min=as.Date("2015-07-01"), max=as.Date("2015-08-01"), value = as.Date("2015-07-01")),
   sliderInput('vale', 'Values:', min = 0, max = 100, value = c(0,5), step = 5, animate = TRUE),
   selectInput("breed",
               "Select your favorite animal breed:",
               choices =list(`dogs` = list('German Shepherd', 'Bulldog', 'Labrador Retriever'),
                             `cats` = list('Persian cat', 'Bengal cat', 'Siamese Cat'))
   )
 )
 

 server <- function(input, output, session) {
   
   string <- reactive(paste0("Hello ", input$name, "!"))
   
   output$greeting <- renderText(string()) # 1
   
   observeEvent(input$name, { message("Greeting performed") }) # means that every time that name is updated, a message will be sent to the console
   
 }
 
 shinyApp(ui, server)