
#-------------------    Create dimension dim-region  -----------------------------------

# Read data
dim_region <- read.csv("/Users/javedinamdar/Documents/R-Training/population_2010_2040.csv")

View(dim_region)

# Keep only country columns to create region data
dim_region <- dim_region[,c('country.id','country')]

dim(dim_region)

# Remove duplicate records
dim_region <- dim_region[!duplicated(dim_region$country), ]

View(dim_region)

dim(dim_region)

# Read codes data for country codes
codes <- read.delim("/Users/javedinamdar/Documents/R-Training/codes.txt", sep = "\t", header = TRUE)
codes <- data.frame(codes)

head(codes)

# select only country abbrev and codes
codes <- codes[,c('CC','X.')]

# Remove null, NA, blank values 
codes <- filter(codes, codes$X. != 'NA')
codes <- filter(codes, codes$X. != 'null')
codes <- filter(codes, codes$X. != '')

#Replacing codes with descriptive names
codes$CC <- str_replace(codes$CC, "AS", "Asia")
codes$CC <- str_replace(codes$CC, "EU", "Europe")
codes$CC <- str_replace(codes$CC, "AN", "Antartica")
codes$CC <- str_replace(codes$CC, "AF", "Africa")
codes$CC <- str_replace(codes$CC, "OC", "Oceania")
codes$CC <- str_replace(codes$CC, "SA", "South America")
codes$CC <- str_replace(codes$CC, "N A", "North America")

#rename the columns
colnames(codes) <- c('region', 'country.id')

View(codes)

str(codes)

# Convert column datatype for merging
codes$country.id <- as.integer(codes$country.id)
codes$region <- as.factor(codes$region)


# Merging two datasets
dim_region <- merge(dim_region,codes, on = 'country.id')

head(dim_region)

write.csv(dim_region, '/Users/javedinamdar/Documents/R-Training/dim_region.csv')

#------------------------------- Create dim_age file for data modeling ------------------

# Read data
dim_age <- read.csv("/Users/javedinamdar/Documents/R-Training/population_2010_2040.csv")


# Keep only age group column to create age data
dim_age <- as.data.frame(dim_age[,c('age.group')])

View(dim_age)

names(dim_age)

# rename column 
colnames(dim_age) <- 'age.group'

# remove duplicates

nrow(dim_age)

dim_age <- as.data.frame(dim_age[!duplicated(dim_age$age.group), ])

nrow(dim_age)

View(dim_age)

colnames(dim_age) <- 'age.group'

# Replace values in age.group using regex
dim_age$age.group <- str_replace(dim_age$age.group, '100\\+', "-100")

# Create age min, max columns using Regex
dim_age$age.min <- as.integer(sub("\\-.*", "", dim_age$age.group))
dim_age$age.max <- as.integer(sub(".*-", "", dim_age$age.group))

View(dim_age)

# Create category column 
dim_age$category <- ifelse(dim_age$age.max <= 4, 'Baby', 
                    ifelse(dim_age$age.max <= 14, 'Child', 
                    ifelse(dim_age$age.max <= 24, 'Teenager', 
                    ifelse(dim_age$age.max <= 34, 'Young Adult', 
                    ifelse(dim_age$age.max <= 64, 'Adult', 'Senior')))))

View(dim_age)

# Create ID column
dim_age <- dim_age %>% mutate(age.grp.id = row_number()) 

View(dim_age)

write.csv(dim_age, '/Users/javedinamdar/Documents/R-Training/dim_age.csv')


#---------------------------------- Create dim_gender data ------------------------------------

# Read data
dim_gender <- read.csv("/Users/javedinamdar/Documents/R-Training/population_2010_2040.csv")


# Keep only gender column
dim_gender <- as.data.frame(dim_gender[,c('gender')])

View(dim_gender)

colnames(dim_gender)

# Rename column
dim_gender <- dim_gender %>% rename("gender" = "dim_gender[, c(\"gender\")]")

# Drop duplicates
dim_gender <- dim_gender[!duplicated(dim_gender$gender), ]

dim_gender <- as.data.frame(dim_gender)


# Create ID column
dim_gender <- dim_gender %>% mutate(gender.id = row_number()) 

write.csv(dim_gender, '/Users/javedinamdar/Documents/R-Training/dim_gender.csv')

#----------------------------Create fact_population data--------------------------------

# Read data
fact_population <- read.csv("/Users/javedinamdar/Documents/R-Training/population_2010_2040.csv")


# Merge datasets fact_population and dim_age
fact_population <- merge(fact_population, dim_age, on = 'age.group')

head(fact_population)

# Merge datasets fact_population and dim_gender
fact_population <- merge(fact_population, dim_gender, on ='gender')


# Select specific columns for fact population data
fact_population <- fact_population[,c('country.id','gender.id','age.grp.id','population','year')]

write.csv(fact_population, '/Users/javedinamdar/Documents/R-Training/fact_population.csv')

