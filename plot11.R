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


# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
TotEmmByYear <- aggregate(Emissions~year, NEI, sum)

png("plot1.png", width=480, height=480)
plot(TotEmmByYear$year, TotEmmByYear$Emissions, type="l", xlab="YEAR", ylab="Total PM2.5 Emissions (Tons)", main="PM 2.5 Emissions (Tons) Per Year")
dev.off()