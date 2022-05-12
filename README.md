# Learn R notes
This repository is directly connected with Rstudio, and in fact it's my notebook.  
Link: https://przemyslawlagosz.github.io/leaRn/ <-- stuff I did :)  
BUG: GitHub pages doesn't applay changes in _site.yaml file

08.02.2022r - comeback to R.

## Moodtracker App
Code at https://github.com/PrzemyslawLagosz/leaRn/tree/main/Shiny/Moodtracker

Application let you track your mood, and at comments what happend that day :)  
**TO DO:** Important Evenet feautre -> (adding horizontal line to highlite important dates)  
Sneak peak gif:  
![](https://github.com/PrzemyslawLagosz/leaRn/blob/main/Shiny/Moodtracker/moodApp_animation.gif)

## UFC Dashboard
Code at: https://github.com/PrzemyslawLagosz/leaRn/tree/main/Shiny/UFC/main_app

I choosed this project with intention to practice: 
* Data cleaning and preparation
* * [Data Preparation script](https://github.com/PrzemyslawLagosz/leaRn/blob/main/Shiny/UFC/data_prep_UFC.R)
* Working with ggplot2
* * [Preparation of star plot](https://github.com/PrzemyslawLagosz/leaRn/blob/main/Shiny/UFC/star_plots.R) <- *inspiered by FIFA type of showing stats*
* Creating custom function to implement them while shaping data, and dynamically generate plot in Shiny
* * [Star plot script](https://github.com/PrzemyslawLagosz/leaRn/blob/main/Shiny/UFC/star_plots.R)
* * [Script with functions, to normalize Data Frame, generate X and Y coords for choosen stats, and dynamically generate geom_points and geom_segments](https://github.com/PrzemyslawLagosz/leaRn/blob/main/Shiny/my_functions.R)

**TO DO:** A lot eg. (imporve HTML, CSS skills)  
Sneak peak gif:  
![](https://github.com/PrzemyslawLagosz/leaRn/blob/main/Shiny/UFC/UFCdashboard_animation.gif)