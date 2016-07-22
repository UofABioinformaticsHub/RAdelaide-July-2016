# Group is a factor
group <- factor( c(1,1,2,2) )
model.matrix(~ group)
# Do not need to use formula function as '~' implies this
model.matrix(formula(~ group))

options(useFancyQuotes=FALSE)
sink(file = "./pics/contr-gp.txt")
group <- factor( c(1, 1, 2, 2) )
model.matrix(~ group)
sink()

# Group is not a factor
group <- c(1,1,2,2)
model.matrix(~ group)
# Using different names produces same model.matrix
group <- factor(c("control","control","highfat","highfat"))
model.matrix(~ group)

options(useFancyQuotes=FALSE)
sink(file = "./pics/contr-gpInc.txt")
# Group is not a factor
group <- c(1,1,2,2)
model.matrix(~ group)
cat("\n")
# Using different names produces same model.matrix
group <- factor(c("control","control","highfat","highfat"))
model.matrix(~ group)
sink()

# More groups
group <- factor(c(1,1,2,2,3,3))
model.matrix(~ group)

options(useFancyQuotes=FALSE)
sink(file = "./pics/contr-moregpInc.txt")
group <- factor(c(1,1,2,2,3,3))
model.matrix(~ group)
sink()

# Alternate formulation
group <- factor(c(1,1,2,2,3,3))
model.matrix(~ group + 0)

options(useFancyQuotes=FALSE)
sink(file = "./pics/contr-moregpInc2.txt")
group <- factor(c(1,1,2,2,3,3))
model.matrix(~ group + 0)
sink()

# Effect of diet and difference in sexes
diet <- factor(c(1,1,1,1,2,2,2,2))
sex <- factor(c("f","f","m","m","f","f","m","m"))
table(diet,sex)
# To fit the additive model
diet <- factor(c(1,1,1,1,2,2,2,2))
sex <- factor(c("f","f","m","m","f","f","m","m"))
model.matrix(~ diet + sex)

options(useFancyQuotes=FALSE)
sink(file = "./pics/contr-Add.txt")
diet <- factor(c(1,1,1,1,2,2,2,2))
sex <- factor(c("f","f","m","m","f","f","m","m"))
model.matrix(~ diet + sex)
sink()

model.matrix(~ diet + sex + diet:sex)

model.matrix(~ diet*sex)

options(useFancyQuotes=FALSE)
sink(file = "./pics/contr-Int.txt")
model.matrix(~ diet*sex)
sink()

# Releveling
group <- factor(c(1,1,2,2))
group <- relevel(group, "2")
model.matrix(~ group)
# Providing factor levels
group <- factor(group, levels=c("1","2"))
model.matrix(~ group)

options(useFancyQuotes=FALSE)
sink(file = "./pics/contr-Rel.txt")
group <- factor(c(1,1,2,2))
group <- relevel(group, "2")
model.matrix(~ group)
cat("\n")
group <- factor(group, levels=c("1","2"))
model.matrix(~ group)
sink()

# Finding data
group <- 1:4
model.matrix(~ group, data=data.frame(group=5:8))
# Continuous variables
tt <- seq(0,3.4,len=4)
model.matrix(~ tt + I(tt^2))
# Different contrasts
d <- data.frame(time=factor(1:4))
model.matrix(~time,data=d, contrasts.arg= list(time="contr.sum"))

options(useFancyQuotes=FALSE)
sink(file = "./pics/contr-Dat.txt")
group <- 1:4
model.matrix(~ group, data=data.frame(group=5:8))
cat("\n")
# Continuous variables
tt <- seq(0,3.4,len=4)
model.matrix(~ tt + I(tt^2))
cat("\n")
# Different contrasts
d <- data.frame(time=factor(1:4))
model.matrix(~time,data=d, contrasts.arg= list(time="contr.sum"))
sink()

dat <- read.csv("./data-raw/femaleMiceWeights.csv")
set.seed(1) #same jitter in stripchart
# Plot
ggplot(dat, aes(x=Diet, y=Bodyweight)) + geom_jitter(position=position_jitter(0.2), size=3, shape=21, bg="lightblue") + theme_bw()
# Design
levels(dat$Diet)
X <- model.matrix(~ Diet, data=dat)
head(X)

options(useFancyQuotes=FALSE)
sink(file = "./pics/mouseDesign.txt")
levels(dat$Diet)
X <- model.matrix(~ Diet, data=dat)
head(X)
sink()

dat <- read.csv("./data-raw/femaleMiceWeights.csv")
set.seed(1) #same jitter in stripchart
ggplot(dat, aes(x=Diet, y=Bodyweight)) + geom_jitter(position=position_jitter(0.2), size=3, shape=21, bg="lightblue") + theme_bw()

Y <- dat$Bodyweight
X <- model.matrix(~ Diet, data=dat)
solve(t(X) %*% X) %*% t(X) %*% Y

options(useFancyQuotes=FALSE)
sink(file = "./pics/solve-bw.txt")
Y <- dat$Bodyweight
X <- model.matrix(~ Diet, data=dat)
solve(t(X) %*% X) %*% t(X) %*% Y
sink()

s <- with(dat, split(Bodyweight, Diet))
mean(s[["chow"]])
mean(s[["hf"]]) - mean(s[["chow"]])

options(useFancyQuotes=FALSE)
sink(file = "./pics/coef-bw.txt")
s <- with(dat, split(Bodyweight, Diet))
mean(s[["chow"]])
mean(s[["hf"]]) - mean(s[["chow"]])
sink()

fit <- lm(Bodyweight ~ Diet, data=dat)
summary(fit)
(coefs <- coef(fit))

options(useFancyQuotes=FALSE)
sink(file = "./pics/lm-bw.txt")
fit <- lm(Bodyweight ~ Diet, data=dat)
print(summary(fit), digits = 3)
(coefs <- coef(fit))
sink()

ggplot(dat, aes(x=Diet, y=Bodyweight)) + geom_jitter(position=position_jitter(0.2), size=3, shape=21, bg="lightblue") + theme_bw() + geom_hline(aes(yintercept = 0)) + geom_segment(aes(x=1, y=0, xend=1, yend=23.81), arrow = arrow()) + geom_segment(aes(x=0.9, y=23.81, xend=2.1, yend=23.81)) + geom_segment(aes(x=2, y=23.81, xend=2, yend=26.83), arrow = arrow()) + geom_segment(aes(x=1.9, y=26.83, xend=2.1, yend=26.83))

mytt <- t.test(s[["hf"]], s[["chow"]], var.equal=TRUE)
summary(fit)$coefficients[2, 3]
mytt$statistic

options(useFancyQuotes=FALSE)
sink(file = "./pics/compT-bw.txt")
mytt <- t.test(s[["hf"]], s[["chow"]], var.equal=TRUE)
summary(fit)$coefficients[2, 3]
mytt$statistic
sink()

data(iris)
setosa <- iris[iris$Species == "setosa", ]
plot(setosa[,3], setosa[,4], xlab = "x", ylab = "y", ylim = c(-0.1, 0.65), pch=19, las = 1, cex.lab = 1.2, xlim = c(0, 2))
abline(lm(setosa[,4] ~ setosa[,3]), lwd = 3)

set.seed(123)
x <- runif(50, 10, 30)
y <- rnorm(50, 4 + 0.3*x, 0.5)
plot(x, y, las = 1, main = "small")
abline(lm(y ~ x), lwd = 3)

y2 <- rnorm(50, 4 + 0.3*x, 3)
plot(x, y2, las = 1, main = "large")
abline(lm(y2 ~ x), lwd = 3)

head(mtcars)

options(useFancyQuotes=FALSE)
sink(file = "./pics/cars-data.txt")
print(head(mtcars), digits = 3)
sink()

ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point(size=4, shape=21, bg="lightblue") + theme_bw()

# Example:
fit <- with(mtcars, lm(mpg ~ wt))
summary(fit)
confint(fit)

options(useFancyQuotes=FALSE)
sink(file = "./pics/carsFit.txt")
fit <- with(mtcars, lm(mpg ~ wt))
print(summary(fit), digits = 3)
print(confint(fit), digits = 3)
sink()

ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point(size=4, shape=21, bg="lightblue") + theme_bw() +
    geom_line(aes(x=wt,y=predict(fit))) + annotate("text", x=4, y=30, label = paste("Y = ", round(coef(fit)[1],2), " + ", round(coef(fit)[2],2), "*X", sep = ""), size = 6)

# Call the plot function on model object
plot(fit)

op <- par(no.readonly = TRUE)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1) + 0.1)
plot(fit)
par(op)

# Example:
fit.poly2 <- update(fit, . ~ poly(wt, degree=2))
summary(fit.poly2)
confint(fit.poly2)

options(useFancyQuotes=FALSE)
sink(file = "./pics/carsFit-poly.txt")
fit.poly2 <- update(fit, . ~ poly(wt, degree=2))
print(summary(fit.poly2), digits = 3)
print(confint(fit.poly2), digits = 3)
sink()

op <- par(no.readonly = TRUE)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1) + 0.1)
plot(fit.poly2)
par(op)

# Example:
fit.log <- update(fit, log(mpg) ~ .)
summary(fit.log)
confint(fit.log)

options(useFancyQuotes=FALSE)
sink(file = "./pics/carsFit-log.txt")
fit.log <- update(fit, log(mpg) ~ .)
print(summary(fit.log), digits = 3)
print(confint(fit.log), digits = 3)
sink()

op <- par(no.readonly = TRUE)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1) + 0.1)
plot(fit.log)
par(op)

library(visreg)
visreg(fit, ylim = c(5, 38), ylab = "MPG", xlab = "")
visreg(fit.poly2, ylim = c(5, 38), ylab = "", xlab = "WGT")
visreg(fit.log, "wt", trans = exp, ylim = c(5, 38), partial = TRUE, rug = FALSE, ylab = "", xlab = "")

library(visreg)
op <- par(no.readonly = TRUE)
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1) + 0.1)
visreg(fit, ylim = c(5, 38), ylab = "MPG", xlab = "")
visreg(fit.poly2, ylim = c(5, 38), ylab = "", xlab = "WGT")
visreg(fit.log, "wt", trans = exp, ylim = c(5, 38), partial = TRUE, rug = FALSE, ylab = "", xlab = "")
par(op)

fitShow <- lm(Ozone ~ Solar.R + Wind + Temp, data = airquality)
visreg(fitShow)

op <- par(no.readonly = TRUE)
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1) + 0.1)
fitShow <- lm(Ozone ~ Solar.R + Wind + Temp, data = airquality)
visreg(fitShow)
par(op)

# Add variables to data frame
library(broom)
aug.mtcars <- mtcars %>% do(augment(lm(mpg ~ wt, .)))
head(aug.mtcars)
# Bootstrap model predictions and plot
boot.aug <- mtcars %>% bootstrap(100) %>% do(augment(lm(log(mpg) ~ wt, .)))
ggplot(mtcars, aes(wt, mpg)) + geom_point(size=4, shape=21, bg="lightblue") + theme_bw() +
    geom_line(data = boot.aug, aes(x=wt, y=exp(.fitted), group=replicate), alpha=.2)

options(useFancyQuotes=FALSE)
sink(file = "./pics/cars-aug.txt")
aug.mtcars <- mtcars %>% do(augment(lm(mpg ~ wt, .)))
print(head(aug.mtcars[, 1:6]), digits = 3)
sink()

boot.aug <- mtcars %>% bootstrap(100) %>% do(augment(lm(log(mpg) ~ wt, .)))
ggplot(mtcars, aes(wt, mpg)) + geom_point(size=4, shape=21, bg="lightblue") + theme_bw() +
    geom_line(data = boot.aug, aes(x=wt, y=exp(.fitted), group=replicate), alpha=.2)

mod <- glm(y ~ x, data=yourdata, family=binomial)
summary(mod)
fitted(mod) # gives predicted probabilities

satt <- read.csv("./data-raw/satellites.csv", header = TRUE)
satt$satPresent <- (satt$nsatellites > 0)*1
summary(satt)
satt.binom <- glm(satPresent ~ width.cm, data = satt, family = binomial("logit"))

options(useFancyQuotes=FALSE)
sink(file = "./pics/crabs-head.txt")
print(head(satt), digits = 3)
sink()

options(useFancyQuotes=FALSE)
sink(file = "./pics/crabs-glm.txt")
satt.binom <- glm(satPresent ~ width.cm, data = satt, family = binomial("logit"))
print(summary(satt.binom), digits = 3)
print(confint(satt.binom), digits = 3)
print(drop1(satt.binom, test="Chi"), digits = 4)
sink()

titanic <- read.csv("data-raw/titanic_long.csv")
head(titanic)

options(useFancyQuotes=FALSE)
sink(file = "./pics/tit-glm.txt")
print(head(titanic), digits = 3)
sink()

op <- par(no.readonly = TRUE)
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1) + 0.1)
glm.lr <- glm(survived ~ age + sex + factor(class), family=binomial("logit"), data=titanic)
visreg(glm.lr, scale = "response", partial = TRUE, rug = FALSE, ylim = c(0, 1), ylab = "Survived")
par(op)
