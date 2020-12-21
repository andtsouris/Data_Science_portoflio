rm(list=ls())
library(tidyverse)

dat <- read.csv('./MarathonData.csv') %>% select(-Marathon) %>%
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

MAE <- mean(tested$residuals) # Mean absolute error
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
  geom_smooth(span=0.2)+scale_y_continuous(breaks=seq(0,1,by=0.2))
anova(regr)

ggplot(dat2, aes(x=MarathonTime))+
  geom_density()
ggplot(dat2, aes(x=km4week))+
  geom_density()
ggplot(dat2, aes(x=km4week, y=MarathonTime))+
  geom_point()
