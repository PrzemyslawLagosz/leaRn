library(shiny)
library(vroom)
library(tidyverse)
library(ggplot2)


# Funkcja przyjmuje DF, i nazwe kolumny
# combination of forcats functions: I convert the variable to a factor, order by the frequency of the levels,
# and then lump together all levels after the top 5.
# `fct_infreq` ustawia levele faktora według czestotliwosci ich wystepowania
# `fct_lump_n` (ang. lumb - bryła, lump together - zbić razem). Lączy wszystkie poziomy w jedną ktore nie spelniaja warunku top5 (n=5)

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

ui <- fluidPage(
  fluidRow(
    column(
      6,
      selectInput("code", "Product",
        choices = setNames(products$prod_code, products$title),
        width = "100%"
      )
    ),
    column(
      2,
      numericInput("rows", "Number of rows", value = 5, min = 1)
    ),
    column(
      2,
      selectInput("y",
        "Y axis",
        choices = c("rate", "count")
      )
    )
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  fluidRow(
    column(
      2,
      actionButton("previous", "Previous story")
    ),
    column(
      2,
      actionButton("next", "Next story")
    ),
    column(
      8,
      textOutput("narrative")
    )
  )
)

server <- function(input, output, session) {

  # Przefiltrowanie DF na podstawie miejsca uszkodzenia
  selected <- reactive({
    # browser()
    injuries %>% filter(prod_code == input$code)
  })

  # Find the maximum possible of rows.

  max_no_rows <- reactive(
    max(
      length(unique(selected()$diag)),
      length(unique(selected()$body_part)),
      length(unique(selected()$location))
    )
  )

  # Update the maximum value for the numericInput based on max_no_rows().

  observeEvent(input$code, {
    updateNumericInput(session, "rows", max = max_no_rows())
  })

  # Bo jak było wybrane np.5 to pokazywalo 6 rzedów itd
  table_rows <- reactive(input$rows - 1)

  output$diag <- renderTable(count_top(selected(), diag, table_rows()), width = "100%")

  output$body_part <- renderTable(count_top(selected(), body_part, table_rows()), width = "100%")

  output$location <- renderTable(count_top(selected(), location, table_rows()), width = "100%")

  # Policz ile osob jest w danej grupie, uwzgledniajac wage
  # dołacz DF = population
  # liczy procent a potem mnozy razy 10,000 by uzyskac srendnia ilosc przypadków na 10,000 osobników

  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })

  # Renderuje wykres, w zaleznosci od wybranego inputu zmiana na osi Y

  output$age_sex <- renderPlot(
    {
      if (input$y == "rate") {
        summary() %>%
          ggplot(aes(x = age, y = rate, colour = sex)) +
          geom_line() +
          labs(y = "Injuries per 10,000 people") +
          xlim(0, 80)
      } else {
        summary() %>%
          ggplot(aes(x = age, y = n, colour = sex)) +
          geom_line(na.rm = TRUE) +
          labs(y = "Estimated number of injuries") +
          xlim(0, 80)
      }
    },
    res = 96
  )

  # Lista bo 2 eventy trigerujące. Akction button, oraz zmiana sampled() (czyli wybranie innej kategorii)
  # wyciąga kolumne jako wektor nastepnie losuje z niego jedną wartość


  narrative_sample <- eventReactive(
    list(input$previous, selected()),
    selected() %>% pull(narrative) %>% sample(1)
  )

  output$narrative <- renderText(narrative_sample())
}

shinyApp(ui, server)
