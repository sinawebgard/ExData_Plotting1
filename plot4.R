## loading required packages

if(suppressWarnings(!require(data.table))){
        install.packages("devtools")
        install.packages("data.table")
        library.packages(data.table)
}

# downloading and expanding the data file if not already exists

filename <- "household_power_consumption.txt"
fileurl <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists(filename)){
        temp <- tempfile()
        download.file(fileurl, temp)
        unzip(temp)
        remove(temp)
}

# subset and load the data set

index <- fread(filename, sep = ";", header = TRUE, select = 1)
dat <-  fread(filename, sep = ";", header = TRUE, 
              na.strings = "?")[index$Date %in% c("1/2/2007", "2/2/2007"), ]

# Convert Date and Time variables to Date/Time class

dat$Date <- as.Date(dat$Date, format = "%d/%m/%Y")
DateTime <- paste(dat$Date, dat$Time, sep = " ")
dat$Time <- as.POSIXct(DateTime)

# plot and create the png file

png(filename = "plot4.png", width = 480, height = 480)
par(mfrow= c(2,2), mar= c(4,4,1,1), bg = "transparent")

# plot1
plot(dat$Time, dat$Global_active_power, type = "l", 
     xlab="", ylab = "Global Active Powe", cex= 0.2)

# plot2
plot(dat$Time, dat$Voltage, type = "l", 
     xlab="", ylab= "", cex= 0.2)
title(ylab = "Voltage", line = 2)
title(xlab = "datetime", line = 2)
# plot3
with(dat, plot(Time, Sub_metering_1, xlab = "", 
               ylab = "Energy sub metering", type = "l", cex= 0.2))
with(dat, lines(Time, Sub_metering_2, type = "l", col ="red"))
with(dat, lines(Time, Sub_metering_3, type = "l", col ="blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, col = c("black", "red", "blue"), bty = "n")

#plot4
plot(dat$Time, dat$Global_reactive_power, type = "l", xlab = "datetime", ylab = "", cex= 0.2)
title(ylab = "Global_reactive_power", line = 2)
# closing the graphical device and saving the file

dev.off()