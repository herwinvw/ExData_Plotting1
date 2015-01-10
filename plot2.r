getPowerConsumptionData <- function()
{  
  if (!file.exists("household_power_consumption_selected.csv"))
  {
    if (!file.exists("household_power_consumption.txt"))
    {
      message("Downloading data")
      download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile="household_power_consumption.zip")
      unzip("household_power_consumption.zip")
    }
    pc <- read.csv("household_power_consumption.txt",sep=";",dec=".",na.strings="?")
    pc <- transform(pc, Date=as.Date(Date, format="%d/%m/%Y"))
    pc <- subset(pc, Date>=as.Date("1/2/2007",format="%d/%m/%Y")&Date<=as.Date("2/2/2007",format="%d/%m/%Y"))
    write.csv(pc, file="household_power_consumption_selected.csv")
    return(pc)
  }
  else
  {
    return (read.csv("household_power_consumption_selected.csv"))
  }
}
pc<-getPowerConsumptionData()
pc<-transform(pc, Time=paste0(Date," ",Time))
pc<-transform(pc, Time=strptime(Time, format="%Y-%m-%d %H:%M:%S"))
png(file="plot2.png", width=480,height=480)
plot(x=pc$Time, y=pc$Global_active_power,xlab="", ylab="Global Active Power (kilowatts)", type="l")
dev.off()