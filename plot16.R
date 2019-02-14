# Download and unzip the file
#############################
my_path <- getwd()
remote_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
downloaded_zip_file = "nei.zip"
download.file(remote_url, file.path(my_path, downloaded_zip_file))
unzip(zipfile = downloaded_zip_file)


# Read the data
###############
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
# sources in Los Angeles County, California (fips=="06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

## Get the vehicle related sources from SCC
MotorSCC <- SCC$SCC[grep("Onroad", SCC$Data.Category, ignore.case=TRUE)]

## get data for Motor vehicle sources
NEIMotor <- NEI[NEI$SCC %in% MotorSCC, ]
NEIMotorBalCal <- NEIMotor[NEIMotor$fips == "24510" |NEIMotor$fips == "06037" , ]
TotEmmByYearMotorBalCal <- aggregate(Emissions~year+ fips, NEIMotorBalCal, sum)

## Add new column for location
TotEmmByYearMotorBalCal$location = ifelse(TotEmmByYearMotorBalCal$fips=="24510", "Baltimore City", "Los Angeles County")

png("plot6.png", width=480, height=480)
g <- ggplot(TotEmmByYearMotorBalCal, aes(year, Emissions))
g + facet_grid(. ~ location) + geom_line() + xlab('Year') + ylab(expression('Total PM2.5 Emissions (Tons)')) + ggtitle('Total PM2.5 Emmision in Baltimore City by Sources')
dev.off()
