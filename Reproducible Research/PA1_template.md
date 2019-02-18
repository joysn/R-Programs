---
output: 
  html_document: 
    keep_md: yes
---
# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data

1. Download and unzip the file


```r
my_path <- getwd()
remote_url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
downloaded_zip_file = "Activity.zip"
download.file(remote_url, file.path(my_path, downloaded_zip_file))
unzip(zipfile = downloaded_zip_file)
```


2. Load Data

```r
activity <- read.csv(file.path(my_path, "activity.csv"),header=TRUE)
```

3. Data Outlook


```r
str(activity)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

```r
summary(activity)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```

```r
head(activity)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```


## What is mean total number of steps taken per day?

1. Subset the original data to calculate the total number of steps

```r
TotStepsDay <- aggregate(steps~date, activity, sum)
head(TotStepsDay)
```

```
##         date steps
## 1 2012-10-02   126
## 2 2012-10-03 11352
## 3 2012-10-04 12116
## 4 2012-10-05 13294
## 5 2012-10-06 15420
## 6 2012-10-07 11015
```

2. Make a histogram of the total number of steps taken each day

```r
hist(TotStepsDay$steps,col="red",xlab="Total Steps",main="Total Steps Per Day")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

3. Calculate and report the mean and median total number of steps taken per day

```r
mean(TotStepsDay$steps)
```

```
## [1] 10766.19
```

```r
median(TotStepsDay$steps)
```

```
## [1] 10765
```

## What is the average daily activity pattern?

1. Calculate the mean(average) per interval

```r
AvgStepsInt <- aggregate(steps~interval, activity, mean)
head(AvgStepsInt)
```

```
##   interval     steps
## 1        0 1.7169811
## 2        5 0.3396226
## 3       10 0.1320755
## 4       15 0.1509434
## 5       20 0.0754717
## 6       25 2.0943396
```

2. Make a time series plot (type="l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
with(AvgStepsInt, plot(interval, steps, type="l", xlab = "Intreval", ylab= "Number of Steps", main="Average number of steps taken in 5-min interval", col = "red")) 
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

3. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
max <- max(AvgStepsInt$steps)
max
```

```
## [1] 206.1698
```

```r
MaxAvgStepsInt <- subset(AvgStepsInt, steps == max)
MaxAvgStepsInt$interval
```

```
## [1] 835
```

## Imputing missing values
Note that there are a number of days/intervals where there are missing values (NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
colSums(is.na(activity))
```

```
##    steps     date interval 
##     2304        0        0
```

2. Devise a strategy for filling in all of the missing values in the dataset. We are filling the mean for that day, or the mean for that 5-minute interval.
3. Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
activityNew <- activity
activityNew$steps[is.na(activityNew$steps)] <- AvgStepsInt$steps
head(activityNew)
```

```
##       steps       date interval
## 1 1.7169811 2012-10-01        0
## 2 0.3396226 2012-10-01        5
## 3 0.1320755 2012-10-01       10
## 4 0.1509434 2012-10-01       15
## 5 0.0754717 2012-10-01       20
## 6 2.0943396 2012-10-01       25
```

4. Make a histogram of the total number of steps taken each day 

```r
TotStepsDayNew <- aggregate(steps~date, activityNew, sum)
hist(TotStepsDayNew$steps,col="red",xlab="Total Steps",main="Total Steps Per Day")
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

5. Calculate and report the mean and median total number of steps taken per day. 

```r
mean(TotStepsDayNew$steps)
```

```
## [1] 10766.19
```

```r
median(TotStepsDayNew$steps)
```

```
## [1] 10766.19
```

6. Do these values differ from the estimates from the first part of the assignment?  
  What is the impact of imputing missing data on the estimates of the total daily number of steps?  
  Not much inpact seen in mean/median of the data. Mean remains same, median varied very little

```r
mean(TotStepsDayNew$steps) - mean(TotStepsDay$steps)
```

```
## [1] 0
```

```r
median(TotStepsDayNew$steps) - median(TotStepsDay$steps)
```

```
## [1] 1.188679
```

## Are there differences in activity patterns between weekdays and weekends?
Use the dataset with the filled-in missing values for this part.

1. Install the package  
  install.packages("timeDate")

2. Load

```r
library(timeDate)
```

3. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
activityNew$Weekday <- factor(isWeekday(activityNew$date))
str(activityNew)
```

```
## 'data.frame':	17568 obs. of  4 variables:
##  $ steps   : num  1.717 0.3396 0.1321 0.1509 0.0755 ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
##  $ Weekday : Factor w/ 2 levels "FALSE","TRUE": 2 2 2 2 2 2 2 2 2 2 ...
```

```r
head(activityNew)
```

```
##       steps       date interval Weekday
## 1 1.7169811 2012-10-01        0    TRUE
## 2 0.3396226 2012-10-01        5    TRUE
## 3 0.1320755 2012-10-01       10    TRUE
## 4 0.1509434 2012-10-01       15    TRUE
## 5 0.0754717 2012-10-01       20    TRUE
## 6 2.0943396 2012-10-01       25    TRUE
```

4. Panel plot containing a time series plot (i.e. type="l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 

- Subset and calculate the average steps for weekday and weekend

```r
activityWeekday <- subset(activityNew, activityNew$Weekday == "TRUE")
AvgWeekdayStepsInt <- aggregate(steps~interval, activityWeekday, mean)
head(AvgWeekdayStepsInt)
```

```
##   interval      steps
## 1        0 2.25115304
## 2        5 0.44528302
## 3       10 0.17316562
## 4       15 0.19790356
## 5       20 0.09895178
## 6       25 1.59035639
```

- Subset and calculate the average steps for weekend

```r
activityWeekend <- subset(activityNew, activityNew$Weekday == "FALSE")
AvgWeekendStepsInt <- aggregate(steps~interval, activityWeekend, mean)
head(AvgWeekendStepsInt)
```

```
##   interval       steps
## 1        0 0.214622642
## 2        5 0.042452830
## 3       10 0.016509434
## 4       15 0.018867925
## 5       20 0.009433962
## 6       25 3.511792453
```

- Ploting the Graph


```r
par(mfrow = c(2,1))

layout(matrix(c(1,1,2,2), 2, 2, byrow = TRUE))
# Weekday
plot(AvgWeekdayStepsInt$interval, AvgWeekdayStepsInt$steps, xlab = "Interval", ylab = "Number of Steps", main ="Weekday", col ="blue", type="l") 
# Weekend
plot(AvgWeekendStepsInt$interval, AvgWeekendStepsInt$steps, xlab = "Interval", ylab = "Number of Steps", main ="Weekend", col ="red", type="l")
```

![](PA1_template_files/figure-html/unnamed-chunk-19-1.png)<!-- -->
