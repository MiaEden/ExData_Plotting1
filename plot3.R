# Exploratory Data Analysis - Week 1 - Peer-Graded Assignment
# Dataset: Electric power consumption [20Mb]
# This assignment uses data from the UC Irvine Machine Learning Repository, a popular repository for machine learning datasets. 
# Description: Measurements of electric power consumption in one household with a one-minute sampling rate 
# over a period of almost 4 years. Different electrical quantities and some sub-metering values are available.

#Variables:
# Date: Date in format dd/mm/yyyy
# Time: time in format hh:mm:ss
# Global_active_power: household global minute-averaged active power (in kilowatt)
# Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# Voltage: minute-averaged voltage (in volt)
# Global_intensity: household global minute-averaged current intensity (in ampere)
# Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
# Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
# Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.


####################################################
#   1- Download data, read file and reformat columns
####################################################

library(lubridate)   # for convert text to date functions easily
library(data.table)  # for fread
library(dplyr)       #  for mutating table

# getwd()

    if(!file.exists("data")){
        dir.create("data")
    }

# setwd("./data")

    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "./data/hpcData.zip", method = "curl")
    unzip("./data/hpcData.zip", exdir = "./data")
    setwd("./data")
    list.files()

# read file
    epcData <- fread("household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?")
#   head(epcData,10); str(epcData)

# convert date/ time text to date/ time format
    epcData$Date <- dmy(epcData$Date); # epcData$Time <- hms(epcData$Time)
#   head(epcData$Time)

# convert character to numeric columns
    epcData[,3:8] <- lapply(epcData[,3:8], as.numeric)

# filter data on dates 2007-02-01 and 2007-02-02 only
    epcDataFiltered <- subset(epcData, Date == "2007-02-01" | Date == "2007-02-02")
    
# paste date and time columns, reformat, and add that new column to table
    dateTime <- as.POSIXct(paste(epcDataFiltered$Date, epcDataFiltered$Time))
    epcDataMutated <- mutate(epcDataFiltered, dateTime)

    
################################################
# Plot 3: plot of Energy Submetering by second  
################################################

# launch png graphic design
    png(filename = "plot3.png",
        width = 480,
        height = 480
    )  
    
# call a plotting function plot for Energy Sub Metering by seconds
    with(epcDataMutated, {
         plot(
            dateTime,
            Sub_metering_1,
            type = "l",
            xlab = "",
            ylab = "Energy sub metering")
            lines(
                dateTime,
                Sub_metering_2,
                col = "red")
            lines(
               dateTime,
               Sub_metering_3,
               col = "blue")
            legend("topright", 
               lty = 1, 
               col = c("black", "red", "blue"), 
               legend = names(epcDataMutated[7:9]))
    })


# close graphic design
    dev.off()    
