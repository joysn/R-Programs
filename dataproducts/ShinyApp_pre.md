Presentation for my Shiny Application - Predict Diamond Price
========================================================
author:  Joy SN
date: 7th Feb 2019
autosize: true

DataSet and Inputs
========================================================
Datamond Dataset is used
Inputs
- Number of data to be sampled from the dataset (Through a slider)
- Seed to be used for the same (Through a text box)



The prediction Model
========================================================
A linear Model is used to predict the Diamond Price based on the "number of data sampled from the dataset" and the "seed" used

```r
model <- lm(price ~ carat, data = diamonds)
```

![plot of chunk unnamed-chunk-3](ShinyApp_pre-figure/unnamed-chunk-3-1.png)

Prediction
========================================================
Model Coeffeicients

```
(Intercept)       carat 
  -2345.374    7905.390 
```
We predict the diomond price of various "carats" of diaomonds


```r
price_of_4_carat_diomond <- round(coef(model)['(Intercept)'] + coef(model)['carat']*4,2)
paste("Price of 4 carat diomond is ",price_of_4_carat_diomond, " $")
```

```
[1] "Price of 4 carat diomond is  29276.19  $"
```


Thank You 
========================================================

## Location of Shiny App and Code  

The application is running on https://snandan.shinyapps.io/MyFirstShinyApp/  

ui.R, and Server.R Code in my github repository (https://github.com/joysn/shinyapp_assignment)
  
