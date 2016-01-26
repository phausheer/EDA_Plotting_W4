### *********************************************************************************
### Paul R. Hausheer
### Jan 2016
### Local Location -  C:\Users\p622403\gitEDA\EDA_PlottingW1
### Save location - \\wtors003\isg-secure\ISG Big Data\R\Source
### File Name - EDA_Project2_Plot5.R 
### *********************************************************************************
runProject2_Plot5 <- function() {
  # require("dplyr")
  ### Library other required packages
  cvLibraries <- c("lattice","RColorBrewer","sqldf","proto","RSQLite", "DBI", "tcltk", "gsubfn")
  lapply(cvLibraries, require, character.only=TRUE) 
  
  ### This May take a while to load
  dfNEI <- readRDS("./data/summarySCC_PM25.rds")
  #   print("*** debug dfNEI ***")
  #   print(paste("NUmber of Rows :", nrow(dfNEI)))
  #   print(paste("NUmber of Cols :", ncol(dfNEI)))
  ### colnames : "fips"      "SCC"       "Pollutant" "Emissions" "type"      "year" 
  
  
  ##############################################################################################################
  print("Group emissions by year filter for Baltimore On-Road")
  ### Inner Join is about 10x slower than using the IN clause
  ##############################################################################################################
  # dfGroupByYear <- sqldf("select year, sum(Emissions) as Emissions  from dfNEI where fips = '24510' group by year")
  # dfSCCCoal <- sqldf("select scc, short_name  from dfSCC where short_name LIKE  'Coal%' ")
  dfOnRoadBaltimore  <- sqldf("select year, sum(Emissions) as Emissions from dfNEI where lower(type) = 'on-road' and fips = '24510' group by year")
  #   print(paste("     number of rows dfOnRoadBaltimore:", nrow(dfOnRoadBaltimore)))
  #   print(paste("     number of colss dfOnRoadBaltimore:", ncol(dfOnRoadBaltimore)))
  #   print(colnames(dfOnRoadBaltimore))
  print(dfOnRoadBaltimore)
  
  ### Bar Plot 
  strYLabel <- expression('total PM'[2.5]*' Emissions')
  strXLabel <- c("year")
  strTitle <- expression('Baltimore City On-Road Emissions, 1999 - 2008')
  png('Plot5.png')
  myColours <- brewer.pal(2,"Blues")
  trellisBarChart <- barchart(Emissions ~ year
                              ,data = dfOnRoadBaltimore
                              ,xlab=strXLabel
                              ,ylab=strYLabel
                              ,horizontal=FALSE
                              ,main=strTitle)
  print(trellisBarChart)
  #   barplot(height=dfOnRoadBaltimore$Emissions, names.arg=dfOnRoadBaltimore$year
  #           ,main=strTitle)
  dev.off()
}