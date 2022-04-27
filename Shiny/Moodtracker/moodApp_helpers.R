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

## TO RESTET
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
# readRDS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")

mood_logo_200 <- tags$a(tags$img(src = "mood_logo.png", height = "200", width = "200"))
mood_logo_150 <- tags$a(tags$img(src = "mood_logo.png", height = "150", width = "150"))

saved_passwords <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\saved_passwords.csv")
saved_users_list <- readRDS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")


new_user_row <- function(username, password) {
  newUserRow <- c(username, password, paste0(username, password))
}

modal_confirm <- modalDialog(
  "Are you sure you want to override this day?",
  title = "This day is already reated",
  footer = tagList(
    actionButton("cancel_modal_btn", "Cancel"),
    actionButton("ok_modal_btn", "Override it", class = "btn btn-primary")
  )
)

login_page <-
  fluidRow(
    column(4),
    column(4,
           tags$div(
             class = "well",
             textInput("username", "User name:", placeholder = "Your username", value = ""),
             passwordInput("password", "Password:", placeholder = "Password", value = ""),
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
      plotlyOutput("humor_plot")
      #,tableOutput("test_table")
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