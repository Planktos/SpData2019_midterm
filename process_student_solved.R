library(stringr)
library(plyr)
library(dplyr)
library(lubridate)

# Macrozooplankton data ----
#read in  data
z <- read.csv("195101-201404_Zoop.csv", sep = ",",stringsAsFactors = F, header = T)
z <- z[,which(unlist(lapply(z, function(x)!all(is.na(x)))))] #using the "lapply" function from the "dplyr" package, remove fields which contain all "NA" values

#create new fields with decimal degree latitude and longitude values
z$Lat_DecDeg <- z$Lat_Deg + (z$Lat_Min/60)
z$Lon_DecDeg <- (z$Lon_Deg + (z$Lon_Min/60))*-1

# create a date-time field
z$dateTime <- str_c(z$Tow_Date," ",z$Tow_Time,":00")
z$dateTime <- as.POSIXct(strptime(z$dateTime, format = "%m/%d/%Y %H:%M:%S", tz = "GMT")) #Hint: look up input time formats for the 'strptime' function
z$tow_date <- NULL; z$tow_time <- NULL

z$year <- year(z$dateTime)
nz <- z[z$dateTime >= "1997-01-01 00:00:00" & z$dateTime <= "1998-12-31 00:00:00",]
nz <- nz[!is.na(nz),]


#export data as tab delimited file
write.table(nz, "Zoop_ElNino.txt", sep="\t", row.names = F)

#Egg data Set-----

#read in data set
e <- read.csv("erdCalCOFIcufes_bb4a_5c83_ad3a.csv", stringsAsFactors = F, header = T)

#turn these character fields into date-time field
e$stop_time_UTC <- gsub(x = e$stop_time_UTC, pattern = "T", replacement = " ")
e$stop_time_UTC <- gsub(x = e$stop_time_UTC, pattern = "Z", replacement = "")
e$stop_time_UTC <- as.POSIXct(strptime(e$stop_time_UTC, format = "%Y-%m-%d %H:%M:%S", tz = "GMT")) #Hint: look up input time formats for the 'strptime' function

e$time_UTC <- gsub(x = e$time_UTC, pattern = "T", replacement = " ")
e$time_UTC <- gsub(x = e$time_UTC, pattern = "Z", replacement = "")
e$time_UTC <- as.POSIXct(strptime(e$stop_time_UTC, format = "%Y-%m-%d %H:%M:%S", tz = "GMT")) #Hint: look up input time formats for the 'strptime' function

e <- e[,c(1:4,28,5:26)]
e$year <- year(e$time_UTC)
#export data
write.table(z, "Egg.txt", sep="\t", row.names = F, col.names = T)

ne <- e[e$time_UTC >= "1997-01-01 00:00:00" & e$time_UTC <= "1998-12-31 00:00:00",]
ne <- ne[complete.cases(ne),]

write.table(ne, "Egg_Nino.txt", sep="\t", row.names = F, col.names = T)


