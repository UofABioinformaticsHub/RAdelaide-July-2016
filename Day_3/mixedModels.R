response ~ expr

response ~ FEexpr + (REexpr1 | factor1) + (REexpr2 | factor2) + ...

plants <- read.csv("data-raw/nestedGrowth.csv")
head(plants)
# Set Control group as reference level
plants$Treatment <- with(plants, relevel(Treatment, ref = "Control"))
# Plot data
plantPlot <- ggplot(data=plants, aes(x=Pot, y=Growth,color=Treatment, group=Pot)) + theme_bw()
plantPlot + geom_point(size=3)

options(useFancyQuotes=FALSE)
sink(file = "./pics/plants-data.txt")
print(head(plants), digits = 3)
sink()

plantPlot <- ggplot(data=plants, aes(x=Pot, y=Growth,color=Treatment, group=Pot)) + theme_bw()
plantPlot + geom_point(size=3)

stat_sum_single <- function(fun, geom="point", ...) {
  stat_summary(fun.y=fun, shape=17, geom=geom, size=6, ...)
}
plantPlot+ geom_point(alpha=0.3) + stat_sum_single(mean)
# ANOVA
library(car)
library(dplyr)
meanPlants <- plants %>% group_by(Pot, Treatment) %>% summarise(Growth = mean(Growth))
plantGrowth <- lm(Growth ~ Treatment, data = meanPlants)
Anova(plantGrowth)

options(useFancyQuotes=FALSE)
sink(file = "./pics/plants-anova.txt")
print(Anova(plantGrowth))
sink()

plantPlot + geom_point(alpha=0.3) + stat_sum_single(mean)

plantAOV <- aov(Growth ~ Treatment + Error(Pot), data = plants)
summary(plantAOV)

options(useFancyQuotes=FALSE)
sink(file = "./pics/plants-aov.txt")
print(summary(plantAOV))
sink()

op <- par(no.readonly = TRUE)
par(mfrow = c(1, 1), mar = c(4, 4, 2, 1) + 0.1, las = 1)
x <- seq(-4,4,.01)
y <- dnorm(x, 1)
z <- rnorm(24, 1)
plot(c(1,1), c(0,0.5), type="l", lwd=5, xlab="Mean", xlim=c(-4,4), ylab="Probability")
text(1.7, 0.45, expression(mu[b]), cex=1.5)
for(i in 1:length(z)) lines(c(z[i],z[i]), c(0,0.1), lwd=2, col="blue")
matplot(x,y, type="l", add=T, lwd=3, lty=2)
par(op)

plantLMM <- lmer(Growth ~ Treatment + (1 | Pot), data=plants)
summary(plantLMM)

options(useFancyQuotes=FALSE)
sink(file = "./pics/plants-lmm.txt")
print(summary(plantLMM))
sink()

options(useFancyQuotes=FALSE)
plantLMM.Ests <- as.data.frame(cbind(round(coef(plantLMM)$Pot, 3), round(ranef(plantLMM)$Pot, 3)))
names(plantLMM.Ests)[4] <- "BLUP.Random.Intercepts"
sink(file = "./pics/plants-lmm-coef.txt")
print(plantLMM.Ests)
sink()

plantLMM.Ests <- as.data.frame(cbind(round(coef(plantLMM)$Pot, 3), round(ranef(plantLMM)$Pot, 3)))
names(plantLMM.Ests)[4] <- "BLUP.Random.Intercepts"
print(plantLMM.Ests)

plantLMM2 <- lmer(Growth ~ 0 + Treatment + (1 | Pot), data=plants)
summary(plantLMM2)
# Fixed effect estimates
fixDF <- data.frame(summary(plantLMM2)$coef)
fixDF$Treatment <- factor(gsub("Treatment", "", rownames(fixDF)), levels = c("Add C", "Control", "Add N"))
# Random effect BLUPs
ranDF <- data.frame(Estimate = unlist(ranef(plantLMM, condVar = TRUE)$Pot) + rep(fixDF$Estimate[c(2, 1, 3)], rep(4, 3)))
ranDF$Treatment <- factor(as.character(meanPlants$Treatment), levels = c("Add C", "Control", "Add N"))
# Plot
p <- ggplot(fixDF, aes(x=Treatment, y=Estimate, color=Treatment)) +
  theme_bw() +
  ylab("Growth") +
  geom_errorbar(aes(ymin=Estimate-Std..Error*2, ymax=Estimate+Std..Error*2), width = 0.2) +
  geom_point(shape = 17, size = 6) +
  ggtitle("Fixed effects and BLUPs of random effects")
p + geom_point(mapping = aes(x=Treatment, y=Estimate), data = ranDF, size=4, alpha = 0.4)

plantLMM2 <- lmer(Growth ~ 0 + Treatment + (1 | Pot), data=plants)
summary(plantLMM2)
fixDF <- data.frame(summary(plantLMM2)$coef)
fixDF$Treatment <- factor(gsub("Treatment", "", rownames(fixDF)), levels = c("Add C", "Control", "Add N"))
ranDF <- data.frame(Estimate = unlist(ranef(plantLMM, condVar = TRUE)$Pot) + rep(fixDF$Estimate[c(2, 1, 3)], rep(4, 3)))
ranDF$Treatment <- factor(as.character(meanPlants$Treatment), levels = c("Add C", "Control", "Add N"))
p <- ggplot(fixDF, aes(x=Treatment, y=Estimate, color=Treatment)) +
  theme_bw() +
  ylab("Growth") +
  geom_errorbar(aes(ymin=Estimate-Std..Error*2, ymax=Estimate+Std..Error*2), width = 0.2) +
  geom_point(shape = 17, size = 6) +
  ggtitle("Fixed effects and BLUPs of random effects")
p + geom_point(mapping = aes(x=Treatment, y=Estimate), data = ranDF, size=4, alpha = 0.4)

# Plot residuals vs fitted values
plot(fitted(plantLMM), residuals(plantLMM), xlab="Fitted values", ylab="Residuals", pch=21, bg="lightblue")
abline(a=0, b=0, col="black", lty=2)
# Q-Q plot of residuals
qqnorm(residuals(plantLMM,  type="pearson"), main="", pch=21, bg="lightblue")
qqline(residuals(plantLMM,  type="pearson"))

op <- par(no.readonly = TRUE)
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1) + 0.1)
plot(fitted(plantLMM), residuals(plantLMM), xlab="Fitted values", ylab="Residuals", pch=21, bg="lightblue")
abline(a=0, b=0, col="black", lty=2)
qqnorm(residuals(plantLMM,  type="pearson"), main="", pch=21, bg="lightblue")
qqline(residuals(plantLMM,  type="pearson"))
par(op)

# Plot residuals vs fitted values at group level
plot(predict(plantLMM2, re.form=~0), plants$Growth - predict(plantLMM2, re.form=~0), xlab="Group-level fitted values", ylab="Group-level residuals", pch=21, bg="lightblue")
abline(a=0, b=0, col="black", lty=2)
# Q-Q plot of random effects
r <- unlist(ranef(plantLMM, condVar = TRUE)$Pot)
qqnorm(r/sd(r), main="", pch=21, bg="lightblue")
qqline(r/sd(r))

op <- par(no.readonly = TRUE)
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1) + 0.1)
plot(predict(plantLMM2, re.form=~0), plants$Growth - predict(plantLMM2, re.form=~0), xlab="Group-level fitted values", ylab="Group-level residuals", pch=21, bg="lightblue")
abline(a=0, b=0, col="black", lty=2)
r <- unlist(ranef(plantLMM, condVar = TRUE)$Pot)
qqnorm(r/sd(r), main="", pch=21, bg="lightblue")
qqline(r/sd(r))
par(op)

library(lattice)
qqmath(ranef(plantLMM, condVar = TRUE), strip = FALSE)
# Test for heterogeneity
library(RLRsim)
exactRLRT(plantLMM)

options(useFancyQuotes=FALSE)
sink(file = "./pics/plants-rlrt.txt")
print(exactRLRT(plantLMM))
sink()

library(lattice)
qqmath(ranef(plantLMM, condVar = TRUE), strip = FALSE)

# Global testing for fixed effects
drop1(plantLMM, test = "Chisq")
# Using contrasts for planned comparisons
library(lsmeans)
trt.lsm <- lsmeans(plantLMM, "Treatment")
contrast(trt.lsm, "trt.vs.ctrl", adjust = "none")
# Calculating bootstrap confidence intervals - parameter contrasts
confint(plantLMM, method = "boot", boot.type = "basic", nsim = 100, parallel = "multicore", ncpus = 8)
# Calculating bootstrap confidence intervals - Treatment means
confint(plantLMM2, method = "boot", boot.type = "basic", nsim = 100, parallel = "multicore", ncpus = 8)

options(useFancyQuotes=FALSE)
sink(file = "./pics/plants-lmm-infTests.txt")
# Global testing for fixed effects
drop1(plantLMM, test = "Chisq")
# Using contrasts for planned comparisons
cat("\n")
library(lsmeans)
trt.lsm <- lsmeans(plantLMM, "Treatment")
contrast(trt.lsm, "trt.vs.ctrl", adjust = "none")
cat("\n")
# Calculating bootstrap confidence intervals - parameter contrasts
confint(plantLMM, method = "boot", boot.type = "basic", nsim = 100, parallel = "multicore", ncpus = 8)
cat("\n")
# Calculating bootstrap confidence intervals - Treatment means
confint(plantLMM2, method = "boot", boot.type = "basic", nsim = 100, parallel = "multicore", ncpus = 8)
sink()

#+BEGIN_SRC R :results output raw :exports both
lm.simple <- lm(Reaction ~ Days, data=sleepstudy)
summary(lm.simple)

options(useFancyQuotes=FALSE)
sink(file = "./pics/slp-lm.txt")
print(summary(lm.simple), digits = 3)
sink()

ggplot(sleepstudy, aes(Days, Reaction)) + geom_point(size=4, shape=21, bg="lightblue") + theme_bw(base_size = 16) + xlab("Days of sleep deprivation") + ylab("Average reaction time (ms)") + scale_x_continuous(breaks=seq(0,8,by=2)) + geom_smooth(method='lm')

#+BEGIN_SRC R :results output raw :exports both
lm.complete <- lm(Reaction ~ 0 + factor(Subject) + Days, data=sleepstudy)
summary(lm.complete)

options(useFancyQuotes=FALSE)
sink(file = "./pics/slpFx-lm.txt")
print(summary(lm.complete), digits = 3)
sink()

p <- ggplot(sleepstudy, aes(Days, Reaction, group=Subject, color=Subject)) + geom_point(size=4, shape=21, bg="lightblue") +
    theme_bw(base_size = 16) + xlab("Days of sleep deprivation") + theme(legend.key.size = unit(0.15, "cm")) +
    ylab("Average reaction time (ms)") +
    scale_x_continuous(breaks=seq(0,8,by=2))
adf2 <- data.frame(intercept=coef(lm.complete)[1:18], slope=rep(coef(lm.complete)[19], 18))
p + geom_abline(data=adf2, mapping=aes(intercept=intercept, slope=slope), color="grey40")

#+BEGIN_SRC R :results output raw :exports both
fm.rInt <- lmer(Reaction ~ Days + (1 | Subject), sleepstudy)
summary(fm.rInt)

options(useFancyQuotes=FALSE)
sink(file = "./pics/slpFxInt-lm.txt")
print(summary(fm.rInt), digits = 3)
sink()

p <- ggplot(sleepstudy, aes(Days, Reaction, group=Subject, color=Subject)) + geom_point(size=4, shape=21, bg="lightblue") +
    theme_bw(base_size = 16) + xlab("Days of sleep deprivation") +
    ylab("Average reaction time (ms)") + theme(legend.key.size = unit(0.15, "cm")) +
    scale_x_continuous(breaks=seq(0,8,by=2))
adf4 <- as.data.frame(coef(fm.rInt)$Subject)
names(adf4)[1] <- "Intercept"
p + geom_abline(data=adf4, mapping=aes(intercept=Intercept, slope=Days), color="grey40")

fm.rIntSlp <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
summary(fm.rIntSlp)

options(useFancyQuotes=FALSE)
sink(file = "./pics/slpFxIntSlp-lm.txt")
print(summary(fm.rIntSlp), digits = 3)
sink()

p <- ggplot(sleepstudy, aes(Days, Reaction, group=Subject, color=Subject)) + geom_point(size=4, shape=21, bg="lightblue") +
    theme_bw(base_size = 16) + xlab("Days of sleep deprivation") +
    ylab("Average reaction time (ms)") + theme(legend.key.size = unit(0.15, "cm")) +
    scale_x_continuous(breaks=seq(0,8,by=2))
adf5 <- as.data.frame(coef(fm.rIntSlp)$Subject)
names(adf5)[1] <- "Intercept"
p + geom_abline(data=adf5, mapping=aes(intercept=Intercept, slope=Days), color="grey40")

fm1 <- lmer(Reaction ~ Days + (Days|Subject), sleepstudy)
fm1.ci <- confint(fm1, method="boot")
fm1.ci

library(lmerTest)
m <- lmer(dv ~ x1 + (x1 | g), data=df)
summary(m)

rikz <- read.csv("./data-raw/rikz.csv")
rikz$Beach <- as.factor(rikz$Beach)
rikz$angleRad <- rikz$angle1*pi/180
rikz$angleRad
mod1_glmer <- glmer(Richness ~ NAP*angleRad + (1|Beach), data=rikz, family="poisson")
summary(mod1_glmer)
anova(mod1_glmer, type = 'm')

options(useFancyQuotes=FALSE)
sink(file = "./pics/rikz-lmer.txt")
print(summary(mod1_glmer), digits = 3)
sink()

ggplot(aes(NAP, Richness, group=Beach, color=Beach), data=rikz) + theme_bw() + geom_point(size=4)

# Random intercepts using sim from the arm package
library(arm)
n.sim <- 1000
simu <- sim(mod1_glmer, n.sims=n.sim)
# Intercept
ranInt <- as.data.frame(t(apply(simu@ranef$Beach[, , 1], 2, quantile, prob=c(0.025, 0.5, 0.975))))
names(ranInt) <- c("lwr", "fit", "upr")
ranInt$Beach <- paste("b", 1:9, sep = "")

ggplot(ranInt, aes(Beach, fit)) + geom_errorbar(aes(ymin=lwr, ymax=upr), width = 0.2) + geom_point(size=4, shape=21, bg="lightblue") + theme_bw() +
    ylab("Conditional modes of random intercepts")

# mod1_glmer_ci <- confint(mod1_glmer, method="boot")
mod1_glmer_ci

# Predict fixed effects
coeff <- as.data.frame(t(apply(simu@fixef, 2, quantile, prob=c(0.025, 0.5, 0.975))))
names(coeff)[1:3] <- c('lwr', 'fit', 'upr')
coeff$term <- row.names(coeff)
coeff$term[1] <- "Intercept"
coeff$term <- factor(coeff$term, levels=c("Intercept", "NAP", "angleRad", "NAP:angleRad"))
summary(coeff)

ggplot(coeff, aes(x=term, y=fit)) + geom_point(size=4, shape=21, bg="lightblue") +
  geom_errorbar(aes(ymin=lwr, ymax=upr), width = 0.2) +
  labs(x="Fixed effect", y="Estimate w/ 95% CI") +
    theme_bw()

# plotting the effect of NAP on the richness
nsim <- 1000
bsim <- sim(mod1_glmer, n.sim=nsim)
newdat <- data.frame(NAP=seq(-1.5, 2.5, length=100), angleRad=mean(rikz$angleRad))
Xmat <- model.matrix(~NAP*angleRad, data=newdat)
predmat <- matrix(ncol=nsim, nrow=nrow(newdat))
predmat <- apply(bsim@fixef, 1, function(x) exp(Xmat%*%x))
newdat$lwr <- apply(predmat, 1, quantile, prob=0.025)
newdat$upr <- apply(predmat, 1, quantile, prob=0.975)
newdat$Richness <- apply(predmat, 1, quantile, prob=0.5)

prednapPlot <- ggplot(aes(NAP, Richness), data=rikz) + theme_bw() + geom_point(size=4, shape=21, bg="lightblue") + geom_ribbon(aes(ymin=lwr, ymax=upr), data=newdat, alpha = 0.3)
prednapPlot

# lmer
fm.rIntSlp <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
summary(fm.rIntSlp)
# lme
fm.rIntSlp <- lme(Reaction ~ Days, random = ~ Days | Subject, sleepstudy)
summary(fm.rIntSlp)

##----------------------------------------------------------------------------------------------------
## Challenge
##----------------------------------------------------------------------------------------------------

mouse <- read.csv("./data-raw/mouse.csv")
summary(mouse)

ggplot(data=mouse,mapping=aes(x=day,y=wt,color=mweight,group=ind))+
  geom_line()+facet_wrap(~cage)


h4 <- lme(wt~day+lsize,random=~day|cage/ind,data=mouse,method="ML",
          control=lmeControl(maxIter=500,msMaxIter=500,opt='optim'))
summary(h4)

plot(h4, wt ~ fitted(.) | cage, abline = c(0,1))

plot(h4, residuals(.) ~ fitted(.) | cage, abline = c(0,0))


## Note that cage/ind means that individual is nested within cage.
## Is more of the random variation in growth at the maternal level or the individual level?

h5 <- lme(wt~poly(day,2)+lsize,random=~day|cage/ind,data=mouse,method="ML",
            control=lmeControl(maxIter=500,msMaxIter=500,opt="optim"))
summary(h5)

plot(h5, wt ~ fitted(.) | cage, abline = c(0,1))

plot(h5, residuals(.) ~ fitted(.) | cage, abline = c(0,0))


h6 <- lme(wt~poly(day,2)+lsize,random=~poly(day,2)|cage/ind,data=mouse,method="ML",
            control=lmeControl(maxIter=500,msMaxIter=500,opt="optim"))
summary(h6)

plot(h6, wt ~ fitted(.) | cage, abline = c(0,1))

plot(h6, residuals(.) ~ fitted(.) | cage, abline = c(0,0))


plot(ACF(h6))


h7 <- lme(wt~poly(day,2)+lsize,random=~poly(day,2)|cage/ind,data=mouse,method="ML",
          corr=corARMA(p=0,q=4,form=~day),
          control=lmeControl(maxIter=500,msMaxIter=500,opt="optim"))
summary(h7)

plot(h7, wt ~ fitted(.) | cage, abline = c(0,1))


plot(h7, residuals(.) ~ fitted(.) | cage, abline = c(0,0))

h8 <- lme(wt~poly(day,2)+lsize,random=~poly(day,2)|cage/ind,data=mouse,method="ML",
          corr=corCAR1(form=~day),
          control=lmeControl(maxIter=500,msMaxIter=500,opt="optim"))
summary(h8)

plot(h8, wt ~ fitted(.) | cage, abline = c(0,1))

plot(h8, residuals(.) ~ fitted(.) | cage, abline = c(0,0))

anova(h4,h5,h6,h7,h8)


plot(h7,fitted(.)~day|cage)



