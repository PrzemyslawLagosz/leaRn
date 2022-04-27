# Script to generate star plot for the first time -  by hand.

library(ggplot2)
library(tidyverse)
source("C:/Users/Przemo/Documents/R/leaRn/Shiny/my_functions.R")

df <- raw_fighter_details_EU[,c(2,3,4,7,10,11,12,14)]
colnames(df) <- sort(colnames(df))


df_normalized <- normalize_df(df)

degrees <- 45*c(1:8)

df_n <- df_normalized %>%
   transmute(
     Height_x  = round(Height*cos_my(45), 2),
     Height_y  = round(Height*sin_my(45), 2),
     Weight_x  = round(Weight*cos_my(45*2), 2),
     Weight_y  = round(Weight*sin_my(45*2), 2),
     Reach_x   = round(Reach*cos_my(45*3), 2),
     Reach_y   = round(Reach*sin_my(45*3), 2),
     SLpM_x    = round(SLpM*cos_my(45*4), 2),
     SLpM_y    = round(SLpM*sin_my(45*4), 2),
     Str_Def_x = round(`Str_Def %`*cos_my(45*5), 2),
     Str_Def_y = round(`Str_Def %`*sin_my(45*5), 2),
     TD_Avg_x  = round(TD_Avg*cos_my(45*6), 2),
     TD_Avg_y  = round(TD_Avg*sin_my(45*6), 2),
     TD_Acc_x  = round(`TD_Acc %`*cos_my(45*7), 2),
     TD_Acc_y  = round(`TD_Acc %`*sin_my(45*7), 2),
     Sub_Avg_x  = round(Sub_Avg*cos_my(45*8), 2),
     Sub_Avg_y  = round(Sub_Avg*sin_my(45*8), 2))

theme_set(theme_bw())

df_n <- df_to_coordinates(df_normalized)


ggplot(df_coords[1,])+
  geom_point(aes(x=0, y=0), color = "red")+
  
  geom_point(aes(x= df_n[1,1], y= df_n[1,2]))+
  geom_text(aes(x= Height_x, y= Height_y, label = "Height"), nudge_y = 0.1)+
  
  geom_point(aes(x= Weight_x, y= Weight_y))+
  geom_text(aes(x= Weight_x, y= Weight_y, label = "Weight"), nudge_y = 0.1)+
  
  geom_point(aes(x= Reach_x, y= Reach_y))+
  geom_text(aes(x= Reach_x, y= Reach_y, label = "Reach"), nudge_y = 0.1)+
  
  geom_point(aes(x= SLpM_x, y= SLpM_y))+
  geom_text(aes(x= SLpM_x, y= SLpM_y, label = "SLpM"), nudge_y = 0.1)+
  
  geom_point(aes(x= Str_Def_x, y= Str_Def_y))+
  geom_text(aes(x= Str_Def_x, y= Str_Def_y, label = "Str_Def"), nudge_y = 0.1)+
  
  geom_point(aes(x= TD_Avg_x, y= TD_Avg_y))+
  geom_text(aes(x= TD_Avg_x, y= TD_Avg_y, label = "TD_Avg"), nudge_y = 0.05)+
  
  geom_point(aes(x= TD_Acc_x, y= TD_Acc_y))+
  geom_text(aes(x= TD_Acc_x, y= TD_Acc_y, label = "TD_Acc"), nudge_y = 0.1)+
  
  geom_point(aes(x= Sub_Avg_x, y= Sub_Avg_y))+
  geom_text(aes(x= Sub_Avg_x, y= Sub_Avg_y, label = "Sub_Avg"), nudge_y = 0.1)+
  
  geom_segment(aes(x= Height_x, xend= Weight_x, y= Height_y, yend= Weight_y))+
  
  geom_segment(aes(x= Weight_x, xend= Reach_x, y= Weight_y, yend= Reach_y))+
  
  geom_segment(aes(x= Reach_x, xend= SLpM_x, y= Reach_y, yend= SLpM_y))+
  
  geom_segment(aes(x= SLpM_x, xend= Str_Def_x, y= SLpM_y, yend= Str_Def_y))+
  
  geom_segment(aes(x= Str_Def_x, xend= TD_Avg_x, y= Str_Def_y, yend= TD_Avg_y))+
  
  geom_segment(aes(x= TD_Avg_x, xend= TD_Acc_x, y= TD_Avg_y, yend= TD_Acc_y))+
  
  geom_segment(aes(x= TD_Acc_x, xend= Sub_Avg_x, y= TD_Acc_y, yend= Sub_Avg_y))+
  
  geom_segment(aes(x= Sub_Avg_x, xend= Height_x, y= Sub_Avg_y, yend= Height_y))


fighter_1

fighter_2 <- ggplot(df_coords[4,])+
  geom_point(aes(x=0, y=0), color = "red")+
  
  geom_point(aes(x= Height_x, y= Height_y))+
  geom_text(aes(x= Height_x, y= Height_y, label = "Height"), nudge_y = 0.1)+
  
  geom_point(aes(x= Weight_x, y= Weight_y))+
  geom_text(aes(x= Weight_x, y= Weight_y, label = "Weight"), nudge_y = 0.1)+
  
  geom_point(aes(x= Reach_x, y= Reach_y))+
  geom_text(aes(x= Reach_x, y= Reach_y, label = "Reach"), nudge_y = 0.1)+
  
  geom_point(aes(x= SLpM_x, y= SLpM_y))+
  geom_text(aes(x= SLpM_x, y= SLpM_y, label = "SLpM"), nudge_y = 0.1)+
  
  geom_point(aes(x= Str_Def_x, y= Str_Def_y))+
  geom_text(aes(x= Str_Def_x, y= Str_Def_y, label = "Str_Def"), nudge_y = 0.1)+
  
  geom_point(aes(x= TD_Avg_x, y= TD_Avg_y))+
  geom_text(aes(x= TD_Avg_x, y= TD_Avg_y, label = "TD_Avg"), nudge_y = 0.1)+
  
  geom_point(aes(x= TD_Acc_x, y= TD_Acc_y))+
  geom_text(aes(x= TD_Acc_x, y= TD_Acc_y, label = "TD_Acc"), nudge_y = 0.1)+
  
  geom_point(aes(x= Sub_Avg_x, y= Sub_Avg_y))+
  geom_text(aes(x= Sub_Avg_x, y= Sub_Avg_y, label = "Sub_Avg"), nudge_y = 0.1)+
  
  geom_segment(aes(x= Height_x, xend= Weight_x, y= Height_y, yend= Weight_y))+
  
  geom_segment(aes(x= Weight_x, xend= Reach_x, y= Weight_y, yend= Reach_y))+
  
  geom_segment(aes(x= Reach_x, xend= SLpM_x, y= Reach_y, yend= SLpM_y))+
  
  geom_segment(aes(x= SLpM_x, xend= Str_Def_x, y= SLpM_y, yend= Str_Def_y))+
  
  geom_segment(aes(x= Str_Def_x, xend= TD_Avg_x, y= Str_Def_y, yend= TD_Avg_y))+
  
  geom_segment(aes(x= TD_Avg_x, xend= TD_Acc_x, y= TD_Avg_y, yend= TD_Acc_y))+
  
  geom_segment(aes(x= TD_Acc_x, xend= Sub_Avg_x, y= TD_Acc_y, yend= Sub_Avg_y))+
  
  geom_segment(aes(x= Sub_Avg_x, xend= Height_x, y= Sub_Avg_y, yend= Height_y))

ggplot()+
  geom_point(data = df[1,], aes(x=0, y=0), color = "red")+
  geom_point(data = df[1,], aes(x= Height_x, y= Height_y))+
  geom_point(data = df[1,], aes(x= Weight_x, y= Weight_y))+
  geom_point(data = df[1,], aes(x= Reach_x, y= Reach_y))+
  geom_segment(data = df[1,], aes(x= Height_x, xend= Weight_x, y= Height_y, yend= Weight_y))+
  
  geom_point(data = df[2,], aes(x=0, y=0), color = "red")+
  geom_point(data = df[2,], aes(x= Height_x, y= Height_y))+
  geom_point(data = df[2,], aes(x= Weight_x, y= Weight_y))+
  geom_point(data = df[2,], aes(x= Reach_x, y= Reach_y))+
  geom_segment(data = df[2,], aes(x= Height_x, xend= Weight_x, y= Height_y, yend= Weight_y))

### How to join plits ###

df <- data.frame(first = c(1:5),
                 second = c(1:5))
df_2 <- df*2

plot1 <- geom_point(aes(x=first, y=second), df, color = "red")

plot2 <- geom_point(aes(x=first, y=second), df_2, color = "blue")

plot1 + plot2

ggplot() + plot1 + plot2



df_coords <- structure(list(Height_x = c(0.46, 0.34), Height_y = c(0.46, 0.34), 
               Weight_x = c(0, 0), Weight_y = c(1, 0.37), 
               Reach_x = c(-0.49, -0.35), 
               Reach_y = c(0.49, 0.35), SLpM_x = c(-0.12, -0.19), 
               SLpM_y = c(0, 0), Str_Def_x = c(-0.48, -0.46), 
               Str_Def_y = c(-0.48, -0.46), 
               TD_Avg_x = c(0, 0), 
               TD_Avg_y = c(-0.07, -0.02), 
               TD_Acc_x = c(0.17, 0.35), 
               TD_Acc_y = c(-0.17, -0.35), 
               Sub_Avg_x = c(0.01, 0), 
               Sub_Avg_y = c(0, 0)), 
               row.names = 1:2, class = "data.frame")


