#Clean version of geom_coords_stats_ggplot
library(ggplot2)
library(tidyverse)
library(readr)
library(dplyr)
source("C:/Users/Przemo/Documents/R/leaRn/Shiny/my_functions.R")

#[,c(2,3,4,7,10,11,12,14)]
raw_fighter_details_EU <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_EU.csv")
raw_fighter_details_USA <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_USA.csv")

df <- raw_fighter_details_EU[,c(2,3,4,7,10,11,12,14)]
colnames(df) <- sort(colnames(df))
df_n <- normalize_df(df)
df_n_cords <- df_to_coordinates(df_n)

## Matrix only with 1 values for test purposes
df_ones <- as.data.frame(matrix(data = replicate(ncol(df),1), nrow = 1))
colnames(df_ones) <- colnames(df)

# Alex Chambers
# Ashley Yoder



list_of_geom_points <- generate_geom_points_list(df_n_cords, row=1)
list_of_geom_segments <- generate_geom_segments_list(df_n_cords, row=1)
list_of_geom_texts <- generate_geom_texts_list(df_n_cords, row=1)

list_of_geom_points_2 <- generate_geom_points_list(df_n_cords, row=2)
list_of_geom_segments_2 <- generate_geom_segments_list(df_n_cords, row=2)
list_of_geom_texts_2 <- generate_geom_texts_list(df_n_cords, row=2)

ggplot() +
  #central_point+
  list_of_geom_points + 
  list_of_geom_segments +
  list_of_geom_texts +
  list_of_geom_points_2 +
  list_of_geom_segments_2 +
  theme(axis.title = element_blank(),
        plot.background=element_rect(fill="#f7f7f7"))

ggplot() +
  list_of_geom_texts

### Test koloru
ggplot() +
  geom_point(aes_string(x = 1, y = 2), colour = "red") +
  annotate('segment', x = 1, y = 2, xend = 5, yend = 7, inherit.aes = FALSE)
  #geom_segment(aes_string(x = 1, y = 2, xend = 5, yend = 7), size = 1, inherit.aes = TRUE)

