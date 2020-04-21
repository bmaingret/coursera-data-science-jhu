source("load_data.R")
if (!exists("energy_data")){
  energy_data <- load_data()
} 

png(
  file = "plot1.png",
  height = 480 ,
  width = 480 ,
  units = "px",
  type="windows"
)

with(energy_data,
     hist(Global_active_power, col = "red", main = "Global Active Power"))

dev.off()
