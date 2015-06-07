#********** plot3.R: Sub-meterings  ************
#Reading with read.table will get all the rows first, takes too much time
#SQLDF faster @ this time, read and filter at ~ same time

#Required library for running this plot3.R
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
fDateTime<-as.POSIXct(paste(pwrCons$Date, pwrCons$Time))

#Plotting
png(filename = 'plot3.png', width = 480, height = 480)
plot(fDateTime, pwrCons$Sub_metering_1, type="l",col=c('black'),
  ylab = 'Energy sub metering')
lines(fDateTime, pwrCons$Sub_metering_2, type="l",col=c('red'))
lines(fDateTime, pwrCons$Sub_metering_3, type="l",col=c('blue'))
legend('topright', pch=1, col=c('black', 'red', 'blue'),
  legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3') )
dev.off()

closeAllConnections()