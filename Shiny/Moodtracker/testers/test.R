library(tidyverse)

passwords <- data.frame(username = "tester1",
                        password = "tester1_pass")

passwords <- passwords %>%
  mutate(user_pas = paste0(username, "_", password))

new_user_row <- function(username, password) {
  newUserRow <- c(username, password, paste0(username, "_", password))
  
}

passwords <- rbind(passwords, new_user_row("usefdfdfr2", "pasdfdfdfsword2"))


library(shiny)
library(shinyFeedback)

ui <- fluidPage(
  useShinyFeedback(), # include shinyFeedback
  
  textInput(
    "myInput",
    "Warn if >3 characters",
    value = ""
  )
)

server <- function(input, output, session) {
  observeEvent(input$myInput, {
    
    if (nchar(input$myInput) > 3) {
      showFeedbackWarning(
        inputId = "myInput",
        text = "too many chars"
      )  
    } else {
      hideFeedback("myInput")
    }
    
  })
}

shinyApp(ui, server)