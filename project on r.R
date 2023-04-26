
new_file <- read.csv("E:/value add course/new_data.csv")

View(new_file)
dim(new_file)

## read codes data for country codes 
new_file <- new_file[!duplicated(new_file$country), ]

View(new_file)

codes<- read.delim("E:/value add course/codes.txt",header = TRUE)
codes <- data.frame(codes)
head(codes)
colnames(codes)
dim(codes)

## select only country abbrev and codes

codes <- codes[,c("CC","X.")]

## remove null , na , blank values


