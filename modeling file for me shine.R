library(readxl)
library(dplyr)

first_dataset <- read.csv("E:/value add course/population.csv",skip = 1)

class(first_dataset)

head(first_dataset,10)

str(first_dataset)

colSums(is.na(first_dataset))
nrow(first_dataset)
## to remove the null values in dataset throuh colsum which we find out
first_dataset = filter(first_dataset, !is.na(first_dataset$Time))

nrow(first_dataset)


df <-subset(first_dataset,first_dataset$`3.0`=="NO DATA")
nrow(df)
## doing for second dataset

second_dataset <- read.csv("E:/value add course/population-2020-2029 - population-2020-2029.csv")
class(second_dataset)
#loc int , time int , agegrp start int , agegrp span int 
second_dataset$LocID <- as.integer(second_dataset$LocID)
second_dataset$Time <- as.integer(second_dataset$Time)
second_dataset$AgeGrpSpan <- as.integer(second_dataset$AgeGrpSpan)

head(second_dataset,10)
class(second_dataset)
head(second_dataset)
str(second_dataset)

colSums(is.na(first_dataset))

third_dataset <- read_excel("E:/value add course/population-2030-2040.xlsx")
class(third_dataset)
head(third_dataset,10)

str(third_dataset)
head(third_dataset)
third_dataset$LocID <- as.numeric(third_dataset$LocID)
third_dataset$AgeGrpSpan <- as.numeric(third_dataset$AgeGrpSpan)

str(third_dataset)
third_dataset$AgeGrpSpan<- as.numeric(third_dataset$AgeGrpSpan)

str(third_dataset)
colSums(is.na(first_dataset))

## merge three dataset

sumofalldata <- nrow(first_dataset) + nrow(second_dataset) + nrow(third_dataset)
sumofalldata

population_2010_2040 <- rbind(first_dataset, second_dataset, third_dataset)

colnames(population_2010_2040)

population_2010_2040<- population_2030_2040[,-c(5,6,9)]
colnames(population_2010_2040)
str(population_2010_2040)

population_2010_2040 <- population_2010_2040 %>%
  rename("Country_id"= "LocID",'Country'= "Location","Year"= "Time","Age-Group"="AgeGrp")
View(population_2010_2040)
## replace values

library(stringr)

#population_2010_2040 <-str_replace(population_2010_2040$`Age-Group` , str_replace(population_2010_2040))
#unique(population_2010_2040$AgeGrp)

library(reshape2)

total_merge = melt(population_2010_2040, id.vars = c("Country_id","Country", "Year"
                                            ,"Age-Group"), measure.vars = c("PopMale","PopFemale"))
colnames(population_2010_2040)

population_2010_2040$<- str_replace(merge_data$gender, "PopFemale",Female)

head(merge_data)

write.csv(data_from_10_to_40 , path where we want to save the file)
