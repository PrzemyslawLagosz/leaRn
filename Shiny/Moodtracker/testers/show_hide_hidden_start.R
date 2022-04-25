library(shiny)
library(shinyjs)

  shinyApp(
    ui = fluidPage(
      useShinyjs(),  # Set up shinyjs
      actionButton("btn", "Click me"),
      hidden(
        p(id = "element", "I was born invisible")
      ),
      hidden(textInput("a", "A", placeholder = "AAA")),
      hidden(textInput("b", "B", placeholder = "BBB"))
    ),
    server = function(input, output) {
      observeEvent(input$btn, {
        
        if(input$btn %% 2 == 0){
          shinyjs::hide(id = "a")
          shinyjs::hide(id = "b")
        }else{
          shinyjs::show(id = "a")
          shinyjs::show(id = "b")
        }
        
      })
    }
  )

