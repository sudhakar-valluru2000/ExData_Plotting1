# Q1 for getting and cleaning data.

#library (plyr)
library (dplyr)
#library(RMySQL)
library(sqldf)
library(tcltk)
library(httr)
#library(httpuv)
library(XML)
library(jsonlite)
#library(Hmisc)



url1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

file1 <- "./household_power_consumption.txt"

#url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
#file2 <- "./getdata%2Fdata%2FEDSTATS_Country.csv"


#file1 <- download.file(url, destfile, mode="wb")

#dlfile1 <- read.csv (url)
setwd ("./")

print(getwd())



list.files("./household_power_consumption.txt")

#If file does not exisit, download file.
if (!file.exists(file1)) {download.file(url1, file1, mode="wb")}

#if (!file.exists(file2)) {download.file(url2, file2, mode="wb")}

#Read file, but read only dates of 2007-02-01 and 2007-02-02
#You could read the whole file and subset for the above dates, but the file is huge and 
#sometimes if you have less memory in your laptop, it might not load everything
#So try to read for only those dates and then, process

r1 <- read.csv.sql(file1, sql = "select * from file where Date in ('1/2/2007', '2/2/2007')", header = TRUE, sep = ";", stringsAsFactors = FALSE)

closeAllConnections()

# Create a new field by concatenating date and time
r1 <- within (r1, timestamp <- paste(Date,Time, sep =' '))

r1$timestamp <- as.POSIXct(strptime(r1$timestamp, "%d/%m/%Y %H:%M:%S"))

png("./plot3.png", width = 480,height = 480, units = "px")
#png("./plot3.png", width = 480,height = 480, units = "px" )

plot(r1$timestamp, r1$Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering", col = "black") 

lines(x = r1$timestamp, y = r1$Sub_metering_2, col = "red")

lines(x = r1$timestamp, y = r1$Sub_metering_3,  col = "blue")

#legend(x = r1$timestamp, y = r1$Sub_metering_1, legend = "Sub_metering_1",  col = black)

#legend("topright", "-----  Sub_meeting_1", col = "black", pch = 1,  inset = .02)
#legend("topright", col = c("black", "red"), legend = c("-----  Sub_meeting_1", "-----  Sub_meeting_2"),  lwd, pch = 1)

legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), pch = "-", lwd = 3)

       
graphics.off()



#r1$Time <- as.POSIXct(strptime(r1$Time, "%H:%M:%S"))
#as.POSIXct(strptime(x$dateTime, "%d/%m/%Y
#r1$Date <- as.Date (r1$Date, "%Y-%b-%d")

#png("./plot2.png", width = 480,height = 480, units = "px", type = c("windows", "cairo", "cairo-png") )
#title(main="Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
#hist(r1$Global_active_power, main="Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "red", freq = TRUE)
#graphics.off()

#png("./plot1.png", width = 480,height = 480)



#Convert date and time to data class