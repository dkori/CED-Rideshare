# CED-Rideshare
Part of my application for the data assistant position with CED - reading in data on rideshare employment from ACS

Starting point - procedure established here to identify total pool of self-employed cab drivers and ride-share users: https://www.census.gov/library/stories/2018/08/gig-economy.html


Retrieve data from non-employer statistics API found here:  https://www.census.gov/data/developers/data-sets/cbp-nonemp-zbp/nonemp-api.html

From there, find the CAGR between 2009 and 2013 - establish this for the baseline growthrate in taxi-employment. Estimate taxi employment for 2014-2016 by extrapolating using CAGR from 2009-2013. Subtract estimated taxi-employment to find  non-taxi (i.e. rideshare employment). 

This estimate likely underestimates the share of total employment-code-4853 workers who drive for rideshare services. Growth rate in the taxi/formal livery system probably didn't follow exact same trend as 2009-2013 because potential new drivers in this industry had the outside option of driving for uber/lyft instead. Additionally, some former taxi drivers probably left the industry to drive for uber.  The study referenced here (https://www.forbes.com/sites/adigaskell/2017/01/26/study-explores-the-impact-of-uber-on-the-taxi-industry/#2e869f3416b0) suggests that the traditional taxi industry continued to grow in employment despite uber/lyft, so this probably isn't a huge overestimate. 





