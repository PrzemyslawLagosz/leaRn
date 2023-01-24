# Cleaning data from https://www.kaggle.com/datasets/rajeevw/ufcdata?select=raw_fighter_details.csv

library(ggplot2)
library(tidyverse)
library(readr)
library(dplyr)



raw_fighter_details <- read_csv("UFC/raw_fighter_details.csv")


# Removing rows with NA
raw_fighter_details <- raw_fighter_details[!is.na(raw_fighter_details$Reach),]
raw_fighter_details <- raw_fighter_details[!is.na(raw_fighter_details$Height),]

## Columns with % sufix "Str_Acc %" "Str_Def %" "TD_Acc %"  "TD_Def %" 
colnames(raw_fighter_details)[c(8,10,12,13)]

#Replacment % with space
raw_fighter_details[,c(8,10,12,13)] <- lapply(raw_fighter_details[,c(8,10,12,13)], gsub, pattern = "%", replacement = "")

#Chenging type of variables
raw_fighter_details[,c(8,10,12,13)] <- lapply(raw_fighter_details[,c(8,10,12,13)], as.numeric)

#Adding % to the Column names
colnames(raw_fighter_details)[c(8,10,12,13)] <- paste0(colnames(raw_fighter_details)[c(8,10,12,13)], "_%")

#Chenging type of variable to date
# Wed Mar 09 10:58:57 2022 ------------------------------
# raw_fighter_details[6] <- lapply(raw_fighter_details[,6], as.Date, "%b%d%Y") # <-- This dosn't work 

# dates <- raw_fighter_details$DOB
# 
# table(is.na(dates))
# 
# dates <- lapply(dates, gsub, pattern = ",", replacement = "")
# dates <- lapply(dates, gsub, pattern = " ", replacement = "/")
# 
# strptime(as.character(dates), "%b/%d/%Y")

# lapply(raw_fighter_details[,6], as.Date, "%b%d%Y")
# Wed Mar 09 10:59:17 2022 ------------------------------


## Weight
## Column with " sufix "Weight (lbs)"

colnames(raw_fighter_details)[3] <- "Weight_(lbs)"

raw_fighter_details[,3] <- lapply(raw_fighter_details[,3], gsub, pattern = "lbs.", replacement = "")
raw_fighter_details[,3] <- lapply(raw_fighter_details[,3], as.numeric)

## Problem with the weight
# In UFC are 9 weight clasess, in ourdata we have got 38
length(unique(raw_fighter_details$`Weight_(lbs)`))

sort(unique(raw_fighter_details$`Weight_(lbs)`))
weights <- sort(unique(raw_fighter_details$`Weight_(lbs)`))

# I decided to replace wrong values with the value above, because when we assign person to the weight class, if it pass certain value
# it will be assigned to the weight class above. eg. We;ve got classes 205, and 265. 
# All persons with weight above 205 are in 265 weightclass

weights[weights > 205]
weights[weights > 205 & weights <= 265]

to_265 = c(220, 225, 230, 231, 234, 235, 238, 240, 241, 242, 243, 244, 245, 246,
           247, 249, 250, 253, 255, 256, 257, 258, 260, 262, 263, 264)

to_265 = weights[weights > 205]

to_145 = c(139, 140)

to_170 = 168

raw_fighter_details["Weight_(lbs)"] <- sapply(raw_fighter_details["Weight_(lbs)"],
                             function(x) replace(x, x %in% to_265, 265))

raw_fighter_details["Weight_(lbs)"] <- sapply(raw_fighter_details["Weight_(lbs)"],
                             function(x) replace(x, x %in% to_145, 145))

raw_fighter_details["Weight_(lbs)"] <- sapply(raw_fighter_details["Weight_(lbs)"],
                             function(x) replace(x, x %in% to_170, 170))

sort(unique(raw_fighter_details$`Weight_(lbs)`))

# Separating a weight column, to make kg cloumn 

weight <- as.data.frame(raw_fighter_details$`Weight_(lbs)`)

colnames(weight) <- "Weight_(kg)"

weight <- weight %>% 
  transmute(`Weight_(kg)` = round(`Weight_(kg)`*0.45359237))

## Replacing a NA stance with "Orthodox"

which(is.na(raw_fighter_details$Stance))

to_Orthodox <- which(is.na(raw_fighter_details$Stance))

raw_fighter_details$Stance[to_Orthodox] <- "Orthodox"

which(is.na(raw_fighter_details$Stance))

## Reach

colnames(raw_fighter_details)[4] <- "Reach_(inches)"

raw_fighter_details[,4] <- lapply(raw_fighter_details[,4], gsub, pattern = '"', replacement = "")
raw_fighter_details[,4] <- lapply(raw_fighter_details[,4], as.numeric)

# Making a reach column in centimeters
reach <- as.data.frame(raw_fighter_details$`Reach_(inches)`)

colnames(reach) <- "Reach_(cm)"

reach <- reach %>% 
  transmute(`Reach_(cm)` = round(`Reach_(cm)`*2.54))

## Height
# 1feet = 12 inches

height <- lapply(raw_fighter_details[,2], str_split, pattern = " ", simplify = TRUE)

height <- as.data.frame(height)
colnames(height) <- c("Foots","Inches")

# Those 2 lines dosn't work as intended. Replacing whole column with very top value. Weird.
# height[,1] <- lapply(height[,1], gsub, pattern = "\'", replacement = "")
# height[,2] <- lapply(height[,2], gsub, pattern = "\"", replacement = "")

# This works :)
height[,1] <- vapply(height[,1], gsub, pattern = "\'", replacement = "", FUN.VALUE = character(1))
height[,2] <- vapply(height[,2], gsub, pattern = "\"", replacement = "", FUN.VALUE = character(1))

height[,c(1:2)] <- lapply(height[,c(1:2)], as.numeric)

height <- height %>%
  mutate(Inches_only = Foots*12 + Inches,
         cm = round(Inches_only*2.54))


## Making EU and USA unit based dataframe

## USA
raw_fighter_details_USA <- raw_fighter_details %>%
  mutate(Height = height$Inches_only)

colnames(raw_fighter_details_USA)[3:4] <- c("Weight", "Reach")

## EU
raw_fighter_details_EU <- raw_fighter_details %>%
  mutate("Height" = height$cm,
         "Weight_(lbs)" = weight$`Weight_(kg)`,
         "Reach_(inches)" = reach$`Reach_(cm)`)

colnames(raw_fighter_details_EU)[2:4] <- c("Height", "Weight", "Reach")

## Min and Max value by weight

## Weird. Why 155 class has no max and min in Height?? <- there was NA value in column


df_min_max <- raw_fighter_details_USA %>%
  group_by(Weight) %>%
  summarise(Height_min = min(Height),
            Height_max= max(Height),
            Reach_min = min(Reach),
            Reach_max= max(Reach),
            SLpM_min = min(SLpM),
            SLpM_max = max(SLpM),
            Str_Acc_min = min(`Str_Acc_%`),
            Str_Acc_max = max(`Str_Acc_%`),
            SApM_min = min(SApM),
            SApM_max = max(SApM),
            Str_Def_min = min(`Str_Def_%`),
            Str_Def_max = max(`Str_Def_%`),
            TD_Avg_min = min(TD_Avg),
            TD_Avg_max = max(TD_Avg),
            TD_Acc_min = min(`TD_Acc_%`),
            TD_Acc_max = max(`TD_Acc_%`),
            TD_def_min = min(`TD_Def_%`),
            TD_def_max = max(`TD_Def_%`),
            Sub_Avg_min = min(Sub_Avg),
            Sub_Avg_max = max(Sub_Avg)
            )

df_min_max

# No NA values, so far so good :)

which(is.na(raw_fighter_details_USA$Height))
which(is.na(raw_fighter_details_USA$Stance))

# So here I came back to the top and removed this row, because ther was NA value in min_max data frame

write_csv(raw_fighter_details_USA, "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_USA.csv")
write_csv(raw_fighter_details_EU, "C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_EU.csv")

raw_fighter_details_EU <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_EU.csv")
raw_fighter_details_USA <- read_csv("C:\\Users\\Przemo\\Documents\\R\\leaRn\\Shiny\\UFC\\raw_fighter_details_USA.csv")

str(raw_fighter_details_EU)



