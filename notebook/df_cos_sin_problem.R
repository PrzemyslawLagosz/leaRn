df <- data.frame(first = replicate(5,1),
                  second = replicate(5,1),
                  third = replicate(5,1))


seq_along(tmp)

base_angle <- 360/length(tmp)

tmp_lista <- list(first = replicate(5,1),
                  second = replicate(5,1),
                  third = replicate(5,1))

###
empty_df <- data.frame()

column_names <- names(tmp)
seq_along(column_names)



wtf_cos <- map2_dfc(.x= tmp, .y=seq_along(column_names),
         ~ round(.x * cos_my(base_angle *.y ), 2))

nm_cos <- str_c(names(wtf_cos), "_x")
colnames(wtf_cos) <- nm_cos

wtf_cos$id <- replicate(nrow(wtf_cos),seq(1:nrow(wtf_cos)))

wtf_sin <- map2_dfc(.x= tmp, .y=seq_along(column_names),
         ~ round(.x * sin_my(base_angle *.y ), 2))


nm_sin <- str_c(names(wtf_sin), "_y")
colnames(wtf_sin) <- nm_sin

wtf_sin$id <- replicate(nrow(wtf_sin),seq(1:nrow(wtf_sin)))
wtf_sin

wtf <- inner_join(wtf_cos,wtf_sin, by="id")

wtf <- subset(wtf, select = -c(id))

wtf <- subset(wtf, select = sort(colnames(wtf)))


### FUNCKJA! ###

df_to_coordinates <- function(df) {
  
  base_angle <- 360/length(df)
  
  column_names <- names(df)
  
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

tmp <- df_to_coordinates(df_normalized)

### PROBLEM SOLVED, function moved to my_functions.r script ###