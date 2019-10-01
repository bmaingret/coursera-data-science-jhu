source("load_data.R")
if (!exists("energy_data")) {
  energy_data <- load_data()
}
Sys.setlocale("LC_TIME", "English")

png(
  file = "plot4.png",
  height = 480 ,
  width = 480 ,
  units = "px",
  type="windows"
)

par(mfrow = c(2, 2))

# First plot
with(
  energy_data,
  plot(
    DateTime,
    Global_active_power,
    col = "black",
    type = "l",
    xlab = "",
    ylab = "Global Active Power"
  )
)

# Second plot
with(energy_data,
     plot(
       DateTime,
       Voltage,
       col = "black",
       type = "l",
       xlab = "datetime"
     ))

# Third plot
## Helper variables
colors = c("black", "red", "blue")
xrange <- range(energy_data$DateTime)
yrange <-
  range(
    energy_data$Sub_metering_1,
    energy_data$Sub_metering_2,
    energy_data$Sub_metering_3
  )

## Empty plot
with(energy_data,
     plot(
       xrange,
       yrange,
       ylab = "Energy sub metering",
       xlab = "",
       type = "n"
     ))
## Adding lines
for (i in 1:3) {
  lines(energy_data$DateTime,
        energy_data[[paste("Sub_metering_", i, sep = "")]],
        col = colors[[i]],
        type = "l")
}
## and legend
legend(
  "topright",
  paste("Sub_metering_", seq(1, 3), sep = ""),
  col = colors,
  lty = 1,
  bty = "n"
)

# Fourth plot
with(
  energy_data,
  plot(
    DateTime,
    Global_reactive_power,
    col = "black",
    type = "l",
    xlab = "datetime",
    ylab = "Global_reactive_power"
  )
)

dev.off()
