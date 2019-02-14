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


# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

## Get the vehicle related sources from SCC
MotorSCC <- SCC$SCC[grep("Onroad", SCC$Data.Category, ignore.case=TRUE)]

## get data for Motor vehicle sources
NEIMotor <- NEI[NEI$SCC %in% MotorSCC, ]
NEIMotorBaltimore <- NEIMotor[NEIMotor$fips == "24510", ]
TotEmmByYearMotorBal <- aggregate(Emissions~year, NEIMotorBaltimore, sum)

png("plot5.png")
plot(TotEmmByYearMotorBal$year, TotEmmByYearMotorBal$Emissions, type="l", xlab="YEAR", ylab="Total PM2.5 Motor Vehicle Emissions (Tons)", main="PM 2.5 Motor Vehicle Emissions (Tons) in Baltimore City Per Year")
dev.off()