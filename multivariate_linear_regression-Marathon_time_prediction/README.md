Multivariate linear regression to predict the marathon time of athletes
======
### Abstract
Starting a marathon with a wrong pace is detrimental to the athletes performance. If the athlete starts too slow she can loose too much time that is impossible to regain in the latter part of the race. Starting too fast on the other hand can cause a burnout and the athlete might not manage to even finish the race. It is therefore essential for every marathon runner at the start line to have a realistic time goal in order to start and maintain the correct pace thoughout the race. In this simple analysis I used publicly available data (https://www.kaggle.com/girardi69/marathon-time-predictions) to predict the marathon times of athletes based on their training data for the 4 weeks prior to the race. I am able to predict their marathon time a standard error of estimate (SEE) of 6 mins and 49 sec which is comparable to the best predictor to my knowledge (Tanda, 2011) with an SEE of about 4 minutes.

### The data
The data available at https://www.kaggle.com/girardi69/marathon-time-predictions contain of 87 athletes. The dataset describes the marathon time and various training data (average speed, weekly distance, cycling training time) and other data such as age group and runner age based category of the athletes. In this analysis The age based data were not included because they are categorical data with many categories that according to my estimation wouldn't help the prediction.

### Analysis and prediction
To assess if I would be able to use this data to predict marathon times I checked for any correlation between the different variables and the actual marathon time of each athlete. 
![alala](http://github.com/andtsouris/Data_Science_portfolio/multivariate_linear_regression-Marathon_time_predictor/assets/marathonTime_distance_corPlot.jpg "title")
