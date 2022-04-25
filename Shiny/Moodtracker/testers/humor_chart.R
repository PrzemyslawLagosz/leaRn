library(ggplot2)
library(plotly)
library(lubridate)


users_list <- list(data.frame(date = c(as.Date("19103"),
                                       as.Date("19104"),
                                       as.Date("19105")),
                              rate = c(8,9,2),
                              day_comment = c("Byłem na spacerku",
                                              "",
                                              "Złamalem reke")
                              ),
                   data.frame(date = c(as.Date("2022-04-18"),
                                       as.Date("2022-04-19")),
                              rate = c(2,4),
                              day_comment = c("Spałem cały dzień",
                                              ""))
                   )


users_list <- list(AB = data.frame(date = c(as.Date("2022-04-18")),
                                   rate = c(8),
                                   day_comment = c("Byłem na spacerku")))
                   
### DLACZEGO GDY WYKORZYSTUJAC TĄ FUNKCJE Z append() DODAJE MI Z X A NIE Z PRZEKAZANYM ARGUMENTEM?? ###
add_new_user_to_users_list <- function(x) {
  list(x = data.frame(date = c(as.Date(today())),
                            rate = NA,
                            day_comment = NA))
}

### dodawanie do DF wewnatrz listy
users_list[[2]] <- rbind(users_list[[2]], as.data.frame(new_line))

new_line <- list(date = 19103, rate = 9, day_comment = "Całkiem spoko")



### Zapisanie listy z DF ### 
saveRDS(users_list, "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")

loaded_users_list <- readRDS("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\Moodtracker\\users_list.RData")


### Tworzy DF jako element ktory zostanie dodatny do listy
new_registered_user <- list(data.frame(date = c(as.Date(today())),
                                                 rate = 0,
                                                 day_comment = 0))
# Dodanie do listy
users_list <- append(users_list, new_registered_user)



### Dodawanie nowej oceny do konkretnego uzytkownika
new_day_rate <- data.frame(date = c(as.Date("2022-04-18")),
                           rate = c(8),
                           day_comment = c("Zrosło mi się"))

single_user <- users_list[[1]]

single_user <- rbind(single_user, new_day_rate)



### Sprawdzenie ktorego uzytkownika wczytac
which(saved_passwords$user_pas == "AB")




### CHART BELLOW ###

p <- ggplot(data = users_list[[1]], aes(x = date, y = rate, label = day_comment, color = rate)) +
  geom_point() +
  geom_line() +
  ylim(c(0,10)) +
  ggtitle("Moodtracker Plot")+
  labs(x = element_blank(),
       y= element_blank()) +
  theme(axis.text.x=element_text(angle=50, vjust=0.5),
        plot.title = element_text(hjust = 0.5,  margin = margin(0, 0, 10, 0)),
        panel.background = element_blank(),
        panel.grid.major.y = element_line(colour = "grey75"),
        legend.position = "none"
        ) +
  scale_color_gradient(low="#393B57", high="#47A5CB")
p
 

