# Analyzing ToothGrowth data  in R for basic exploratory data analysis. The data was explored and checked for different columns values.
# We tried to find some basic relationships between the columns using plots, confidence Intervals for

# We're going to analyze the ToothGrowth data in the R datasets package. Load the ToothGrowth data and
# perform some basic exploratory data analyses Provide a basic summary of the data. Use confidence intervals
# and hypothesis tests to compare tooth growth by supp and dose.State your conclusions and the assumptions
# needed for your conclusions.
# Data load and expl

# Load the ToothGrowth data and perform some basic exploratory data analyses
# Provide a basic summary of the data.
# Use confidence intervals and/or hypothesis tests to compare tooth growth by supp and dose. (Only use the techniques from class, even if there's other approaches worth considering)
# State your conclusions and the assumptions needed for your conclusions.

library(datasets)
library(ggplot2)

# Data load and exploratory analysis
data(ToothGrowth)

head(ToothGrowth)
summary(ToothGrowth)
str(ToothGrowth)

table(ToothGrowth$supp) # Supplement
table(ToothGrowth$dose) # Dosage


# Plot Tooth length vs. Dosage (mg) split by Supplement Type (OJ or VC)
gg = ggplot(data=ToothGrowth, aes(x=as.factor(dose), y=len, fill=supp))
gg = gg + geom_bar(stat="identity") + facet_grid(. ~ supp) + xlab("Dose (mg)") +
    ylab("Tooth length") + guides(fill=guide_legend(title="Supplement type"))
print(gg)

# The plot shows that length of tooth is greater when supplement OJ is given
p1 <- ggplot(ToothGrowth, aes(x =factor(supp), y = len, fill = factor(supp)))
p1 + geom_boxplot() + xlab("Dosage") + ylab("Length")

cor(ToothGrowth[sapply(ToothGrowth, is.numeric)])
# Tthe plot shows more clearly that as the dosage increases, the length of the tooth increases.
p1 <- ggplot(ToothGrowth, aes(x =factor(dose), y = len, fill = factor(dose)))
p1 + geom_boxplot() + xlab("Dosage") + ylab("Length")

#2. Use confidence intervals and hypothesis tests to compare tooth growth by supp and dose*
# The 95% Confidence Intervals of Tooth Grow
Interval <- (mean(ToothGrowth$len) + c(-1, 1) * qnorm(0.975) * sd(ToothGrowth$len)/sqrt(length(ToothGrowth$len)))
Interval

#T-Test for mean difference by supplement type
t.test(len~supp, data=ToothGrowth)
# p-value is not small and the confidence interval contains 0, i.e. we cannot reject null hypothesis. 

# T-Test for mean difference by dosage level
dose1 <- subset(ToothGrowth,dose %in% c(0.5,1.0))
dose2 <- subset(ToothGrowth,dose %in% c(0.5,2.0))
dose3 <- subset(ToothGrowth,dose %in% c(1.0,2.0))

t.test(len ~dose, data = dose1)
t.test(len ~dose, data = dose2)
t.test(len ~dose, data = dose3)
# Each of the above have very small p-values which means the null hypothesis can be rejected.

# T-Test of Dosage Level
dos1 <- subset(ToothGrowth, dose == 0.5)
dos2 <- subset(ToothGrowth, dose == 1)
dos3 <- subset(ToothGrowth, dose == 2)

t.test(len~supp, data=dos1) # Small Dosage = 0.5
t.test(len~supp, data=dos2) # Medium Dosage = 1
t.test(len~supp, data=dos3) # Big Dosage = 2

# 
# - For Small and Medium dosage, their p-values are small, so we can reject the null hypothesis
# - For Big Dosage, we cannot reject the null hypothesis


# Assumption
# 1.Experiment assumed IID samples
# 2.Sample is representative of the population

# 
# *3. State your conclusions and the assumptions needed for your conclusions*
#     
#     - The Tooth Length Growth is not controlled by Supplements.
# - For dosage level 0.5 and 1, the Orange Juice has a higher effect on the length of tooth of Guinea Pigs than the Vitamin C.
# - For dosage level 2, there are so such difference between Orange Juice and Vitamin C

# 1. No difference by supplement type i.e. OJ or VC do not have any effect independently on tooth length
# growth
# 2. Dosage levels on their own have a significant effect on growth of tooth length
# 3. For dosage levels 0.5 and 1.0, the supplement OJ has a greater effect on tooth length growth than the
# supplement VC. And for the dosage level 2.0, there is no difference in effect of supplements OJ or VC
# on tooth length growth.