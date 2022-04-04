library(shiny)
library(vroom)
library(tidyverse)

injuries <- vroom::vroom("neiss/injuries.tsv.gz")
products <- vroom::vroom("neiss/products.tsv")
population <- vroom::vroom("neiss/population.tsv")


# Ograniczenie wypadkow tylko do tych co zdazyly sie w toalecie
selected <- injuries %>%
  filter(prod_code == 649)

nrow(selected)

# Policzenie poszczelnych miejsc wypadku. wt (waga) -> pozwala przeskalowac tabele jak wygladala by ilosc dla calej populaci USA
selected %>% count(location, wt = weight, sort = TRUE)
selected %>% count(body_part, wt = weight, sort = TRUE)
selected %>% count(diag, wt = weight, sort = TRUE)


summary <- selected %>%
  count(age, sex, wt = weight)

summary %>%
  ggplot(aes(x = age, y = n, colour = sex)) +
  geom_point() +
  geom_line() +
  labs(y = "Estimated number of injuries")


# One problem with interpreting this pattern is that we know that there are fewer older people than younger people,
# so the population available to be injured is smaller. We can control for this by comparing the number of people injured
# with the total population and calculating an injury rate. Here I use a rate per 10,000.

summary <- selected %>%
  count(age, sex, wt = weight) %>%
  left_join(population, by = c("age", "sex")) %>%
  mutate(rate = n / population * 1e4)

summary %>%
  ggplot(aes(x = age, y = rate, colour = sex)) +
  geom_point() +
  geom_line() +
  labs(y = "Injuries per 10,000 people")

# combination of forcats functions: I convert the variable to a factor, order by the frequency of the levels,
# and then lump together all levels after the top 5.
# `fct_infreq` ustawia levele faktora według czestotliwosci ich wystepowania
# `fct_lump_n` (ang. lumb - bryła, lump together - zbić razem). Lączy wszystkie poziomy w jedną ktore nie spelniaja warunku top5 (n=5)

injuries %>%
  mutate(diag = fct_lump_n(fct_infreq(diag), n = 5)) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))


injuries %>%
  mutate(body_part = fct_lump_n(fct_infreq(body_part), n = 5)) %>%
  group_by(body_part) %>%
  summarise(n = as.integer(sum(weight)))


injuries %>%
  mutate(location = fct_lump_n(fct_infreq(location), n = 5)) %>%
  group_by(location) %>%
  summarise(n = as.integer(sum(weight)))


# Dlaczego {{}} i :=

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}
