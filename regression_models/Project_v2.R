library(ggplot2)
library(plyr)
library(reshape2)
library(corrplot)

data <- data.frame(mtcars, stringsAsFactors = FALSE) 
data$cyl<-as.factor(data$cyl)
data$am<-as.factor(data$am)
data$id<-c(1:length(data[,1]))
summary(data)


## DESCRIPTIVE STATS
auto_dat <- data[,which(data$am==0)]
mean_mpg_auto <- mean(data[data$am==0,]$mpg)
mean_mpg_manual <- mean(data[data$am==1,]$mpg)

mean_wt_auto <- mean(data[data$am==0,]$wt)
mean_wt_manual <- mean(data[data$am==1,]$wt)

norm_wt <- shapiro.test(data$mpg)
difference_wt_am <- t.test(data[data$am==1,]$mpg,data[data$am==0,]$mpg)

norm_mpg <- shapiro.test(data$wt)
difference_mpg_am <- t.test(data[data$am==1,]$mpg,data[data$am==0,]$mpg)

cyl_lm <- summary(lm(mpg~cyl, data = data))
cyl_lm$coefficients[,1]<-round(cyl_lm$coefficients[,1],1)
cyl_lm$coefficients[,4]<-round(cyl_lm$coefficients[,4],4)
## CORRELATIONS
d <- data[!names(data) %in% c('vs', 'am', 'cyl', 'id')]
cor.mtest <- function(mat, conf.level = 0.95) {
mat <- as.matrix(mat)
n <- ncol(mat)
p.mat <- lowCI.mat <- uppCI.mat <- matrix(NA, n, n)
diag(p.mat) <- 0
diag(lowCI.mat) <- diag(uppCI.mat) <- 1
for (i in 1:(n - 1)) {
for (j in (i + 1):n) {
tmp <- cor.test(mat[, i], mat[, j], conf.level = conf.level)
p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
lowCI.mat[i, j] <- lowCI.mat[j, i] <- tmp$conf.int[1]
uppCI.mat[i, j] <- uppCI.mat[j, i] <- tmp$conf.int[2]
}
}
return(list(p.mat, lowCI.mat, uppCI.mat))
}
sig_val <- 0.05## above this value it won't show correlation
res1 <- cor.mtest(d[-length(data)], 0.95)
cor_mtx<-round(cor(d, method = 'pearson'),2)

# SIPLE LINEAR REGRESSION MODELS
vars<-c(names(data))
mods<-data.frame(Variable = numeric(0), Coefficient = numeric(0), Std_Error = numeric(0), t_value = numeric(0), P_value = numeric(0))
for (i in 1:length(vars)){
    if (i>1){
        p<-lm(as.formula(paste('mpg ~',vars[i])), data=data)
        coeff<-summary(p)$coefficients
        mods[i-1,]<-c(vars[i],round(coeff[2,1:3], 3),coeff[2,4])
    } 
}

## sort models by coefficient ("effect" on MPG) and p-value 
mods[,2:5]<-as.numeric(as.matrix(mods[,2:5]))
mods.important<-arrange(mods, Coefficient, P_value)
var.imp<-mods.important[,1]
# MULTIVARIATE MODEL
fit1 <- lm(mpg ~ wt, data = data)
fit2 <- update(fit1, mpg ~ wt + am)
anv1<-anova(fit1, fit2)
fit3 <- update(fit1, mpg ~ wt * am)
anv2<-anova(fit1, fit3)
```

### Results
Cars with manual transmission travel an average `r round(mean_mpg_manual, 1)` miles/gallon compared to `r round(mean_mpg_auto, 1)` miles/gallon in those with automatic transmission (difference: `r round((mean_mpg_manual - mean_mpg_auto),1)`, 95% CI: `r round(difference_mpg_am$conf.int[1],1)` - `r round(difference_mpg_am$conf.int[2],1)` , p = `r round(difference_mpg_am$p.value,4)`). 

The distribution of continous varibles by type of transmission is shown in **Figure 1**. Variables that showed significant association with MPG were: cylinder (mean cyl-4: `r cyl_lm$coefficients[1,1]`; mean cyl-6: `r cyl_lm$coefficients[2,1]`, p = `r cyl_lm$coefficients[2,4]`; mean cyl-8: `r cyl_lm$coefficients[3,1]`, p = `r cyl_lm$coefficients[3,4]`), displacement (*r* = `r cor_mtx['disp','mpg']`, p = `r round(res1[[1]][2,1],3)`), horsepower (*r* = `r cor_mtx['hp','mpg']`, p = `r round(res1[[1]][3,1],6)`), rear axle ratio (*r* = `r cor_mtx['drat','mpg']`, p = `r round(res1[[1]][4,1],6)`), number of forward gears (*r* = `r cor_mtx['gear','mpg']`, p = `r round(res1[[1]][7,1],6)`), 1/4 mile time (*r* = `r cor_mtx['qsec','mpg']`, p = `r round(res1[[1]][6,1],6)`), carburetors (*r* = `r cor_mtx['hp','mpg']`, p = `r round(res1[[1]][8,1],6)`) and weight (*r* = `r cor_mtx['wt','mpg']`, p = `r round(res1[[1]][5,1],6)`) (**Figure 2**).   Based on these findings and after performing simple (single explanatory variable) regression analyses (**Table 1**) ***the variable that best explained MPG was the WEIGHT of the car.***
    
    All continuous variables, except 1/4 mile time, were also associated with the weight of the car (**Figure 2**). Also, the cars with manual transmission, on average, weighted less (weight = `r round(mean_wt_manual, 1)` ) than those with automatic transmission (weight = `r round(mean_wt_auto, 1)`; difference: `r round((mean_wt_auto - mean_wt_manual),1)`  95% CI, `r round(difference_wt_am$conf.int[1],1)` - `r round(difference_wt_am$conf.int[2],1)` , p = `r round(difference_wt_am$p.value,4)`). These findings suggest interaction between weight and type of transmission to explain MPG. 

Sequential testing of models showed that weight was the variable that best explained MPG (**Model 1**).    

#### MODEL 1. $MPG = B_0 + B_1*Weight$
```{r echo = F}
summary(fit1)$coefficients
paste(c(paste(c('Adj. R-squared', round(summary(fit1)$adj.r.squared,2)), collapse = ': '), 
        paste(c('Residual SD', round(sd(fit1$residuals),2)), collapse = ': ')), collapse = ', ')

```

The addition of the variable "transmission" to Model 1 to create Model 2 showed that the type of transmission is not a significant variable to explain MPG (**Model 2**). Furthermore, the explanatory effect that the variable transmission has over MPG is mostly due to its relation to weight which was described above (manual cars are significantly lighter than larger cars) (**Figure 2**).    

#### MODEL 2. $MPG = B_0 + B_1*Weight + B_2*Transmission$
```{r echo = F}
summary(fit2)$coefficients
paste(c(paste(c('Adj. R-squared', round(summary(fit2)$adj.r.squared,2)), collapse = ': '), 
        paste(c('Residual SD', round(sd(fit2$residuals),2)), collapse = ': ')), collapse = ', ')
print('Analysis of Variance Model 1 vs. Model 2')
paste(c(paste(c('RSS Model 1', round(anv1$RSS[1],2)), collapse = ': '),
        paste(c('RSS Model 2', round(anv1$RSS[2],2)), collapse = ': '),
        paste(c('P-value', round(anv1[2,'Pr(>F)'],4)), collapse = ': ')), collapse = ', ')

```

However, as illustrated in **Figure 2**, there appears to be an interaction between weight and type of transmission to explain MPG. This is seen in the different slopes for weight for each type of transmission, with manual transmission showing a greater decrease in MPG as the weight of the car increases. Model 3 includes a term to control for this interaction (weight\*transmission) (**Model 3**). In this models all coefficients are significant and ANOVA shows that the inclusion of this interaction term reduces RSS significantly reduces the unexplained variation in the model. The interaction is illustrated in **Figure 3**.  Additional diagnostic plot are shown in **Figure 4**. Model 3 shows that for manual cars, for every unit increase in weight, there is an average drop of `r round(abs(summary(fit3)$coefficients[2,1])+abs(abs(summary(fit3)$coefficients[4,1])),2)` miles/gallon, compared to a drop of  `r round(abs(summary(fit3)$coefficients[2,1]))`. 

#### MODEL 3. $MPG = B_0 + B_1*Weight + B_2*Transmission + B_3*Weight*Transmission$
```{r echo = F}
summary(fit3)$coefficients
paste(c(paste(c('Adj. R-squared', round(summary(fit3)$adj.r.squared,2)), collapse = ': '), 
        paste(c('Residual SD', round(sd(fit3$residuals),2)), collapse = ': ')), collapse = ', ')
print('Analysis of Variance Model 1 vs. Model 2')
paste(c(paste(c('RSS Model 1', round(anv2$RSS[1],2)), collapse = ': '),
        paste(c('RSS Model 2', round(anv2$RSS[2],2)), collapse = ': '),
        paste(c('P-value', round(anv2[2,'Pr(>F)'],4)), collapse = ': ')), collapse = ', ')
```

In summary, manual cars are on average more efficient (give more MPG) than automatic cars. This can be explained in part by the finding that manual cars are also significantly lighter than automatic cars and that the heavier cars produce significantly less MPG. Even though manual cars tend to be more efficient, any unit increase in weight will affect more the MPG than for automatic cars (`r round(abs(summary(fit3)$coefficients[2,1])+abs(abs(summary(fit3)$coefficients[4,1])),2)` miles/gallon drop/unit of weight vs. `r round(abs(summary(fit3)$coefficients[2,1])) ` miles/gallon drop/unit of weight)

### FIGURE 1. Continuous variable distributions by type of transmission. 0 = automatic, 1 = manual.
```{r, echo=FALSE, warning=FALSE, message=FALSE, tidy=TRUE, fig.width=6, fig.height=4}
d <- cbind(melt(data))
gg <- ggplot(data = d,aes(x = value, fill=am)) 
gg<-gg + geom_density(alpha=.4) + facet_wrap(~variable, scales = c("free"))
gg
#dd<-pairs(data, panel = panel.smooth, main = "Swiss data", col = 3)
```  

### FIGURE 2. Correlation map for continous variables. Non-signoficant correlations appear blank.
```{r, echo=FALSE, warning=FALSE, message=FALSE, fig.width=3.4, fig.height=3.4}
#### CORPLOT WITH H-CLUSTRING
corrplot.mixed(cor_mtx, lower = "number", upper = "square",
               tl.pos = c("d","lt","n"), diag = c("n","l","u"), 
               bg = "white", order = "hclust", p.mat = res1[[1]], sig.level = sig_val, insig = "blank")
```

### TABLE 1. Simple regression models with each variable against MPG as outcome variable.
```{r, echo=FALSE, warning=FALSE, message=FALSE, fig.width=6, fig.height=6}
mods
```


### FIGURE 3. Model 3. Miles per gallon by weight of car for manual (red) and automatic (black) transmission. Blue points represent predicted (y-hay) values from Model 3. Solid horizontal and veritical lines represent MPG and weight means respectively.
```{r, echo=FALSE, warning=FALSE, message=FALSE, fig.width=6, fig.height=6}
lmA <- lm(data$mpg[data$am=="0"] ~ data$wt[data$am=="0"])
lmM <- lm(data$mpg[data$am=="1"] ~ data$wt[data$am=="1"])
plot(data$wt,data$mpg,pch=19, xlab='Weight lb/1000', ylab='Miles per gallon')
points(data$wt,data$mpg,pch=19,col=((data$am=="1")*1+1))
lines(data$wt[data$am=="0"],lmA$fitted,col="black",lwd=3)
lines(data$wt[data$am=="1"],lmM$fitted,col="red",lwd=3)
points(data$wt,fit3$fitted,col="blue",lwd=2)
abline(h=mean(data$mpg), v=mean(data$wt))
abline(h=mean_mpg_manual, col = "red", lty=2)
abline(h=mean_mpg_auto, , lty=2)
text(5,mean(data$mpg[data$am==1])+1,'Mean MPG in manual')
text(5,mean(data$mpg[data$am==0])+1,'Mean MPG in automatic')
#abline(fit_base)
```


### FIGURE 4. Diagnostic plots for Model 3.
```{r, echo=FALSE, warning=FALSE, message=FALSE, tidy=TRUE, fig.width=6, fig.height=4.5, fig.cap='sss'}
op <- par(mfrow = c(2, 2))   
plot(fit3)
```
