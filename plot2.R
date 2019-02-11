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
png("plot2.png", width=480, height=480)
plot(x=TargetpowerConsumption$dateTime ,y=TargetpowerConsumption$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()
