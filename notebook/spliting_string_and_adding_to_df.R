library(tidyverse)
library(stringr)

height <- as.data.frame(raw_fighter_details[c(1:5),2])

height <- as.data.frame(lapply(height, str_split, pattern = " ", simplify = TRUE)) # teraz działa xD?

colnames(height) <- c("Foots", "Inches")

height <- as.data.frame(height)

# To nie działą i podmienia wartosci w każdej kolumnie na pierwszą wartość. Dlaczego nie wiem

height[,1] <- lapply(height[,1], gsub, pattern = "*\'", replacement = "")
height[,2] <- lapply(height[,2], gsub, pattern = "*\"", replacement = "")

height[,c(1:2)] <- lapply(height[,c(1:2)], as.numeric)

df <- structure(list(Foots = c("6'", "5'", "6'", "6'", "6'"), 
                     Inches = c("3\"", "11\"", "0\"", "5\"", "1\"")), 
                     class = "data.frame", row.names = c(NA, -5L))

# Wersja z Vapply działa
df[,1] <- vapply(df[,1], gsub, pattern = "\'", replacement = "", FUN.VALUE = character(1))
df[,2] <- vapply(df[,2], gsub, pattern = "\"", replacement = "", FUN.VALUE = character(1))

df <- df %>%
  select("Inches", "Foots")
