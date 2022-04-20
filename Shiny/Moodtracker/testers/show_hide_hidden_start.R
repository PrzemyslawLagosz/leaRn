library(shiny)
library(shinyjs)

  shinyApp(
    ui = fluidPage(
      useShinyjs(),  # Set up shinyjs
      actionButton("btn", "Click me"),
      hidden(
        p(id = "element", "I was born invisible")
      ),
      hidden(
      textInput("a", "A")
      )
    ),
    server = function(input, output) {
      observeEvent(input$btn, {
        
        if(input$btn %% 2 == 0){
          shinyjs::hide(id = "a")
        }else{
          shinyjs::show(id = "a")
        }
        
      })
    }
  )

