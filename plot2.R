source("load_data.R")
if (!exists("energy_data")){
  energy_data <- load_data()
} 

png(
  file = "plot2.png",
  height = 480 ,
  width = 480 ,
  units = "px",
  type="windows"
)

Sys.setlocale("LC_TIME", "English")

with(
  energy_data,
  plot(
    DateTime,
    Global_active_power,
    type = "l",
    col = "black",
    ylab = "Global Active Power (kilowatts)",
    xlab = ""
  )
)


dev.off()
