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

png(file="plot4.png", width=480,height=480)
par(mfcol=c(2,2))
plot(x=pc$Time, y=pc$Global_active_power,xlab="", ylab="Global Active Power", type="l")

plot(x=c(pc$Time,pc$Time,pc$Time), y=c(pc$Sub_metering_1,pc$Sub_metering_2,pc$Sub_metering_3),xlab="", ylab="Energy sub metering", type="n")
lines(x=pc$Time, y=pc$Sub_metering_1)
lines(x=pc$Time, y=pc$Sub_metering_2,col="red")
lines(x=pc$Time, y=pc$Sub_metering_3,col="blue")
legend("topright", col=c("black","red","blue"), bty="n", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty="solid")

plot(x=pc$Time, y=pc$Voltage,xlab="datetime", ylab="Voltage", type="l")
plot(x=pc$Time, y=pc$Global_reactive_power,xlab="datetime", ylab="Global_reactive_power", type="l")

dev.off()