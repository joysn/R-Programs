---
title: "Analysis of the Economic and Life Losses and Damages Due to different US Weather Events"
author: "Joy SN"
date: "02/02/2019"
output: 
  html_document: 
    keep_md: yes
---

## 1: Synopsis
The goal of the assignment is to explore the NOAA Storm Database and find out how different events effects the life and econmoy of US.
The events in the database start in the year 1950 and end in November 2011. 

The following analysis investigates which types of events are effects most on
1. Lift (injuries and fatalities) 
2. Economoy (Property and Crop)

Information on the Data: [Documentation](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf)
National Climatic Data Center Storm Events [FAQ](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf)

## Data Processing
1. Data Download


```r
my_path <- getwd()
remote_url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
downloaded_zip_file = "StormData.csv.bz2"
download.file(remote_url, file.path(my_path, downloaded_zip_file))
```

2. Data Load and Data Details

```r
my_path <- getwd()
StormData <- read.csv(file.path(my_path, "StormData.csv.bz2"),header = TRUE, sep=",")
str(StormData)
```

```
## 'data.frame':	902297 obs. of  37 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : Factor w/ 16335 levels "1/1/1966 0:00:00",..: 6523 6523 4242 11116 2224 2224 2260 383 3980 3980 ...
##  $ BGN_TIME  : Factor w/ 3608 levels "00:00:00 AM",..: 272 287 2705 1683 2584 3186 242 1683 3186 3186 ...
##  $ TIME_ZONE : Factor w/ 22 levels "ADT","AKS","AST",..: 7 7 7 7 7 7 7 7 7 7 ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: Factor w/ 29601 levels "","5NM E OF MACKINAC BRIDGE TO PRESQUE ISLE LT MI",..: 13513 1873 4598 10592 4372 10094 1973 23873 24418 4598 ...
##  $ STATE     : Factor w/ 72 levels "AK","AL","AM",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : Factor w/ 35 levels "","  N"," NW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_LOCATI: Factor w/ 54429 levels "","- 1 N Albion",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_DATE  : Factor w/ 6663 levels "","1/1/1993 0:00:00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_TIME  : Factor w/ 3647 levels ""," 0900CST",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : Factor w/ 24 levels "","E","ENE","ESE",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_LOCATI: Factor w/ 34506 levels "","- .5 NNW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: Factor w/ 19 levels "","-","?","+",..: 17 17 17 17 17 17 17 17 17 17 ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: Factor w/ 9 levels "","?","0","2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ WFO       : Factor w/ 542 levels ""," CI","$AC",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ STATEOFFIC: Factor w/ 250 levels "","ALABAMA, Central",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ ZONENAMES : Factor w/ 25112 levels "","                                                                                                               "| __truncated__,..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : Factor w/ 436781 levels "","-2 at Deer Park\n",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10 ...
```

```r
head(StormData,2)
```

```
##   STATE__          BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1       1 4/18/1950 0:00:00     0130       CST     97     MOBILE    AL
## 2       1 4/18/1950 0:00:00     0145       CST      3    BALDWIN    AL
##    EVTYPE BGN_RANGE BGN_AZI BGN_LOCATI END_DATE END_TIME COUNTY_END
## 1 TORNADO         0                                               0
## 2 TORNADO         0                                               0
##   COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH F MAG FATALITIES
## 1         NA         0                        14   100 3   0          0
## 2         NA         0                         2   150 2   0          0
##   INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO STATEOFFIC ZONENAMES
## 1       15    25.0          K       0                                    
## 2        0     2.5          K       0                                    
##   LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM
## 1     3040      8812       3051       8806              1
## 2     3042      8755          0          0              2
```

3. Explore the Event Types and Propery and Crop Expense Types

```r
summary(StormData$EVTYPE)
```

```
##                     HAIL                TSTM WIND        THUNDERSTORM WIND 
##                   288661                   219940                    82563 
##                  TORNADO              FLASH FLOOD                    FLOOD 
##                    60652                    54277                    25326 
##       THUNDERSTORM WINDS                HIGH WIND                LIGHTNING 
##                    20843                    20212                    15754 
##               HEAVY SNOW               HEAVY RAIN             WINTER STORM 
##                    15708                    11723                    11433 
##           WINTER WEATHER             FUNNEL CLOUD         MARINE TSTM WIND 
##                     7026                     6839                     6175 
## MARINE THUNDERSTORM WIND               WATERSPOUT              STRONG WIND 
##                     5812                     3796                     3566 
##     URBAN/SML STREAM FLD                 WILDFIRE                 BLIZZARD 
##                     3392                     2761                     2719 
##                  DROUGHT                ICE STORM           EXCESSIVE HEAT 
##                     2488                     2006                     1678 
##               HIGH WINDS         WILD/FOREST FIRE             FROST/FREEZE 
##                     1533                     1457                     1342 
##                DENSE FOG       WINTER WEATHER/MIX           TSTM WIND/HAIL 
##                     1293                     1104                     1028 
##  EXTREME COLD/WIND CHILL                     HEAT                HIGH SURF 
##                     1002                      767                      725 
##           TROPICAL STORM           FLASH FLOODING             EXTREME COLD 
##                      690                      682                      655 
##            COASTAL FLOOD         LAKE-EFFECT SNOW        FLOOD/FLASH FLOOD 
##                      650                      636                      624 
##                LANDSLIDE                     SNOW          COLD/WIND CHILL 
##                      600                      587                      539 
##                      FOG              RIP CURRENT              MARINE HAIL 
##                      538                      470                      442 
##               DUST STORM                AVALANCHE                     WIND 
##                      427                      386                      340 
##             RIP CURRENTS              STORM SURGE            FREEZING RAIN 
##                      304                      261                      250 
##              URBAN FLOOD     HEAVY SURF/HIGH SURF        EXTREME WINDCHILL 
##                      249                      228                      204 
##             STRONG WINDS           DRY MICROBURST    ASTRONOMICAL LOW TIDE 
##                      196                      186                      174 
##                HURRICANE              RIVER FLOOD               LIGHT SNOW 
##                      174                      173                      154 
##         STORM SURGE/TIDE            RECORD WARMTH         COASTAL FLOODING 
##                      148                      146                      143 
##               DUST DEVIL         MARINE HIGH WIND        UNSEASONABLY WARM 
##                      141                      135                      126 
##                 FLOODING   ASTRONOMICAL HIGH TIDE        MODERATE SNOWFALL 
##                      120                      103                      101 
##           URBAN FLOODING               WINTRY MIX        HURRICANE/TYPHOON 
##                       98                       90                       88 
##            FUNNEL CLOUDS               HEAVY SURF              RECORD HEAT 
##                       87                       84                       81 
##                   FREEZE                HEAT WAVE                     COLD 
##                       74                       74                       72 
##              RECORD COLD                      ICE  THUNDERSTORM WINDS HAIL 
##                       64                       61                       61 
##      TROPICAL DEPRESSION                    SLEET         UNSEASONABLY DRY 
##                       60                       59                       56 
##                    FROST              GUSTY WINDS      THUNDERSTORM WINDSS 
##                       53                       53                       51 
##       MARINE STRONG WIND                    OTHER               SMALL HAIL 
##                       48                       48                       47 
##                   FUNNEL             FREEZING FOG             THUNDERSTORM 
##                       46                       45                       45 
##       Temperature record          TSTM WIND (G45)         Coastal Flooding 
##                       43                       39                       38 
##              WATERSPOUTS    MONTHLY PRECIPITATION                    WINDS 
##                       37                       36                       36 
##                  (Other) 
##                     2940
```

```r
head(unique(StormData$PROPDMGEXP))
```

```
## [1] K M   B m +
## Levels:  - ? + 0 1 2 3 4 5 6 7 8 B h H K m M
```

```r
head(unique(StormData$CROPDMGEXP))
```

```
## [1]   M K m B ?
## Levels:  ? 0 2 B k K m M
```

4.Map property damage alphanumeric exponents to numeric values.

```r
propDmgKey <-  c("\"\"" = 10^0,
                 "-" = 10^0, 
                 "+" = 10^0,
                 "0" = 10^0,
                 "1" = 10^1,
                 "2" = 10^2,
                 "3" = 10^3,
                 "4" = 10^4,
                 "5" = 10^5,
                 "6" = 10^6,
                 "7" = 10^7,
                 "8" = 10^8,
                 "9" = 10^9,
                 "H" = 10^2,
                 "K" = 10^3,
                 "M" = 10^6,
                 "B" = 10^9)
```
5. Map crop damage alphanumeric exponents to numeric values

```r
cropDmgKey <-  c("\"\"" = 10^0,
                 "?" = 10^0, 
                 "0" = 10^0,
                 "K" = 10^3,
                 "M" = 10^6,
                 "B" = 10^9)
```

6. Create new columns with the numeric values of PROPDMGEXP and CROPDMGEXP (This part will take significantly long time to execute)

```r
StormData$PROPDMGEXPNEW = propDmgKey[as.character(StormData$PROPDMGEXP)]
StormData$PROPDMGEXPNEW[which(is.na(StormData$PROPDMGEXPNEW))] = 10^0 

StormData$CROPDMGEXPNEW = cropDmgKey[as.character(StormData$CROPDMGEXP)]
StormData$CROPDMGEXPNEW[which(is.na(StormData$CROPDMGEXPNEW))] = 10^0 
```

7. Create new columns propCost and cropCost based on the new numeric value

```r
StormData$propCost = StormData$PROPDMG * StormData$PROPDMGEXPNEW
StormData$cropCost = StormData$CROPDMG * StormData$CROPDMGEXPNEW
StormData$totCost = StormData$propCost + StormData$cropCost
```

8. Re-assess the data

```r
str(StormData)
```

```
## 'data.frame':	902297 obs. of  42 variables:
##  $ STATE__      : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE     : Factor w/ 16335 levels "1/1/1966 0:00:00",..: 6523 6523 4242 11116 2224 2224 2260 383 3980 3980 ...
##  $ BGN_TIME     : Factor w/ 3608 levels "00:00:00 AM",..: 272 287 2705 1683 2584 3186 242 1683 3186 3186 ...
##  $ TIME_ZONE    : Factor w/ 22 levels "ADT","AKS","AST",..: 7 7 7 7 7 7 7 7 7 7 ...
##  $ COUNTY       : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME   : Factor w/ 29601 levels "","5NM E OF MACKINAC BRIDGE TO PRESQUE ISLE LT MI",..: 13513 1873 4598 10592 4372 10094 1973 23873 24418 4598 ...
##  $ STATE        : Factor w/ 72 levels "AK","AL","AM",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ EVTYPE       : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ BGN_RANGE    : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI      : Factor w/ 35 levels "","  N"," NW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_LOCATI   : Factor w/ 54429 levels "","- 1 N Albion",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_DATE     : Factor w/ 6663 levels "","1/1/1993 0:00:00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_TIME     : Factor w/ 3647 levels ""," 0900CST",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ COUNTY_END   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN   : logi  NA NA NA NA NA NA ...
##  $ END_RANGE    : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI      : Factor w/ 24 levels "","E","ENE","ESE",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_LOCATI   : Factor w/ 34506 levels "","- .5 NNW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LENGTH       : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH        : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F            : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG          : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES   : num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES     : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG      : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP   : Factor w/ 19 levels "","-","?","+",..: 17 17 17 17 17 17 17 17 17 17 ...
##  $ CROPDMG      : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP   : Factor w/ 9 levels "","?","0","2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ WFO          : Factor w/ 542 levels ""," CI","$AC",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ STATEOFFIC   : Factor w/ 250 levels "","ALABAMA, Central",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ ZONENAMES    : Factor w/ 25112 levels "","                                                                                                               "| __truncated__,..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LATITUDE     : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE    : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E   : num  3051 0 0 0 0 ...
##  $ LONGITUDE_   : num  8806 0 0 0 0 ...
##  $ REMARKS      : Factor w/ 436781 levels "","-2 at Deer Park\n",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ REFNUM       : num  1 2 3 4 5 6 7 8 9 10 ...
##  $ PROPDMGEXPNEW: num  1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 ...
##  $ CROPDMGEXPNEW: num  1 1 1 1 1 1 1 1 1 1 ...
##  $ propCost     : num  25000 2500 25000 2500 2500 2500 2500 2500 25000 25000 ...
##  $ cropCost     : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ totCost      : num  25000 2500 25000 2500 2500 2500 2500 2500 25000 25000 ...
```

```r
head(StormData,2)
```

```
##   STATE__          BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1       1 4/18/1950 0:00:00     0130       CST     97     MOBILE    AL
## 2       1 4/18/1950 0:00:00     0145       CST      3    BALDWIN    AL
##    EVTYPE BGN_RANGE BGN_AZI BGN_LOCATI END_DATE END_TIME COUNTY_END
## 1 TORNADO         0                                               0
## 2 TORNADO         0                                               0
##   COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH F MAG FATALITIES
## 1         NA         0                        14   100 3   0          0
## 2         NA         0                         2   150 2   0          0
##   INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO STATEOFFIC ZONENAMES
## 1       15    25.0          K       0                                    
## 2        0     2.5          K       0                                    
##   LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM PROPDMGEXPNEW
## 1     3040      8812       3051       8806              1          1000
## 2     3042      8755          0          0              2          1000
##   CROPDMGEXPNEW propCost cropCost totCost
## 1             1    25000        0   25000
## 2             1     2500        0    2500
```

9. Create dataframe based on total econmoic loss cost and event type

```r
TotCostByEvt <- aggregate(totCost~EVTYPE, StormData, sum)
summary(TotCostByEvt)
```

```
##                    EVTYPE       totCost         
##     HIGH SURF ADVISORY:  1   Min.   :0.000e+00  
##   COASTAL FLOOD       :  1   1st Qu.:0.000e+00  
##   FLASH FLOOD         :  1   Median :0.000e+00  
##   LIGHTNING           :  1   Mean   :4.845e+08  
##   TSTM WIND           :  1   3rd Qu.:8.500e+04  
##   TSTM WIND (G45)     :  1   Max.   :1.503e+11  
##  (Other)              :979
```


## Results 
2. Which event causes most Fatalities?

```r
TotFatByEvt <- aggregate(FATALITIES~EVTYPE, StormData, sum)
m <- max(TotFatByEvt$FATALITIES)
TotFatByEvt$EVTYPE[which(TotFatByEvt$FATALITIES == m)]
```

```
## [1] TORNADO
## 985 Levels:    HIGH SURF ADVISORY  COASTAL FLOOD ... WND
```
3. Which event causes most Injuries?

```r
TotInjByEvt <- aggregate(INJURIES~EVTYPE, StormData, sum)
m <- max(TotInjByEvt$INJURIES)
TotInjByEvt$EVTYPE[which(TotInjByEvt$FATALITIES == m)]
```

```
## factor(0)
## 985 Levels:    HIGH SURF ADVISORY  COASTAL FLOOD ... WND
```

4. Which even causes most total Harm (Fatalities and Injuries?

```r
StormData$ALL_HARM <- StormData$INJURIES + StormData$FATALITIES
MaxAllHarm <- max(StormData$ALL_HARM)
MaxAllHarm
```

```
## [1] 1742
```

```r
MaxHarmEvent <- StormData$EVTYPE[which(StormData$ALL_HARM == MaxAllHarm)]
MaxHarmEvent
```

```
## [1] TORNADO
## 985 Levels:    HIGH SURF ADVISORY  COASTAL FLOOD ... WND
```

5. Plotting the Top Weather Event details of about number of injuries and fatalities

```r
library(ggplot2)
fatal <- TotFatByEvt[order(TotFatByEvt$FATALITIES, decreasing = T), ]
injury <- TotInjByEvt[order(TotInjByEvt$INJURIES, decreasing = T), ]

plot1 <- ggplot(data=head(fatal,10), aes(x=reorder(EVTYPE, FATALITIES), y=FATALITIES)) + 
    geom_bar(fill="brown",stat="identity")  + coord_flip() + 
    labs(title="Top 10 Fatality - causing Events in US",x="Weather Event", y="Total Number of Fatalities")
print(plot1)
```

![](PA2_StormData_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

```r
plot2 <- ggplot(data=head(injury,10), aes(x=reorder(EVTYPE, INJURIES), y=INJURIES)) + 
    geom_bar(fill="orange",stat="identity")  + coord_flip() + 
    labs(title="Top 10 Injury - causing Events in US",x="Weather Event", y="Total Number of Injuries") 
print(plot2)
```

![](PA2_StormData_files/figure-html/unnamed-chunk-13-2.png)<!-- -->

6. Which event causes most damage economically?

```r
maxcost = max(TotCostByEvt$totCost)
TotCostByEvt$EVTYPE[which(TotCostByEvt$totCost == maxcost)]
```

```
## [1] FLOOD
## 985 Levels:    HIGH SURF ADVISORY  COASTAL FLOOD ... WND
```

10. Plotting Tornado Data. There are too many rows, we will subset and get few top.  Pick only data which is above the mean for better graph

```r
mean = mean(TotCostByEvt$totCost)
TotCostByEvtShort <- TotCostByEvt[which(TotCostByEvt$totCost >= mean),]
summary(TotCostByEvtShort)
```

```
##             EVTYPE      totCost         
##  BLIZZARD      : 1   Min.   :5.002e+08  
##  DROUGHT       : 1   1st Qu.:1.206e+09  
##  EXCESSIVE HEAT: 1   Median :3.898e+09  
##  EXTREME COLD  : 1   Mean   :1.427e+10  
##  FLASH FLOOD   : 1   3rd Qu.:1.015e+10  
##  FLOOD         : 1   Max.   :1.503e+11  
##  (Other)       :27
```

11. Plot the top 10 events which causes harm

```r
library(ggplot2)
cost <- TotCostByEvt[order(TotCostByEvt$totCost, decreasing = T), ]
plot3 <- ggplot(data=head(cost,10), aes(x=reorder(EVTYPE, totCost), y=totCost)) + 
    geom_bar(fill="yellow",stat="identity")  + coord_flip() + 
    labs(title="Top 10 Economically harmfull  Events in US",x="Weather Event", y="Total Econmic Losses ($s)")
print(plot3)
```

![](PA2_StormData_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

