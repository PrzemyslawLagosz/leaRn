ui = dashboardPage(
  dashboardHeader(
    title = "My Awesome Dashboard",
    tags$li(class = "dropdown",
            tags$li(class = "dropdown", textOutput("logged_user"), style = "padding-top: 15px; padding-bottom: 15px; color: #fff;"),
            tags$li(class = "dropdown", actionLink("login", textOutput("logintext"))))
  ), 
  dashboardSidebar(), 
  dashboardBody())

server = function(input, output, session) {
  logged_in <- reactiveVal(FALSE)
  
  # switch value of logged_in variable to TRUE after login succeeded
  observeEvent(input$login, {
    logged_in(ifelse(logged_in(), FALSE, TRUE))
  })
  
  observeEvent(input$login,{
    message(logged_in())
  })
  
  # show "Login" or "Logout" depending on whether logged out or in
  output$logintext <- renderText({
    if(logged_in()) return("Logout here.")
      return("Login here")
  })
  
  # show text of logged in user
  output$logged_user <- renderText({
    if(logged_in()) return("User 1 is logged in.")
    return("")
  })
  
}

shinyApp(ui = ui, server = server)