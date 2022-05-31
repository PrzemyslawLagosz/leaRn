# https://shiny.rstudio.com/articles/overview.html

# # get shiny, DBI, dplyr and dbplyr from CRAN
# install.packages("shiny")
# install.packages("DBI")
# install.packages("dplyr")
# install.packages("dbplyr")
# 
# # get pool from GitHub, since it's not yet on CRAN
# devtools::install_github("rstudio/pool")

library(pool)
library(dplyr)
library(shiny)
library(DBI)


my_db <- dbPool(
  RMySQL::MySQL(), 
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest"
)

# get the first 5 rows:
my_db %>% tbl("City") %>% head(5)

### SQL Injection ###

ui <- fluidPage(
  textInput("ID", "Enter your ID:", "5"),
  tableOutput("tbl")
)

server <- function(input, output, session) {
  output$tbl <- renderTable({
    conn <- dbConnect(
      drv = RMySQL::MySQL(),
      dbname = "shinydemo",
      host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
      username = "guest",
      password = "guest")
    on.exit(dbDisconnect(conn), add = TRUE)
    query <- paste0("SELECT * FROM City WHERE ID = '", input$ID, "';") ## NOT GOOD CUZ ' OR 1=1 OR ' will show all records
    dbGetQuery(conn, query)
  })
}

shinyApp(ui, server)


library(shiny)
library(DBI)

ui <- fluidPage(
  p("Enter up to three IDs:"),
  textInput("ID1", "First ID:", "5"),
  textInput("ID2", "Second ID:", ""),
  textInput("ID3", "Third ID:", ""),
  tableOutput("tbl")
)

server <- function(input, output, session) {
  output$tbl <- renderTable({
    conn <- dbConnect( # Konektor z bazą danych
      drv = RMySQL::MySQL(),
      dbname = "shinydemo",
      host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
      username = "guest",
      password = "guest")
    on.exit(dbDisconnect(conn), add = TRUE) # Rozłączenie z bazą danych gdy zamykamy apke
    sql <- "SELECT * FROM City WHERE ID = ?id1 OR ID = ?id2 OR ID = ?id3;" # Stworzenie SQL query by wykorzystać w sqlInterpolate()
    query <- sqlInterpolate(conn, sql, id1 = input$ID1,
                            id2 = input$ID2, id3 = input$ID3)
    dbGetQuery(conn, query)
  })
}

shinyApp(ui, server)