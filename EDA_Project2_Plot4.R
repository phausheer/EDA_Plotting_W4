### *********************************************************************************
### Paul R. Hausheer
### Jan 2016
### Local Location -  C:\Users\p622403\gitEDA\EDA_PlottingW1
### Save location - \\wtors003\isg-secure\ISG Big Data\R\Source
### File Name - EDA_Project2_Plot4.R 
### *********************************************************************************
runProject2_Plot4 <- function() {
  # require("dplyr")
  ### Library other required packages
  cvLibraries <- c("sqldf","proto","RSQLite", "DBI", "tcltk", "gsubfn")
  lapply(cvLibraries, require, character.only=TRUE) 
  
  ### This May take a while to load
  dfNEI <- readRDS("./data/summarySCC_PM25.rds")
  #   print("*** debug dfNEI ***")
  #   print(paste("NUmber of Rows :", nrow(dfNEI)))
  #   print(paste("NUmber of Cols :", ncol(dfNEI)))
  ### colnames : "fips"      "SCC"       "Pollutant" "Emissions" "type"      "year" 
  
  dfSCC <- readRDS("./data/Source_Classification_Code.rds")
  #   print("*** dfSCC ***")
  #   print(paste("Number of Rows :", nrow(dfSCC)))
  #   print(paste("Number of Cols :", ncol(dfSCC)))
  vcColNames <- c("SCC","data_category","short_name","EI_Sector","Option_Group","Option_Set","SCC_Level_One","SCC_Level_Two" ,"SCC_Level_Three","SCC_Level_Four","Map_To","Last_Inventory_Year","Created_Date", "Revised_Date", "Usage_Notes" )
  colnames(dfSCC) <- vcColNames
  print(colnames(dfSCC))
  # print(head(dfSCC))
  
  ##############################################################################################################
  print("Group emissions by year filter for Coal")
  ### Inner Join is about 10x slower than using the IN clause
  ##############################################################################################################
  # dfGroupByYear <- sqldf("select year, sum(Emissions) as Emissions  from dfNEI where fips = '24510' group by year")
  # dfSCCCoal <- sqldf("select scc, short_name  from dfSCC where short_name LIKE  'Coal%' ")
  dfEmissionsCoal <- sqldf("select year, sum(Emissions) as Emissions from dfNEI where SCC in  (select distinct SCC from dfSCC  where lower(dfSCC.short_name) LIKE '%coal%')  group by year")
  #   print(paste("     number of rows dfEmissionsCoal:", nrow(dfEmissionsCoal)))
  #   print(paste("     number of colss dfEmissionsCoal:", ncol(dfEmissionsCoal)))
  #   print(colnames(dfEmissionsCoal))
  print(dfEmissionsCoal)
  
  ### Bar Plot 
  strYLabel <- expression('total PM'[2.5]*' Emissions')
  strXLabel <- c("year")
  strTitle <- expression('Total Coal Emissions, 1999 - 2008')
  png('Plot4.png')
  barplot(height=dfEmissionsCoal$Emissions, names.arg=dfEmissionsCoal$year
          , xlab=strXLabel
          , ylab=strYLabel
          ,main=strTitle)
  dev.off()
}