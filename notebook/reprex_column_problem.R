library(purrr)
library(stringr)

reprex_df <- structure(list(Height = c(190, 180, 183, 196, 185), 
                            Weight = c(120, 77, 93, 120, 84), 
                            Reach = c(193, 180, 188, 203, 193),
                            SLpM = c(2.45, 3.8, 2.05, 7.09, 3.17),
                            `Str_Def %` = c(58, 56, 55, 34, 44), 
                            TD_Avg = c(1.23, 0.33, 0.64, 0.91, 0), 
                            `TD_Acc %` = c(24, 50, 20, 66, 0), 
                            Sub_Avg = c(0.2, 0, 0, 0, 0)), row.names = c(NA, -5L), 
                            class = c("tbl_df", "tbl", "data.frame"))

temp <- apply(reprex_df[,1], function(x) x*cos_my(60), MARGIN = 2)

temp

empty_df <- data.frame(first_column = replicate(length(temp),1))

for (x in 1:8) {
  
  temp <- apply(df[,x], function(x) round(x*cos_my((360/8)*x),2), MARGIN = 2)
  
  column <- paste0("Column_",x)
  
  empty_df <- mutate(empty_df, column = temp)
}

empty_df$dupa <- 5

tmp <- data.frame(first = replicate(5,1),
                  second = replicate(5,1))


for (x in 1:8) {
  print(reprex_df[,x]*(round(x*cos_my((360/8)*x),2)))
  
  
}

tmp_2 <- data.frame()

nm1 <- names(tmp)
nm_cos <- str_c(names(tmp), "_x")
nm_sin <- str_c(names(tmp), "_y")
tmp[nm_cos] <- map2(.x= tmp, .y= seq_along(nm1),
                          ~ round(.x * cos_my(45 *.y ), 2))
tmp[nm_sin] <- map2(tmp[nm1], seq_along(nm1), 
                          ~ round(.x * sin_my(45 *.y ), 2))


###

tmp <- data.frame(first = replicate(5,1),
                  second = replicate(5,1),
                  third = replicate(5,1))
####

as.data.frame(map2(.x= tmp, .y=seq_along(tmp), ~ .x * .y))

df_to_coordinates <- function(df) {
  
  base_angle <- 360/length(df)
  
  column_names <- names(df)
  
  nm_cos <- str_c(names(df), "_x")
  nm_sin <- str_c(names(df), "_y")
  
  df[nm_cos] <- map2(.x= df, .y= seq_along(column_names),
                      ~ round(.x * cos_my(base_angle *.y ), 2))
  df[nm_sin] <- map2(df[column_names], seq_along(column_names), 
                      ~ round(.x * sin_my(base_angle *.y ), 2))
  
  
}

tmp_2 <- df_to_coordinates(df_normalized)

as.data.frame(tmp_2)

### Moj sposób z df * df ###


