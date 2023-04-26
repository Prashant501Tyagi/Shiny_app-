library(shiny)
library(shinydashboard)
library(dplyr)

setwd("E:/value add course/")

fact_population <- read.csv("E:/value add course/fact_population - fact_population.csv")
dim_region <- read.csv("E:/value add course/dim_region - dim_region.csv")
dim_age <- read.csv("E:/value add course/dim_age - dim_age.csv")
dim_gender <- read.csv("E:/value add course/dim_gender.csv")
View(fact_population)
View(dim_region)
View(dim_age)
View(dim_gender)


popRegion <- merge(fact_population,dim_region,
                   by = "country.id", all.x = TRUE)
View(popRegion)
str(popRegion)
popRegion$population <- as.numeric(popRegion$population)

## USER INTERFACE

ui <- dashboardPage(
  dashboardHeader(title = "population Dashboard",titleWidth = 300),
  dashboardSidebar(width = 300,
                   sidebarMenu(
                     menuItem("Region",
                              tabName = "Region",
                              icon = icon("dashboard")),
                     menuItem("Age",
                              tabName = "agepage",
                              icon = icon("th"))
                   )), 
  dashboardBody(tabItem(
    tabName = "regionpage",
    fluidRow(
      valueBoxOutput("reg1", width = 6),
      valueBoxOutput("reg2", width = 6)
    ),
    fluidRow(
      box(
        title = "countrywise Population",
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        plotOutput("bargraph")
      ),
      box(
        title = "Region & Yearwise Population",
        status = "warning",
        solidHeader = TRUE,
        collapsible = TRUE,
        plotOutput("linegraph")
      )
    )
  ,tabName = "age page",
  fluidRow(
    valueBoxOutput("reg3", width = 6),
    valueBoxOutput("reg4", width = 6)
  ),
  fluidRow(
    box(
      title = "Countrywise Population",
      status = "primary",
      solidHeader = TRUE,
      collapsible = TRUE,
      plotOutput("TreeMap")
    ),
    box(
      title = "Region & Age Category Wise Population",
      status = "warning",
      solidHeader = TRUE,
      collapsible = TRUE,
      plotOutput("TABLE")
    )
  )
  ))
)
server <- function(input,output){
  dfr <- popRegion %>% 
    group_by(region) %>%
    summarise(TotalPopulation =
                sum(population, na.rm=TRUE))
  dfr <- data.frame(dfr)
  #dfr <- subset(dfr, is.na(dfr$region != NA)
  dfr <- subset(dfr, !is.na(dfr$region))
  
  maxp <- dfr[which.max(dfr$TotalPopulation),]
  
  maxp$TotalPopulation <- format(round(as.numeric(maxp$TotalPopulation),1),nsmall = 0, big.mark = ",")
  ##max$TotalPopulation
  
  output$reg1 <-renderValueBox({
    valueBox(
      maxp$TotalPopulation,
      paste0("Region with the highest
             population :",maxp$region),
      color = "light-blue"
    )
    
    
  })
  
  output$bargraph <- renderPlot({
    barplot(dfr$TotalPopulation, names.arg = dfr$region,
            xlab = "Region",ylab = "TotalPopulation",
            border = "black")
    
  })
  
  dfyr <- popRegion %>%
    group_by(year, region) %>%
    summarise(TotalPopulation = sum(population, na.rm = TRUE))
  dfyr <-data.frame(dfyr)
  dfyr <-subset(dfyr, !is.na(dfyr$region))
  
  maxpr <- dfyr[which.max(dfyr$TotalPopulation),]
  
  output$reg2 <-renderValueBox({
    valueBox(
      maxpr$TotalPopulation,
      paste0("year & Region with the highest
             population :",maxpr$year, " - ", maxpr$region),
      color = "green")
  })
  
  output$linegraph <-renderPlot({
    ggplot(
      dfyr,aes(x=year,y=TotalPopulation,fill=region)) + geom_line() + geom_point(size=4,shape=21)
  })
  
  dslr <- popRegion %>%
    group_by(year, region) %>%
    summarise(TotalPopulation = sum(population, na.rm = TRUE))
  dslr <-data.frame()
  dslr <-subset(dslr, !is.na(dslr$region))
  
  maxdslr <- dslr[which.max(dslr$TotalPopulation),]
  
  output$reg1 <-renderTreeMap(div_id,
                             data,
                             name = "treemap ",
                             leafDepth = 2,
                             theme = "default",
                             show.tools = TRUE,
                             running_in_shiny = TRUE)

  })
  
  output$TreeMap <-render({
    TreeMap(
      dslr,name="treemap",leafdepth=2,theme='default',show.tools = True)
  })
  
  
}

shinyApp(ui,server)

