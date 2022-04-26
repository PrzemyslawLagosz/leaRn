library(dplyr)

saved_users_list_reprex <- readRDS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\testers\\users_list_reprex.RData")

 new_day_reprex <- data.frame(
    date = as.Date("2022-04-25"),
    rate = 14,
    day_comment = "Dupcia"
  )


dplyr::filter(saved_users_list_reprex[[1]], date != "2022-04-25")

saved_users_list_reprex[[1]][saved_users_list_reprex[[1]]$date == "2022-04-19", ] <- new_day_reprex
