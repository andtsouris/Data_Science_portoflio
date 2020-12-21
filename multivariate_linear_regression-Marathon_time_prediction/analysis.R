rm(list=ls())
library(tidyverse)

setwd('C:/Users/33767/Desktop/GitHub portfolio/Marathon times/')

dat <- read.csv('./data/MarathonData.csv') %>% select(-Marathon) %>%
  mutate(cycling = as.numeric(as.character(extract_numeric(CrossTraining)))) %>% 
  select(-CrossTraining, -Name, -CATEGORY, -Category) %>% 
  filter(sp4week <100)
dat$cycling[is.na(dat$cycling)] <- 0

dat2 <- data.frame(sapply(dat, 'as.numeric'))
pairs(dat2)

train <- sample_n(dat2, ceiling(nrow(dat2)*0.75))
test <- dat %>% filter(!(id %in% train$id))
regr <- lm(formula = MarathonTime ~ km4week + sp4week + cycling, data = train)
plot(regr)
tested <- test%>%
  mutate(predicted = predict(regr, test)) %>% 
  mutate(residuals = abs(MarathonTime-predicted))
ggplot(tested, aes(x=residuals))+
  geom_density()
ggplot(tested, aes(x=MarathonTime, y=predicted))+
  geom_point()

#https://data.library.virginia.edu/getting-started-with-multivariate-multiple-regression/
#https://data.library.virginia.edu/diagnostic-plots/

MAE <- mean(tested$residuals) # Mean absolute error
MAE
accuracy10 <- nrow(filter(tested, residuals<0.1/60*100))/nrow(tested)#10 minute accuracy
accuracy15 <- nrow(filter(tested, residuals<0.15/60*100))/nrow(tested)#15 minute accuracy
accuracy20 <- nrow(filter(tested, residuals<0.2/60*100))/nrow(tested)#20 minute accuracy
tested <- tested %>% mutate(ten=ifelse(residuals<0.1/60*100, yes=1, no=0),
                            fifteen=ifelse(residuals<0.15/60*100, yes=1, no=0),
                            twenty=ifelse(residuals<0.2/60*100, yes=1, no=0))
accuracies <- {}
for (cur_threshold in seq(1,45)) {
  cur_accuracy <- nrow(filter(tested, residuals<cur_threshold/60))/nrow(tested)
  accuracies <- accuracies %>% rbind(
    data.frame(threshold = cur_threshold, accuracy=cur_accuracy)
  )
}

ggplot(accuracies, aes(x=threshold, y=accuracy))+
  #geom_point()+
  geom_smooth(span=0.2)+scale_y_continuous(breaks=seq(0,1,by=0.2))
#at the 19 minute threshold we have the first 90% accuracy
# the most important variable is sp4weeks prior to the race
anova(regr)

ggplot(dat2, aes(x=MarathonTime))+
  geom_density()
ggplot(dat2, aes(x=km4week))+
  geom_density()
ggplot(dat2, aes(x=km4week, y=MarathonTime))+
  geom_point()

