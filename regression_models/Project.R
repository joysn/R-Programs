library(reshape2)
library(ggplot2)

data("mtcars")
str(mtcars)

?mtcars

# Fig 1: - Take the continuous data and plot the correlation diagram
mydata <- mtcars[, c(1,3,4,5,6,7)]
cormat <- round(cor(mydata),2)
melted_cormat <- melt(cormat)
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + geom_tile()


# Now we build a linear model using all the variables
summary(lm(mpg ~ ., data = mtcars))$coefficients
# Since the P value of cyl is very high, we remove it and build another model minus cyl
dat <- mtcars
dat <- dat[, names(dat) != "cyl"]
summary(lm(mpg ~ ., data = dat))$coefficients
# Here we see that the P value of vs is quite high, so we now build another one w/o VS
dat <- dat[, names(dat) != "vs"]
summary(lm(mpg ~ ., data = dat))$coefficients
# And so on, we remove carb, gear, drat,disp and hp because of high P value
dat <- dat[, names(dat) != "carb"]
summary(lm(mpg ~ ., data = dat))$coefficients
dat <- dat[, names(dat) != "gear"]
summary(lm(mpg ~ ., data = dat))$coefficients
dat <- dat[, names(dat) != "drat"]
summary(lm(mpg ~ ., data = dat))$coefficients
dat <- dat[, names(dat) != "disp"]
summary(lm(mpg ~ ., data = dat))$coefficients 
dat <- dat[, names(dat) != "hp"]
summary(lm(mpg ~ ., data = dat))$coefficients 

# Finally we are leftt with 3 variables - wt, qsec and am
# am	 Transmission (0 = automatic, 1 = manual)
# mpg	 Miles/(US) gallon
# wt	 Weight (1000 lbs)
# qsec	 1/4 mile time
summary(lm(mpg ~ . -1, data = dat))$coefficients 

#As the p-value of all the remaining predictors are smaller than $0.05$, we can stop.
dat <- mtcars[, c("mpg", "wt", "qsec", "am")]

summary(lm(mpg ~ . -1, data = dat))$coefficients 
# As the two-sided p-value for the coefficient of `am` is `r summary(fit)$coefficients["am", 4]`, much smaller than 0.05,
# we have enough evidence to reject the hypothesis $H_0$.


fit <- lm(mpg ~ . - 1, data = dat)
sumCoef <- summary(fit)$coefficients
intv <- sumCoef["am", 1] + c(-1, 1) * qt(0.975, df = fit$df)*sumCoef["am", 2]
intv

# With 95% confidence, we estimate that a the change from automatic to manual transmission results in a 
#2.204969 to 6.394069 increase in miles per gallon for the cars. 
# In conclusion, the manual transmission is better than automatic transmission for mpg.

difference_mpg_am <- t.test(dat[dat$am==1,]$mpg,dat[dat$am==0,]$mpg)
difference_mpg_am
round(difference_mpg_am$conf.int[1],1)
round(difference_mpg_am$conf.int[2],1)
round(difference_mpg_am$p.value,4)

# Cars with manual transmission travel an average 24.39231 miles/gallon compared to  17.14737  miles/gallon in those 
# with automatic transmission (difference: 24.39 - 17.147 , 95% CI: 3.2 - 11.3 ,p = 0.0014).

# But there is a caveat
# We create a pair plot - Fig 2
pairs(dat, panel = panel.smooth, main = "mtcars data")
# we see that there is a relationship between am and wt. 

# Fig 3
ggplot(mtcars) + 
    geom_boxplot(aes(factor(am), mpg)) + xlab('Weight') +
    scale_x_discrete(labels = c('Manual','Automatic'))
# We can clearly see that there is a strong relation between weight and Transmission

# We start with Sequential Testing
# Model 1 - MPG ~ Wt
fit1 <- lm(mpg ~ wt, data = data)
summary(fit1)$coefficients
summary(fit1)$adj.r.squared
sd(fit1$residuals)

# The addition of the variable "transmission" to Model 1 to create Model 2 showed that the type of transmission
# is not a significant variable to explain MPG (Model 2).
fit2 <- update(fit1, mpg ~ wt + am)
summary(fit2)$coefficients
summary(fit2)$adj.r.squared
sd(fit2$residuals)
anv1<-anova(fit1, fit2)
anv1
# Furthermore, the explanatory effect that the variable
# transmission has over MPG is mostly due to its relation to weight which was described above (manual cars
# are significantly lighter than larger cars)
# M1  278.32, M2 278.32, P Value  0.9879

# However, as illustrated in Figure 2, there appears to be an interaction between weight and type of transmission
# to explain MPG. This is seen in the different slopes for weight for each type of transmission, with manual
# transmission showing a greater decrease in MPG as the weight of the car increases. Model 3 includes a
# term to control for this interaction (weight*transmission) (Model 3).
fit3 <- update(fit1, mpg ~ wt * am)
summary(fit3)$coefficients
summary(fit3)$adj.r.squared
round(abs(summary(fit3)$coefficients[2,1])+abs(abs(summary(fit3)$coefficients[4,1])),2)
round(abs(summary(fit3)$coefficients[2,1]))
fit3
anv2<-anova(fit1, fit3)
anv2

# In this models all coefficients are
# significant and ANOVA shows that the inclusion of this interaction term reduces RSS significantly reduces
# the unexplained variation in the model. The interaction is illustrated in Figure 4.  Additional diagnostic
# plot are shown in Figure 4. Model 3 shows that for manual cars, for every unit increase in weight, there is
# an average drop of 9.08 miles/gallon, compared to a drop of 4.


# In summary, manual cars are on average more efficient (give more MPG) than automatic cars. This can be
# explained in part by the finding that manual cars are also significantly lighter than automatic cars and that
# the heavier cars produce significantly less MPG. Even though manual cars tend to be more efficient, any unit
# increase in weight will affect more the MPG than for automatic cars (9.08 miles/gallon drop/unit of weight
#                                                                     vs. 4 miles/gallon drop/unit of weight)


# Fig 4
mean_mpg_auto <- mean(dat[dat$am==0,]$mpg)
mean_mpg_manual <- mean(dat[dat$am==1,]$mpg)

lmA <- lm(dat$mpg[dat$am=="0"] ~ dat$wt[dat$am=="0"])
lmM <- lm(dat$mpg[dat$am=="1"] ~ dat$wt[dat$am=="1"])
plot(dat$wt,dat$mpg,pch=19, xlab='Weight lb/1000', ylab='Miles per gallon')
points(dat$wt,dat$mpg,pch=19,col=((dat$am=="1")*1+1))
lines(dat$wt[dat$am=="0"],lmA$fitted,col="black",lwd=3)
lines(dat$wt[dat$am=="1"],lmM$fitted,col="red",lwd=3)
points(dat$wt,fit3$fitted,col="blue",lwd=2)
abline(h=mean(dat$mpg), v=mean(dat$wt))
abline(h=mean_mpg_manual, col = "red", lty=2)
abline(h=mean_mpg_auto, lty=2)
text(5,mean(dat$mpg[dat$am==1])+1,'Mean MPG in manual')
text(5,mean(dat$mpg[dat$am==0])+1,'Mean MPG in automatic')



# Fig 5
# We can also plot the residual and other variations of the final fit

par(mfrow = c(2, 2))
plot(fit)
# We note that the residuals show no obvious pattern, so it is reasonable to try to fit a linear model to the data.
#Now with all the previous analysis, we can conclude that our linear model is a resonable fit. 

##### Extra

# library(plyr)
# revalue(as.factor(dat$am), c("0"="two", "1"="one"))
# # gg <- ggplot(data = dat,aes(x = value, fill=am)) 
# # gg<-gg + geom_density(alpha=.4) + facet_wrap(~variable, scales = c("free"))
# g <- ggplot(dat, aes(mpg, wt))
# g + facet_grid(. ~ am) + geom_line() + xlab('Weight') + ylab('Weight') + ggtitle('Weight accross different AM') + scale_x_discrete(labels = c('Manual','Automatic'))

pairs(dat, main = "mtcars data", gap = 1/4)