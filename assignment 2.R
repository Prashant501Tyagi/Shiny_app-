
sales = read.csv("E:/value add course/customer_seg.csv")

View(sales)

sales$Country <- "United States"
View(sales)

#To delete the space between the customer id 
sales$Customer_ID <- gsub(" ","",sales$Customer_ID)
View(sales)

str(sales)
library(tidyr)

library(stringr)

sales$Customer_ID <- gsub('[A-Za-z]',"",sales$Customer_ID)



random <-sales[is.na(sales$Invoice_No),]
random
random <- str_split_fixed(sales$Stock_Code," ",2)
random[,1]

sales$Stock_Code[is.na(sales$Invoice_No)]<-li[,2]
sales$Invoice_No[is.na(sales$Invoice_No)]<-li[,1]
random
View(sales)

write.csv("sales","E:/value add course/clean.csv")
