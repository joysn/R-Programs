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


# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

## Get the coal combustion-related sources from SCC
CoalSCC <- SCC$SCC[grep("coal", SCC$EI.Sector, ignore.case=TRUE)]

## get data for coal sources
NEICoal <- NEI[NEI$SCC %in% CoalSCC, ]
TotEmmByYearCoal <- aggregate(Emissions~year, NEICoal, sum)

png("plot4.png", width=480, height=480)
plot(TotEmmByYearCoal$year, TotEmmByYearCoal$Emissions, type="l", xlab="YEAR", ylab="Total PM2.5 Emissions (Tons)", main="PM 2.5 Emissions (Tons) From Coal Sources Per Year")
dev.off()