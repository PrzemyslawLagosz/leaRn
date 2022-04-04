# install.packages("shiny")
# install.packages("shinythemes")
library(shiny)
library(shinythemes)

# Define UI

ui <- fluidPage(title = "I am a title", 
                theme = shinytheme("yeti"), # Motyw, wiele dostepnych
                navbarPage("My first app",  # Pasek u góry
                           tabPanel(title = "Navbar 1",
                                    sidebarPanel(
                                      tabsetPanel(
                                      tabPanel('Insider1',
                                               tags$h3("Input:"),
                                               textInput('txt1', 
                                                         label = 'Given name:', 
                                                         value = "I am default value"),
                                               textInput('txt2',
                                                         label = 'Surname')),
                                      tabPanel('Insider2',
                                               textInput('abc','ABC:')
                                               ))),
                                      mainPanel(h1("Header 1"),
                                                h4("Output:"),
                                                verbatimTextOutput("txtout"))),       # Zakładki
                           tabPanel("Navbar 2")))


# Define server function

server <- function(input, output) {
  output$txtout <- renderText(paste(input$txt1, input$txt2, sep = " " ))
}
  
  
# Create a shiny object

shinyApp(ui = ui, server = server)

