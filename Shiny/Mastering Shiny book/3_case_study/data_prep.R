library(tidyverse)
# install.packages('devtools')
# devtools::install_github("hadley/neiss")
library(neiss)
library(vroom)

dir.create("neiss")
#> Warning in dir.create("neiss"): 'neiss' already exists
download <- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
  download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
}
download("injuries.tsv.gz")
download("population.tsv")
download("products.tsv")

injuries <- vroom::vroom("neiss/injuries.tsv.gz")

top_prod <- injuries %>%
  filter(trmt_date >= as.Date("2017-01-01"), trmt_date < as.Date("2018-01-01")) %>%
  count(prod1, sort = TRUE) %>%
  filter(n > 5 * 365)

injuries %>%
  filter(trmt_date >= as.Date("2017-01-01"), trmt_date < as.Date("2018-01-01")) %>%
  semi_join(top_prod, by = "prod1") %>%
  mutate(age = floor(age), sex = tolower(sex), race = tolower(race)) %>%
  filter(sex != "unknown") %>%
  select(trmt_date, age, sex, race, body_part, diag, location, prod_code = prod1, weight, narrative) %>%
  vroom::vroom_write("neiss/injuries.tsv.gz")

products %>%
  semi_join(top_prod, by = c("code" = "prod1")) %>%
  rename(prod_code = code) %>%
  vroom::vroom_write("neiss/products.tsv")

population %>%
  filter(year == 2017) %>%
  select(-year) %>%
  rename(population = n) %>%
  vroom::vroom_write("neiss/population.tsv")
