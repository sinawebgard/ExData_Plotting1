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

png(filename = "plot2.png", width = 480, height = 480)
par(bg = "transparent")
plot(dat$Time, dat$Global_active_power, type = "l", 
     xlab="", ylab = "Global Active Power (kilowatts)")
dev.off()