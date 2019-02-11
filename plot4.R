# Download and unzip the file
#############################
my_path <- getwd()
remote_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
downloaded_zip_file = "household_power_consumption.zip"
download.file(remote_url, file.path(my_path, downloaded_zip_file))
unzip(zipfile = downloaded_zip_file)

# Read the file into data frame and filter out what is not needed
#################################################################
powerConsumption <- read.csv(file.path(my_path, "household_power_consumption.txt"), sep = ";",header=TRUE, na.strings="?")
TargetpowerConsumption <- powerConsumption[powerConsumption$Date %in% c("1/2/2007","2/2/2007"),]

#nrow(TargetpowerConsumption)

# Convert the dat/time
######################
TargetpowerConsumption$dateTime = as.POSIXct(paste(TargetpowerConsumption$Date, TargetpowerConsumption$Time), format = "%d/%m/%Y %H:%M:%S")




# Plot
png("plot4.png", width=480, height=480)
par(mfrow = c(2,2))

# Plot 1
plot(x=TargetpowerConsumption$dateTime ,y=TargetpowerConsumption$Global_active_power, type="l", xlab="", ylab="Global Active Power")

# Plot 2
plot(x=TargetpowerConsumption$dateTime ,y=TargetpowerConsumption$Voltage, type="l", xlab="datetime", ylab="Voltage")

# Plot 3
plot(x=TargetpowerConsumption$dateTime ,y=TargetpowerConsumption$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(x=TargetpowerConsumption$dateTime ,y=TargetpowerConsumption$Sub_metering_2, type="l", xlab="", ylab="Energy sub metering",col="red")
lines(x=TargetpowerConsumption$dateTime ,y=TargetpowerConsumption$Sub_metering_3, type="l", xlab="", ylab="Energy sub metering",col="blue")
legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "), lty=c(1,1), bty="n") 

# Plot 4
plot(x=TargetpowerConsumption$dateTime ,y=TargetpowerConsumption$Global_reactive_power, type="l", xlab="datetime",ylab="Global_reactive_power")

dev.off()
