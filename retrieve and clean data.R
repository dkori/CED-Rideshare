# script to retreive taxi driver data from Census nonemployment data api, create estimate of non-ridershare workers
  #and subtract to estimate ride-share drivers
rm(list=ls())
require(httr)
require(tidyr)
require(dplyr)
require(readr)
require(jsonlite)

years<-2011:2016

#write function that calls the API for the given year, adds a year column to the matrix

call_api<-function(year){
  print(year)
  if(year<2012){
    url<-paste0("https://api.census.gov/data/",year,"/nonemp?get=NESTAB,NRCPTOT&for=county:*&in=state:42&NAICS2007=4853")
    
  }else{
    url<-paste0("https://api.census.gov/data/",year,"/nonemp?get=NESTAB,NRCPTOT&for=county:*&in=state:42&NAICS2012=4853")  
  }
  
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
glimpse(dataset)
save(dataset,file="drivers and earnings by county PA 2010-2016.rda")

#convert matrix to dataframe so we can store numeric values
dataframe<-as.data.frame(dataset)
dataframe$NESTAB<-as.numeric(paste(dataframe$NESTAB))
dataframe$NRCPTOT<-as.numeric(paste(dataframe$NRCPTOT))

#define the 3 geographies and aggregate up to them
  #PA is all, Allegheny is 003, Philadelphia is 101

PA<-aggregate(cbind(NESTAB,NRCPTOT)~year,dataframe,sum)
#AC = allegheny county
AC<-dataframe[dataframe[,"county"]=="003",c("year","NESTAB","NRCPTOT")]
#PC = philadelphia county
PC<-dataframe[dataframe[,"county"]=="101",c("year","NESTAB","NRCPTOT")]

#function takes a dataset as an argument, calculates the estimate of actual taxi drivers for each year after 2012

taxi_predict<-function(x){
  first_year<-min(as.numeric(paste(dataframe$year)))
  growth_factor_driver<-x[x$year==(first_year+1),"NESTAB"]/x[x$year==first_year,"NESTAB"]
  first_year_driver<-x[x$year==first_year,"NESTAB"]
  
  growth_factor_rev<-x[x$year==first_year+1,"NRCPTOT"]/x[x$year==first_year,"NRCPTOT"]
  first_year_rev<-x[x$year==first_year,"NRCPTOT"]
  
  x$`Taxi Drivers`<-first_year_driver*(growth_factor_driver^(as.numeric(paste(x$year))-first_year))
  x$`Rideshare Drivers`<-x$NESTAB-x$`Taxi Drivers`
  x$`Taxi Revenue`<-first_year_rev*(growth_factor_rev^(as.numeric(paste(x$year))-first_year))
  x$`Rideshare Revenue`<-x$NRCPTOT-x$`Taxi Revenue`
  x
}

PA<-taxi_predict(PA)
AC<-taxi_predict(AC)
PC<-taxi_predict(PC)

#store the datasets
save(PA,AC,PC,file="PA-allegheny-philly driver rev estimates")

#find the state level rate of change between 2012 and 2013
growth_rate<-sum(as.numeric(dataset[dataset[,"year"]==2013,"NESTAB"]))/
  sum(as.numeric(dataset[dataset[,"year"]==2012,"NESTAB"]))
#create a matrix that stores the growth rate for all of the 
rates_matrix<-matrix(years,nrow=length(years),ncol=2)
names(rates_matrix)<-c()
for(x in years){
  rates_matrix[]
  
  
}