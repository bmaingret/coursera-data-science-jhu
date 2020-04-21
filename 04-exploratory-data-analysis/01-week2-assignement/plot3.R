source("load_data.R")
if (!exists("energy_data")) {
  energy_data <- load_data()
}

png(
  file = "plot3.png",
  height = 480 ,
  width = 480 ,
  units = "px",
  type="windows"
)

colors = c("black", "red", "blue")

xrange <- range(energy_data$DateTime)
yrange <- range(energy_data$Sub_metering_1, energy_data$Sub_metering_2, energy_data$Sub_metering_3)

Sys.setlocale("LC_TIME", "English")

with(energy_data,
     plot(
       xrange,
       yrange,
       ylab = "Energy sub metering",
       xlab = "",
       type = "n"
     ))

legend("topright",paste("Sub_metering_", seq(1, 3), sep = ""), col =colors, lty = 1)

for (i in 1:3) {
  lines(
    energy_data$DateTime,
    energy_data[[paste("Sub_metering_", i, sep = "")]],
    col = colors[[i]],
    type="l"
  )
}

dev.off()
