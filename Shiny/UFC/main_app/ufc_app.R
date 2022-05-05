library(shiny)
library(ggplot2)
library(tidyverse)
#library(readr)
library(dplyr)
#library(shinydashboard)
library(semantic.dashboard)
library(shiny.semantic)
library(DT)

source("C:/Users/Przemo/Documents/R/leaRn/Shiny/my_functions.R")

raw_fighter_details_EU <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_EU.csv")
raw_fighter_details_USA <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_USA.csv")

# df <- raw_fighter_details_EU[, c(2, 3, 4, 7, 10, 11, 12, 14)]


title <- tags$a(tags$img(src = "ufc_logo.jpg", height = "60", width = "90"))


# icon = icon("settings"), show_counter = FALSE,
ui <-  dashboardPage (
  dashboardHeader(title = title, toggle("theme", "Dark mode ", is_marked = FALSE), icon(class="moon")
                  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Fighter vs Fighter", tabName = "fighters", icon = icon("diamond")),
      menuItem("Weight comparision", tabName = "cars", icon = icon("settings")),
      menuItem("About", tabName = "about", icon = icon("info"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "fighters",
              fluidRow(
                column(width = 14,
                       box(title = "Decription", title_side = "top left", ribbon = FALSE,
                           p("Plot below display the choosen statistics of 2 fighters in maner to comparise them."),
                           p("Application is based on data, that are avalible in the About tab. 
                             I also described featuers there, that I would like to implement or improve."),
                           p(h4("About plot")),
                           hr(), 
                           p("Plot is renderd dynamicly, based on choosen weight class, fighters, and characteristics. 
                             Functions which generate the plot are in my repository in leaRn/Shiny/my_functions.R file."),
                           p("Short description: "),
                           p("Script takes choosen columns from dataset and normalize them to range from 0 to 1, due to display characteristics evenly on the plot.
                             Then, based of HOW MANY characteristics are choosen it split the 360 degree evenly, 
                             and with the help of sinus and cosinus functions it calculate the X an Y coordinates of each point.
                             Later on, based on this coordinates geom_point and geom_segment is generated.
                             Originally plot is suposed to show a short description of each point, but I could't find and fix that bug. 
                             The example is presented in About tab")
                           )
                       ),
                column(width = 2,
                       box(title = "Settings", title_side = "top left", ribbon = FALSE,
        
                           multiple_radio("units", "Choose Units", choices = c("EU", "USA"))
                           )
                       )
              ),
              sidebar_layout(
                sidebar_panel(
                  
                       box(title="Stats", title_side = "top left", ribbon = FALSE, collapsible = FALSE,
                           div(checkbox_input("Height", "Height", is_marked = TRUE)),
                           div(checkbox_input("Weight", "Weight", is_marked = TRUE)),
                           div(checkbox_input("Reach", "Reach", is_marked = TRUE)),
                           div(checkbox_input("SLpM", "Significant Strikes Landed per Minute", is_marked = TRUE)),
                           div(checkbox_input("Str_Def", "Significant Strike Defence (the % of opponents strikes that did not land)", is_marked = TRUE)),
                           div(checkbox_input("Sub_Avg", "Average Submissions Attempted per 15 minutes", is_marked = TRUE)),
                           div(checkbox_input("TD_Acc", "Takedown Accuracy", is_marked = TRUE)),
                           div(checkbox_input("TD_Avg", "Average Takedowns Landed per 15 minutes", is_marked = TRUE))),
                       
                       box(title="Weight Class", title_side = "top left", ribbon = FALSE, collapsible = FALSE,
                           uiOutput("weight_class_selector")
                           ),
                
                       box(title="Fighter 1 - Red", title_side = "top left", ribbon = FALSE, collapsible = FALSE,
                           uiOutput("fighter_1_selector")
                           ),
                
                       box(title="Fighter 2 - Blue", title_side = "top left", ribbon = FALSE, collapsible = FALSE,
                           uiOutput("fighter_2_selector")
                           )
                       ),
                
              main_panel(
                
                column(width = 6,
                       box(title="Plot", title_side = "top left", ribbon = FALSE,
                           plotOutput("star_plot")
                           )
                       ),
                
                column(width = 6,
                       box(title="Legend", title_side = "top left", ribbon = FALSE,
                           div(
                            div("Height - Height of the fighter"),
                            div("Reach - Reach of the arms"),
                            div("Weight - Weight of the fighter"),
                            div("SLpM - Significant Strikes Landed per Minute"),
                            div("Str. Def. - Significant Strike Defence (the % of opponents strikes that did not land)"),
                            div("Sub. Avg. - Average Submissions Attempted per 15 minutes"),
                            div("TD Acc. - Takedown Accuracy"),
                            div("TD Avg. - Average Takedowns Landed per 15 minutes")
                             
                           )
                       )
                       )
              )
      )),
      
      
      tabItem(tabName = "cars",
              p("NOTHING HERE")),
      
      tabItem(tabName = "about",
              fluidRow(
                column(width = 16,
                  box(title = "Decription", title_side = "top left", ribbon = FALSE,
                      p("Whole application is based only on data shown in the Data Table below."),
                      p(h4("TO DO: ")),
                      p(h5("Overall")),
                      p("Implement of the dark mode. With shiny.semantic library, changing theme of the app only change the color of the boxes' descriptions"),
                      p(h5("Fighter vs fighter tab")),
                      p("Fix the points' description on plot."),
                      p("Split the Legend box below, and make the abbreviations in bold font.")
                  
                )
              ),
              fluidRow(
                column(width = 16,
                  box(
                    DTOutput(outputId = "data_table")
                ))
              ))
              
      ) #tabItems
    )))#dashboardPage
  


server <- function(input, output, session) {
  
  observeEvent(input$v_fighter_1_selector, message(input$v_fighter_1_selector))
  
  main_df <- reactive(if (input$units == "EU") {
      raw_fighter_details_EU
    } else {
     raw_fighter_details_USA
    }
  )
  
  output$weight_class_selector <- renderUI({
    
    selected_columns <- c(2, 3, 4, 7, 10, 11, 12, 14)
    
    if (input$units == "EU") {
      my_label <- "Kilograms"
    } else {
      my_label <- "Funts"
    }
    selectInput("v_weight_class_selector", label = my_label, selected = NULL, choices = sort(unique(main_df()$Weight)))})
  
  output$fighter_1_selector <- renderUI({
    
    fighter_1_selector_df <- main_df() %>%
      filter(Weight == input$v_weight_class_selector) %>%
      select(fighter_name) %>%
      distinct() %>%
      arrange(fighter_name)
    
    selectInput("v_fighter_1_selector", "Fighter 1", selected = NULL, choices = fighter_1_selector_df$fighter_name)
  
    })
  
  output$fighter_2_selector <- renderUI({
    
    fighter_2_selector_df <- main_df() %>%
      filter(Weight == input$v_weight_class_selector) %>%
      select(fighter_name) %>%
      filter(fighter_name != input$v_fighter_1_selector) %>%
      distinct() %>%
      arrange(fighter_name)
    
    selectInput("v_fighter_2_selector", "Fighter 2", selected = NULL, choices = fighter_2_selector_df$fighter_name)
    
  })
  
  # Tue Mar 15 15:20:04 2022 ------------------------------
  
  output$star_plot <- renderPlot({
    
    
    
    fighter_1_row <- reactive(which(raw_fighter_details_EU$fighter_name == input$v_fighter_1_selector))
    fighter_2_row <- reactive(which(raw_fighter_details_EU$fighter_name == input$v_fighter_2_selector))
    
    
    stats_selected <- reactive(c(input$Height,input$Weight, input$Reach, input$SLpM, input$Str_Def, input$Sub_Avg, input$TD_Acc, input$TD_Avg))
    
    df <- main_df()[,c(2,3,4,7,10,11,12,14)]
    df <- df[,stats_selected(), drop = F]
    colnames(df) <- sort(colnames(df))
    df_n <- normalize_df(df)
    df_n_cords <- df_to_coordinates(df_n)
    
    ## Matrix only with 1 values for test purposes
    df_ones <- as.data.frame(matrix(data = replicate(ncol(df),1), nrow = 1))
    colnames(df_ones) <- colnames(df)
    
    list_of_geom_points <- generate_geom_points_list(df_n_cords, row= fighter_1_row(), color = "red")
    list_of_geom_segments <- generate_geom_segments_list(df_n_cords, row= fighter_1_row(), color = "red")
    list_of_geom_texts <- generate_geom_texts_list(df_n_cords, row= fighter_1_row())
    
    list_of_geom_points_2 <- generate_geom_points_list(df_n_cords, row= fighter_2_row(), color = "blue")
    list_of_geom_segments_2 <- generate_geom_segments_list(df_n_cords, row= fighter_2_row(), color = "blue")
    #list_of_geom_texts_2 <- generate_geom_texts_list(df_n_cords, row= fighter_2_row())
    
    ggplot() +
      #central_point+
      list_of_geom_points + 
      list_of_geom_segments +
      list_of_geom_texts +
      list_of_geom_points_2 +
      list_of_geom_segments_2 +
      theme(axis.title = element_blank())
  })
  
  output$data_table <- renderDataTable(raw_fighter_details_EU, width = "100%")
}

shinyApp(ui, server)