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


# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.
NEIBaltimore <- NEI[NEI$fips == "24510", ]
TotEmmByYearBal <- aggregate(Emissions~year, NEIBaltimore, sum)

png("plot2.png", width=480, height=480)
plot(TotEmmByYearBal$year, TotEmmByYearBal$Emissions, type="l", xlab="YEAR", ylab="Total PM2.5 Emissions (Tons)", main="PM 2.5 Emissions (Tons) in Baltimore City, Maryland Per Year")
dev.off()