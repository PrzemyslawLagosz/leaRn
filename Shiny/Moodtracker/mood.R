library(shiny)
library(tidyverse)
library(shinyFeedback)
library(shinyjs)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(lubridate)


myToastOptions <- list(
  positionClass = "toast-top-right",
  progressBar = FALSE,
  timeOut = 3000,
  closeButton = TRUE,
  
  # same as defaults
  newestOnTop = TRUE,
  preventDuplicates = FALSE,
  showDuration = 300,
  hideDuration = 1000,
  extendedTimeOut = 1000,
  showEasing = "linear",
  hideEasing = "linear",
  showMethod = "fadeIn",
  hideMethod = "fadeOut"
)

# passwords <- data.frame(username = "A",
#                         password = "B")
# 
# passwords <- passwords %>%
#   mutate(user_pas = paste0(username, password))
#   write_csv(passwords, "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\saved_passwords.csv")
# 
# users_list <- list(AB = data.frame(date = c(as.Date("2022-04-18")),
#                                    rate = c(8),
#                                    day_comment = c("Byłem na spacerku")))

# saveRDS(users_list, "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")

mood_logo_200 <- tags$a(tags$img(src = "mood_logo.png", height = "200", width = "200"))
mood_logo_150 <- tags$a(tags$img(src = "mood_logo.png", height = "150", width = "150"))

saved_passwords <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\saved_passwords.csv")
saved_users_list <- readRDS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")

#readRDS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")

new_user_row <- function(username, password) {
  newUserRow <- c(username, password, paste0(username, password))
}

login_page <-
  fluidRow(
    column(4),
    column(4,
         tags$div(
           class = "well",
           textInput("username", "User name:", placeholder = "Your username", value = "A"),
           passwordInput("password", "Password:", placeholder = "Password", value = "B"),
           textOutput("login_validation"),
           fluidRow(
             column(6, align="left", actionButton("register", "Register")),
             column(6, align="right", actionButton("login", "Login"))
           )
         )),
  column(4)
)

register_page <- 
  fluidRow(
    column(4),
    column(4,
           tags$div(
             class = "well",
             textInput("username_register", "User name:", placeholder = "Your username"),
             textInput("password1", "Password:", placeholder = "Password"),
             textInput("password2", "Confirm password:", placeholder = "Confirm password"),
             fluidRow(
               column(6, align="left", actionButton("back", "Back")),
               column(6, align="right", actionButton("register_confirm", "Register"))
             )
           )),
    column(4)
  )

main_page <- 
  sidebarLayout(
    sidebarPanel(
      sliderInput("day_rate", "Rate your day", min = 0, max = 10, value = 5, step = 0.5),
      dateInput("date", "Pick a date"),
      textAreaInput("comment", "Comment", placeholder = "Add a description (OPTIONAL)"),
      fluidRow(
        column(6, align="left", actionButton("important_btn", "Important event")),
        column(6, align="right", actionButton("add_btn", "Add"))
      ),
      hidden(dateInput("important_date", "Pick a date")),
      hidden(textAreaInput("important_comment", "Comment", placeholder = "Add a description (OPTIONAL)")),
      hidden(actionButton("add_important_btn", "Add important event"))
      
  ),
  mainPanel(
    plotlyOutput("humor_plot"),
    tableOutput("test_table")
  )
)

logo_center <- fluidRow(column(4), column(4,  align="center", mood_logo_200), column(4))

logo_top_left <- fluidRow(column(4,  align="left", mood_logo_150), 
                          column(4),
                          column(2),
                          column(2, 
                                 tags$div(
                                   class = "well",
                                   align="right", actionButton("logout", "Log Out"))
                                 )
                          )
ui <- fluidPage(
  useShinyjs(),
  shinyFeedback::useShinyFeedback(),
  tabsetPanel(
    id = "wizard",
    type = "hidden",
    tabPanel("login_page",
             logo_center,
             login_page),
    
    tabPanel("main_page",
             logo_top_left,
             main_page),
    
    tabPanel("register_page",
             logo_center,
             register_page)
  )
  
)

server <- function(input, output, session) {
  
  passwords <- reactiveVal(saved_passwords)
  cache <- reactiveValues(saved_users = saved_users_list)
  
  switch_page <- function(page) {
    updateTabsetPanel(inputId = "wizard", selected = page)
  }
  
  user_password <- reactive({paste0(input$username, input$password)})
  exist <- reactive({user_password() %in% passwords()$user_pas})
  
  ### LOGIN PAGE ###
  # Login Button - login_page
  loged_user_id <- reactive(which(passwords()$user_pas == user_password()))
  observeEvent(input$login, {
    # Vaidation login_page
    if (exist() == TRUE){
      hideFeedback("username")
      hideFeedback("password")
      showToast("success", "You loged in succesfully!", .options = myToastOptions)
      # Check wchic usere have been loged in
      message(loged_user_id())
      
      switch_page("main_page")
    } else {
      showFeedbackDanger("username", "")
      showFeedbackDanger("password", "Wrong username or password")
    }
      })
  
  # Register Button - login_page
  observeEvent(input$register, {
    
    #clear inputs
    updateTextInput(inputId = "username_register", value = "")
    updateTextInput(inputId = "password1", value = "")
    updateTextInput(inputId = "password2", value = "")
    
    switch_page("register_page")
    })
  
  ### REGISTER PAGE ###
  
  # Are the passwords the same - condition
  same <- reactive(input$password1 == input$password2)
  
  # Are the passwords the same - register_page
  observeEvent(eventExpr = {
      input$password1 
      input$password2
      }, {
      req(input$password1, input$password2)
       if (same() == FALSE) {
      showFeedbackWarning("password1", "")
      showFeedbackWarning("password2", "Passwords are not the same!")
      } else {
      hideFeedback("password1")
      hideFeedback("password2")
      }
      })
  
  # Is username already taken - condition - register_page
  is_taken <- reactive(input$username_register %in% passwords()$username)
  
  # Is username already taken - validation - register_page
  observeEvent(input$username_register, {
    if (is_taken() == TRUE) {
      showFeedbackWarning("username_register", "This username is already taken!")
    } else {
      hideFeedback("username_register")
    }
  })
  
  # Register button - register_page
  observeEvent(input$register_confirm, {
    
    # Clear inputs
    updateTextInput(inputId = "username", value = "")
    updateTextInput(inputId = "password", value = "")
    
    # Clear preovius feedback
    hideFeedback("username")
    hideFeedback("password")
    
    if (same() == TRUE & is_taken() != TRUE & input$username_register != "" & input$password1 != "" & input$password2 != "") {
      showToast("success", "You registered succesfully!", .options = myToastOptions)
      
      # Adding new registered user to saved_passwords
      new_user <- new_user_row(input$username_register, input$password1)
      passwords(rbind(passwords(), new_user))
      write_csv(passwords(), "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\saved_passwords.csv")
      
      # Adding new registered user to users_list
      ## user_password_registered <- isolate({paste0(input$username_register, input$password1)}) # <- would like to add this as a name of DF inside new_registered_user list.
      new_registered_user <- list(data.frame(date = c(as.Date(today())),
                                             rate = 0,
                                             day_comment = ""))
      users_list(append(users_list(), new_registered_user))
      saveRDS(users_list(), "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")
      
      
      switch_page("login_page")
    } else {
      NULL
    }
    })
  
  # Disable register_confirm button
  observeEvent({
      input$username_register
      input$password1
      input$password2
    }, {
      
    if (input$username_register == "" | input$password1 == "" | input$password2 == "") {
      shinyjs::disable("register_confirm")
    } else {
      shinyjs::enable("register_confirm")
    }
  })
  
  # Back button - register_page
  observeEvent(input$back, {
    
    # Clear inputs
    updateTextInput(inputId = "username", value = "")
    updateTextInput(inputId = "password", value = "")
    
    # Clear previou feedback
    hideFeedback("username")
    hideFeedback("password")
    
    switch_page("login_page")
  })
  
  ### MAIN PAGE ###
  
  # Logout Button - main_page
  observeEvent(input$logout, {
    # Clear inputs
    updateTextInput(inputId = "username", value = "")
    updateTextInput(inputId = "password", value = "")
    
    # Clear previous feedback
    hideFeedback("username")
    hideFeedback("password")
    
    switch_page("login_page")
    })
  
  # Important Button - main_page (show / hide)
  observeEvent(input$important_btn, {
    
    if(input$important_btn %% 2 == 0){
      shinyjs::hide(id = "important_date")
      shinyjs::hide(id = "important_comment")
      shinyjs::hide(id = "add_important_btn")
    }else{
      shinyjs::show(id = "important_date")
      shinyjs::show(id = "important_comment")
      shinyjs::show(id = "add_important_btn")
    }
    
  })
  
  
  
  # Add button - main_page
    new_day_rate <- reactive(
      data.frame(
        date = input$date,
        rate = input$day_rate,
        day_comment = input$comment)
      )
    
    #choosen_user <- reactive(users_list()[[loged_user_id()]])
    
  observeEvent(input$add_btn, {
    
    cache$saved_users[[loged_user_id()]] <- rbind(cache$saved_users[[loged_user_id()]], new_day_rate())
    saveRDS(cache$saved_users, "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")
  })
  
  output$test_table <- renderTable({
    cache$saved_users[loged_user_id()]
  })
  # Humor plot
  
  output$humor_plot <- renderPlotly({
    ggplotly(p)
  })
  
}

shinyApp(ui, server)