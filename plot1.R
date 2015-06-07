#********** plot1.R: Global Active Power and its frequencies ************
#Reading with read.table will get all the rows first, takes too much time
#SQLDF faster @ this time, read and filter at ~ same time

#Required library for running this plot1.R
pkgReady <- function(pkgName) is.element(pkgName, installed.packages()[,1])
if(!pkgReady('sqldf')){install.packages('sqldf')}
library(sqldf)

#Data file path
dataPath <- 'household_power_consumption.txt'

#Getting column names
cnames <- strsplit(readLines(dataPath, n = 1), split = ';')

#Reading the data for 2 specific days
pwrCons <- read.csv.sql(dataPath, sep=';', header=FALSE, skip=1,
  sql = "select * from file where V1 = '1/2/2007' or V1 = '2/2/2007'")

#Renaming columns and tidying data
names(pwrCons) <- cnames[[1]]
pwrCons[,'Date'] = as.Date(pwrCons[,'Date'], format = '%d/%m/%Y')
timeComp <- strptime(pwrCons$Time, format = '%T')
pwrCons$Time = timeComp

#Plotting
png(filename = 'plot1.png', width = 480, height = 480)
with(pwrCons, hist(Global_active_power, main = 'Global Active Power',
  col = c('red'), xlab = 'Global Active Power(kilowatts)'))
dev.off()

closeAllConnections()