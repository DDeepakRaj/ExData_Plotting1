# set url of zip file 
zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# set location to save the zip file
zipFile <- "./data/household_power_consumption.zip"
# set location of data file, after unzip
dataFile <- "./data/household_power_consumption.txt"

# create a directory named "data", if it does not exist
if (!file.exists("data")) {
    dir.create("data")
}

# check if file is already saved
if(!file.exists(dataFile))
{
	# if data file is not there, check if zip file is saved
	if(!file.exists(zipFile))
	{
		# download the zip file as it does not exist in data directory
		setInternet2(use=TRUE)
		download.file(zipUrl,zipFile)
	}
	# exctract the data file in the data directory
	unzip(zipFile, exdir="./data")
	#file.remove(zipFile)
}
# make sure required packages are loaded
require(data.table)
require(sqldf)
# read only the rows having dates 1/2/2007 or 2/2/2007
# and load them in data.table
dt <- data.table(read.csv.sql(dataFile, sql="select * from file where Date in ('1/2/2007','2/2/2007')", sep=";"))

# convert the Date column to proper data type
dt$Date <- as.Date(dt$Date, format="%d/%m/%Y")
# add new column named timestamp
dt[,timestamp:=as.POSIXct(paste(Date, Time))]

# Change the plot area to a 2x2 matrix, filling row-wise
par(mfrow=c(2,2))
        
# plot1
plot(dt$timestamp,dt$Global_active_power, type="l", xlab="", ylab="Global Active Power")

# plot2
plot(dt$timestamp,dt$Voltage, type="l", xlab="datetime", ylab="Voltage")

# plot3
plot(dt$timestamp,dt$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(dt$timestamp,dt$Sub_metering_2,col="red")
lines(dt$timestamp,dt$Sub_metering_3,col="blue")
legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), bty="n", cex=.5) 

#plot4
plot(dt$timestamp,dt$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

# save the 4th graph to plot4.png
dev.copy(png, file="plot4.png", width=480, height=480)
# close the graphics device after copy
dev.off()


