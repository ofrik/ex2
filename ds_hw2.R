#init
install.packages(c("ggmap","ggplot2","Hmisc")) 
library(ggmap)
library(ggplot2)
library(Hmisc)

#http://earthquake.usgs.gov/earthquakes/feed/v1.0/glossary.php

# data fetch
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv"
Earthquake_30Days <- read.table(URL, sep = ",", header = T)

# exploration
head(Earthquake_30Days)
describe(Earthquake_30Days)

drops <- c("nst","gap","dmin","magError","magNst")
dataClean <- Earthquake_30Days[, !(names(Earthquake_30Days) %in% drops)]
dataClean<-dataClean[complete.cases(dataClean),]
dataClean <- dataClean[dataClean$type=="earthquake",]


boxplot(mag~net,data=dataClean,col="red")
boxplot(Earthquake_30Days)

#data description

# show on map
map <- get_map(location = c(lon = mean(Earthquake_30Days$longitude), lat = mean(Earthquake_30Days$latitude)), zoom = 4,maptype = "satellite", scale = 2)
ggmap(map) + geom_point(data = Earthquake_30Days, aes(x = longitude, color = mag,y = latitude, alpha = 0.1), size = 2, shape = 21) +  guides(fill=FALSE, alpha=FALSE, size=FALSE) + scale_color_gradient(low="yellow", high="red")


