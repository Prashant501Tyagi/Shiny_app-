data()
View(Orange)

head(Orange,10)
tail(Orange,10)
str(Orange)

## mean is the average of the one hole column
mean(Orange$age)

## median is the middle value of column
median(Orange$age)

## iqr is inter quartile distance between the diffrent  diffrent quartile
IQR(Orange$age)

var(Orange$age)

range(Orange$age)

hist(Orange$age)

library(Hmisc)

cor(Orange$age,Orange$circumference)

quantile(Orange$age)

boxplot(Orange$age,main="age of orange",col = "red")

table(Orange$age)

