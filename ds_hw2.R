#init
install.packages(c("ggmap","ggplot2","Hmisc")) 
library(ggmap)
library(ggplot2)
library(Hmisc)
library(caret)

# http://earthquake.usgs.gov/earthquakes/feed/v1.0/glossary.php

# data fetch
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv"
Earthquake_30Days <- read.table(URL, sep = ",", header = T)

# exploration
head(Earthquake_30Days)
describe(Earthquake_30Days)
summary(Earthquake_30Days)

drops <- c("nst","gap","dmin","magError","magNst")
dataClean <- Earthquake_30Days[, !(names(Earthquake_30Days) %in% drops)]
dataClean<-dataClean[complete.cases(dataClean),]
dataClean <- dataClean[dataClean$type=="earthquake",]

# data analysis

## check correlation between numeric columns
numCols <- c("mag","rms","depth","horizontalError","depthError","latitude","longitude")
corMatrix <- cor(dataClean[,names(dataClean) %in% numCols])
corMatrix
# we can see that the rms and magnitude have the highest correlation which we could expect because it make sense that big earthquakes will move faster or be noticed faster then small ones

# graphs of some of the data columns
# lets look on who first reported the events based on the magnitude
boxplot(dataClean$mag,col="red")
boxplot(mag~locationSource,data=dataClean,col="red")

#lets look at location clusters
with(dataClean,plot(longitude,latitude))

map <- get_map(location = c(lon = -125, lat = 50), zoom = 3,maptype = "satellite", scale = 2)
ggmap(map) + geom_point(data = dataClean, aes(x = longitude, color = mag,y = latitude, alpha = 0.1), size = 2, shape = 21) +  guides(fill=FALSE, alpha=FALSE, size=FALSE) + scale_color_gradient(low="yellow", high="red")

map <- get_map(location = c(lon = 130, lat = 0), zoom = 3,maptype = "satellite", scale = 2)
ggmap(map) + geom_point(data = dataClean, aes(x = longitude, color = mag,y = latitude, alpha = 0.1), size = 2, shape = 21) +  guides(fill=FALSE, alpha=FALSE, size=FALSE) + scale_color_gradient(low="yellow", high="red")

plot(dataClean$mag,dataClean$rms)
plot(dataClean$mag,dataClean$depth)


hoursData <- as.numeric(format(strptime(dataClean$time, "%Y-%m-%dT%H:%M:%S"),format = '%H'))
hist(hoursData)

