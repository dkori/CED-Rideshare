# script to retreive taxi driver data from Census nonemployment data api, create estimate of non-ridershare workers
  #and subtract to estimate ride-share drivers
rm(list=ls())
require(httr)
require(tidyr)
require(readr)
require(jsonlite)

years<-2012:2016

#write function that calls the API for the given year, adds a year column to the matrix

call_api<-function(year){
  url<-paste0("https://api.census.gov/data/",year,"/nonemp?get=NESTAB,NRCPTOT&for=county:*&in=state:42&NAICS2012=4853")
  #call API, retrieve content
  content<-GET(url)%>%content
  #for each item in content, unlist the result and rbind it
  data<-do.call(rbind,
                lapply(content,function(x)unlist(x)))

  #add a column for year
  data<-cbind(data,c("year",rep(year,nrow(data)-1)))
  
  #assign first column of data as names
  colnames(data)<-data[1,]
  #remove the first row that you just made column names, return that
  data[2:nrow(data),]
}

dataset<-do.call(rbind,
                 lapply(years,call_api))

save(dataset,file="drivers and earnings by county PA 2012-2016.rda")


