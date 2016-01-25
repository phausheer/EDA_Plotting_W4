### *********************************************************************************
### Paul R. Hausheer
### Jan 2016
### Local Location -  C:\Users\p622403\gitEDA\EDA_PlottingW1
### Save location - \\wtors003\isg-secure\ISG Big Data\R\Source
### File Name - EDA_Project2_Plot2.R 
### *********************************************************************************
runProject2_Plot2 <- function() {
  require("dplyr")
  require("sqldf")
  require("tcltk")
  
  setwd("C:/Users/p622403/Documents/Work/Coursera/ExploratoryDataAnalysis/Project2/Reference")
  ### This May take a while to load
  if(!exists("dfNEI")){
    dfNEI <- readRDS("./data/summarySCC_PM25.rds")
  }
  #   print("*** debug dfNEI ***")
  #   print(paste("NUmber of Rows :", nrow(dfNEI)))
  #   print(paste("NUmber of Cols :", ncol(dfNEI)))
  ### colnames : "fips"      "SCC"       "Pollutant" "Emissions" "type"      "year" 
  
  
  #   if(!exists("dfSCC")){
  #     dfSCC <- readRDS("./data/Source_Classification_Code.rds")
  #   }
  #   print("*** dfSCC ***")
  #   print(paste("NUmber of Rows :", nrow(dfSCC)))
  #   print(paste("NUmber of Cols :", ncol(dfSCC)))
  #   print(colnames(dfSCC))
  
  ##############################################################################################################
  # Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
  # Using the base plotting system, make a plot showing the total PM2.5 emission from all sources 
  # for each of the years 1999, 2002, 2005, and 2008.
  print("Group emissions by year")
  ##############################################################################################################
  dfGroupByYear <- sqldf("select year, sum(Emissions) as Emissions  from dfNEI where fips = '24510' group by year")
  print(paste("     number of rows dfGroupByYear:", nrow(dfGroupByYear)))
  print(paste("     number of colss dfGroupByYear:", ncol(dfGroupByYear)))
  print(colnames(dfGroupByYear))
  print(dfGroupByYear)
  
  strYLabel <- expression('total PM'[2.5]*' emission')
  strXLabel <- c("years")
  strTitle <- expression('Total PM'[2.5]*' emissions in Baltimore City at various years')
  png('plot2.png')
  barplot(height=dfGroupByYear$Emissions, names.arg=dfGroupByYear$year
          , xlab=strXLabel
          , ylab=strYLabel
          ,main=strTitle)
  dev.off()
}