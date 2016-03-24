#init
install.packages(c("ggmap","ggplot2","Hmisc")) 
library(ggmap)
library(ggplot2)
library(Hmisc)

# data fetch
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv"
Earthquake_30Days <- read.table(URL, sep = ",", header = T)

# exploration
head(Earthquake_30Days)
describe(Earthquake_30Days)

#data description

# show on map
map <- get_map(location = c(lon = mean(Earthquake_30Days$longitude), lat = mean(Earthquake_30Days$latitude)), zoom = 4,maptype = "satellite", scale = 2)
ggmap(map) + geom_point(data = Earthquake_30Days, aes(x = longitude, color = mag,y = latitude, alpha = 0.1), size = 2, shape = 21) +  guides(fill=FALSE, alpha=FALSE, size=FALSE) + scale_color_gradient(low="yellow", high="red")


