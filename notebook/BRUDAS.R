library(ggplot2)
library(tidyverse)
library(glue)

freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
  df <- data.frame(
    x = c(x1, x2),
    g = c(rep("x1", length(x1)), rep("x2", length(x2)))
  )
  
  ggplot(df, aes(x, colour = g)) +
    geom_freqpoly(binwidth = binwidth, size = 1) +
    coord_cartesian(xlim = xlim)
}

x1 <- rnorm(100, mean = 0, sd = 0.5)
x2 <- rnorm(200, mean = 0.15, sd = 1)


freqpoly(x1, x2)


df <- data.frame(
  x = c(x1, x2),
  g = c(rep("x1", length(x1)), rep("x2", length(x2))))


df1 <- data.frame(x = seq(1,100,2))
df2 <- data.frame(x = seq(1,100,3))

df3 <- semi_join(df1,df2, by='x')

injuries %>%
  pull(diag) %>%
  sample(10)


  max(length(unique(selected$diag)),
      length(unique(selected$body_part)),
      length(unique(selected$location)))

  
test_value <- 1
maximus <- 71

(test_value %% maximus) + 1


h <- function(x) x * 2
g <- function(x) h(x)
f <- function(x) g(x)


k <- 1

while (k<16) {
  
  if (k == 15) {
    print(paste("K jest rowne - dupa", k))
  } else {
  
  print(paste("K jest rowne", k))
  }
  k <- k+2
}

# Wed Mar 09 13:52:25 2022 ------------------------------

str_split(colnames(df)[7], pattern = "_")[[1]][1]

gsub(colnames(df)[7], pattern = "_x", replacement = "")

