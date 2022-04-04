library(ggplot2)
library(tidyverse)
library(readr)
library(dplyr)
source("C:/Users/Przemo/Documents/R/leaRn/Shiny/my_functions.R")

df_ones <- as.data.frame(matrix(data = replicate(ncol(df),1), nrow = 1))
colnames(df_ones) <- colnames(df)

df <- df_n
#Chec which columns cointain numeric values, but I don't want all of them co I'll do it by hand
numeric_cols <- unlist(lapply(raw_fighter_details_EU, is.numeric))        # Identify numeric columns
numeric_cols

df_n <- raw_fighter_details_EU[,c(2,3,4,7,10,11,12,14)]
df_n <- normalize_df(df_n)
df_n <- df_to_coordinates(df_n)


df <- data.frame(first_x = c(1:5),
                 first_y = c(1:5),
                 second_x = c(1:5)*2,
                 second_y = c(1:5)*2)

ggplot()+
  geom_point(aes(x= df[1,"first_x"], y= df[1,"first_y"]))+
  geom_point(aes(x= df[1,"second_x"], y= df[1,"second_y"]))

list_of_geoms <- list()

column <- 1

for (x in 1:(length(df)/2)) {
  
  new_geom <- geom_point(aes(x= df[1,column], y= df[1,column+1]))
  
  list_of_geoms <- append(list_of_geoms, new_geom)
  
  column <- column+2
}


a <- geom_point(aes(x=0, y=0), color = "red")
b <- geom_point(aes(x=2, y=2), color = "blue")
c <- geom_point(aes(x=6, y=6), color = "yellow")

list_of_geoms <- append(list_of_geoms,c(a,b,c))

ggplot() + list_of_geoms


generate_geom_points_list <- function(df, row, column = 1) {
  
  result <- list()
  nm     <- names(df)
  while(column < length(df)) {
    result <- c(result, 
                geom_point(data = df[row,],
                           aes_string(x = nm[column], y = nm[column + 1])))
    column <- column + 2
  }
  result
}

# Tue Mar 08 09:55:44 2022 ------------------------------

generate_geom_texts_list <- function(df, row, column = 1) {
  
  result <- list()
  nm     <- colnames(df)
  while(column < length(df)) {
    labelka <- str_split(colnames(df)[column], pattern = "_")[[1]][1]
    result <- c(result, 
                geom_text(data = df[row,],
                          aes_string(x = nm[column], 
                                     y = nm[column + 1]),
                          nudge_y = 0.1,
                          label = labelka))
    column <- column + 2
  }
  result
}

# Wed Mar 09 13:23:17 2022 ------------------------------
df <- df_n_cords

generate_geom_texts_list <- function(df, row, column = 1) {
  #Because df is already after df_to_coordinates transformation, matrix has to be divaded by two
  #then df_to_coordinates() will produce same amount of columns, eqult to ncol(df)
  
  df_ones <- as.data.frame(matrix(data = replicate((ncol(df)/2),1), nrow = 1))
  df_ones_coords <- df_to_coordinates(df_ones)
  colnames(df_ones_coords) <- colnames(df)
  
  df <- df_ones_coords
  
  result <- list()
  nm     <- colnames(df)
  while(column < length(df)) {
    #labelka <- str_split(colnames(df)[column], pattern = "_")[[1]][1]
    labelka <- gsub(colnames(df)[column], pattern = "_x", replacement = "")
    result <- c(result, 
                geom_text(data = df[row,],
                          aes_string(x = nm[column], 
                                     y = nm[column + 1]),
                          nudge_y = 0.05,
                          label = labelka))
    column <- column + 2
  }
  result
  
}
# Wed Mar 09 13:23:22 2022 ------------------------------


list_of_geoms <- generate_geom_points_list(df, row=1)

df_n <- normalize_df(df)
df_n <- df_to_coordinates(df_n)

list_of_geom_points <- generate_geom_points_list(df_n, row=1)
list_of_geom_segments <- generate_geom_segments_list(df_n, row=1)
list_of_geom_texts <- generate_geom_texts_list(df_n, row=1)

central_point <- geom_point(aes(x=0, y=0), color = "red")

ggplot() +
  #central_point+
  list_of_geom_points + 
  list_of_geom_segments[c(1:8)] + 
  list_of_geom_texts

### TEST ###
head(df)

df <- df_n


df_n <- df_normalized %>%
  transmute(
    Height_x  = round(Height*cos_my(45), 2),
    Height_y  = round(Height*sin_my(45), 2),
    Weight_x  = round(Weight*cos_my(45*2), 2),
    Weight_y  = round(Weight*sin_my(45*2), 2),
    Reach_x   = round(Reach*cos_my(45*3), 2),
    Reach_y   = round(Reach*sin_my(45*3), 2))
