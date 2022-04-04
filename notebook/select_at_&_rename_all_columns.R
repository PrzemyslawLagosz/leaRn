head(df_n_cords)

df_n_cords <- structure(list(Height_x = c(0.46, 0.34, 0.37, 0.53, 0.4, 0.49), 
                             Height_y = c(0.46, 0.34, 0.37, 0.53, 0.4, 0.49), 
                             Reach_x = c(0,0, 0, 0, 0, 0), 
                             Reach_y = c(1, 0.37, 0.6, 1, 0.47, 0.47),  
                             SLpM_x = c(-0.49, -0.35, -0.44, -0.6, -0.49, -0.6), 
                             SLpM_y = c(0.49, 0.35, 0.44, 0.6, 0.49, 0.6), 
                             Str_Def_x = c(-0.12, -0.19, -0.1, -0.36, -0.16, -0.2), 
                             Str_Def_y = c(0, 0, 0, 0, 0, 0), 
                             Sub_Avg_x = c(-0.48, -0.46, -0.45, -0.28, -0.36, -0.5), 
                             Sub_Avg_y = c(-0.48, -0.46, -0.45, -0.28, -0.36, -0.5), 
                             TD_Acc_x = c(0, 0, 0, 0, 0, 0), 
                             TD_Acc_y = c(-0.07, -0.02, -0.04, -0.05, 0, 0), 
                             TD_Avg_x = c(0.17, 0.35, 0.14, 0.47, 0, 0), 
                             TD_Avg_y = c(-0.17, -0.35, -0.14, -0.47, 0, 0), 
                             Weight_x = c(0.01,0, 0, 0, 0, 0.01), 
                             Weight_y = c(0, 0, 0, 0, 0, 0)), 
                             row.names = c(NA,-6L), class = c("tbl_df", "tbl", "data.frame"))


df_n_cords %>% select_at(vars(contains("_x"))) %>% rename_all(.funs = function(x) str_replace(x, "_x", "_REPLACMENT"))
            
                         