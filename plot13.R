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


# Of the four types of sources indicated by the "type" (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City ? 
# Which have seen increases in emissions from 1999-2008? 
# Use the  ggplot2 plotting system to make a plot answer this question.
NEIBaltimore <- NEI[NEI$fips == "24510", ]
TotEmmByYearBal <- aggregate(Emissions~year+ type, NEIBaltimore, sum)

library(ggplot2)

png("plot3.png", width=480, height=480)
g <- ggplot(TotEmmByYearBal, aes(year, Emissions))
g + facet_grid(. ~ type) + geom_line() + xlab('Year') + ylab(expression('Total PM2.5 Emissions (Tons)')) + ggtitle('Total PM2.5 Emmision in Baltimore City by Sources')
dev.off()