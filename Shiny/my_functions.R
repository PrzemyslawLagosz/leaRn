# To na maina BETA
sin_my <- function(x) {
  sin(x*(pi/180))
}

cos_my <- function(x) {
  cos(x*(pi/180))
}

# Takes a vector and normalize it. (0-1) range values
normalize <- function(x, na.rm = TRUE) {
  return((x- min(x)) /(max(x)-min(x)))
}

#df <- data franme
#approx_accuracy <- secend argument to the round() function

normalize_df <- function(df, approx_accuracy = 3) {
  
  df_normalized <- as.data.frame(lapply(df, normalize))
  df_normalized <- as.data.frame(sapply(df_normalized, round, 3))
  colnames(df_normalized) <- colnames(df)
  return(df_normalized)
}

# It takes DF, and multiplay column by cos_my(angle) and sin_my(angle), to get X and Y coords, respectively.
# angle = 360/(number of columns) eg. with df with ncol() = 3, it will be 120 degreesthen,
# 1st_column  * (angle*1), 2nd_column  * (angle*2), 3rd_column  * (angle*3), and so on...
df_to_coordinates <- function(df) {
  
  striped_col_names <- unlist(lapply(colnames(df), gsub, pattern = "_%", replacement = ""))
  #striped_col_names <- sort(striped_col_names)
  colnames(df) <- striped_col_names
  
  column_names <- names(df)
  
  base_angle <- 360/length(df)
  
  x_cords_df <- map2_dfc(.x= df, .y=seq_along(column_names),
                         ~ round(.x * cos_my(base_angle *.y ), 2))
  
  nm_cos <- str_c(names(x_cords_df), "_x")
  colnames(x_cords_df) <- nm_cos
  
  x_cords_df$id <- replicate(nrow(x_cords_df),seq(1:nrow(x_cords_df)))
  
  y_cords_df <- map2_dfc(.x= df, .y=seq_along(column_names),
                         ~ round(.x * sin_my(base_angle *.y ), 2))
  
  
  nm_sin <- str_c(names(y_cords_df), "_y")
  colnames(y_cords_df) <- nm_sin
  
  y_cords_df$id <- replicate(nrow(y_cords_df),seq(1:nrow(y_cords_df)))
  y_cords_df
  
  x_y_cords_df <- inner_join(x_cords_df,y_cords_df, by="id")
  
  x_y_cords_df <- subset(x_y_cords_df, select = -c(id))
  
  x_y_cords_df <- subset(x_y_cords_df, select = sort(colnames(x_y_cords_df)))
  
  return(x_y_cords_df)
}

# It take DF with coordinates and place points evenly in the circle.
generate_geom_points_list <- function(df, row, column = 1, color = 'black') {
  
  result <- list()
  nm     <- names(df)
  while(column < length(df)) {
    result <- c(result, 
                geom_point(data = df[row,],
                           aes_string(x = nm[column], y = nm[column + 1]), color = color))
    column <- column + 2
  }
  result
}

# It take DF with coordinates and connect points placed evenly in the circle.
generate_geom_segments_list <- function(df, row, column = 1, color = 'black') {
  #df is made my df_to_coordinates function
  
  result <- list()
  nm     <- names(df)
  while(column < length(df)) {
    
    if (column == length(df)-1){
      result <- c(result, 
                  geom_segment(data = df[row,],
                               aes_string(x    = nm[column], 
                                          y    = nm[column + 1],
                                          xend = nm[column + 2 - length(df)], 
                                          yend = nm[column + 3 - length(df)]),
                               color = color))
    } else {
    
    result <- c(result, 
                geom_segment(data = df[row,],
                             aes_string(x    = nm[column], 
                                        y    = nm[column + 1],
                                        xend = nm[column + 2], 
                                        yend = nm[column + 3]),
                              color = color))
    }
    column <- column + 2
  }
  result
}

# It take DF with coordinates and placed labeks evenly in the circle.
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
