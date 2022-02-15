library(ggplot2)

nmmaps<-read.csv("chicago-nmmaps.csv", as.is=T)

str(nmmaps)

nmmaps$date <- as.Date(nmmaps$date)

nmmaps <- nmmaps[nmmaps$date>as.Date("1996-12-13"),]

nmmaps$year <- substr(nmmaps$date, start = 1, stop = 4)


ggplot(nmmaps, aes(x = date, y = temp, color = factor(season)))+
  geom_point()+
  labs(title = 'Temperature\n lineheight controls me!',
       y = expression(paste('Temperature ( ', degree ~ F, ' )')),  # dzieki expression wyrazenie degree interpretowane jest jako /o/
       x = "Date")+
  theme(plot.title.position = "panel",
        plot.title = element_text(size = 20,
                                  lineheight = 0.8,  # Odległosc miedzy 1 a 2 linią
                                  face = "bold",
                                  margin = margin(10,0,20,0), # Ramka marginesu wokoł tytułu
                                  hjust = 0.4),  # Pozycja tutuły `H`orizontal od 0 do 1
        axis.ticks.x = element_blank(), # usuwa kreseczki na osi X
        axis.text.x = element_text(angle = 45,
                                   vjust = 0.5,
                                   colour = 'cadetblue'),
        legend.title = element_text(colour = '#6699CC'), # Zemianie kolor legendy
        legend.key = element_rect(fill = NA))+  # Zmienia tło za kropkami w legendzie na przezroczyste
  scale_color_discrete(name = "Season")+ # Zmienia nazwe legendy
  guides(colour = guide_legend(override.aes = list(size=3))) # Powieksza kropki w legendzie
  

ggplot(nmmaps, aes(temp, temp+rnorm(nrow(nmmaps), sd=20)))+geom_point()+
  xlim(c(0,150))+ylim(c(0,150))+
  coord_equal()


a <- as.data.frame(rnorm(nrow(nmmaps)))
colnames(a) = 'dupcia'

ggplot(data = a, aes(x = dupcia ))+
  geom_histogram(color='#003333', fill = "#6699CC")+
  scale_y_continuous(labels = function(x){paste('My value is: ', x)})


g<-ggplot(nmmaps, aes(date, temp, color=factor(season)))+geom_point()
g
                 
