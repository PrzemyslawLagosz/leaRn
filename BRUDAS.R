library(tidyverse)
data(airquality)


df <- drop_na(df, Ozone)


hist(df$Ozone, breaks = 100)


ggplot(data = df, aes(x= Ozone))+
  geom_histogram(bins = 30)


seq(from =1, to = 10, length.out = 100)

