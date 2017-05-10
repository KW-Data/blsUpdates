
# library(devtools)
# install_github("mikeasilva/blsAPI")
library(blsAPI)
library(RCurl)
library(RJSONIO)
library(ggplot2)
library(dplyr)
library(scales)
library(plotly)

####Load and clean data
#Start and End Years for BLS data and Month to Filter
startYear <- 2007
endYear   <- 2017
blsMonth  <- 'March'
apiKey    <- '2691a2506f514617823b4e653111fdc9'
#,'startyear'= startYear, 'endyear' = endYear
#Load data and parse it out with RJSONIO
#BLS series LNS14000000 returns the Seasonally Adjusted Unemployment Rate for individuals 16 and over.

###########################################################################################################
## FUNCTIONS ##
###########################################################################################################
#Convert Data from BLS API to DataFrame
apiDataConverter <- function(seriesId) {
       payload     <- list('seriesid'        = seriesId,
                           'startyear'       = startYear, 
                           'endyear'         = endYear, 
                           'registrationKey' = apiKey)
       bls.content <- blsAPI(payload)
       bls.json    <- fromJSON(bls.content, simplify=TRUE)
       tmp         <- bls.json$Results[[1]][[1]]
       bls.df      <- data.frame(year=sapply(tmp$data,"[[","year"),
                                 period=sapply(tmp$data,"[[","period"),
                                 periodName=sapply(tmp$data,"[[","periodName"),
                                 value=as.numeric(sapply(tmp$data,"[[","value")),
                                 stringsAsFactors=FALSE)
}

###########################################################################################################
## CREATE DATAFRAMES AND FORMAT ##
###########################################################################################################

#### Labor Force Series ID's ###
JeffersonCountyLaborForce <- apiDataConverter("LAUCN211110000000006")
KentuckyLaborForce        <- apiDataConverter("LAUST210000000000006")
LouisvilleLaborForce      <- apiDataConverter("LAUMT213114000000006")
UnitedStatesLaborForce    <- apiDataConverter("LNU01000000")

#### Employment  Series ID's ###
JeffersonCountyEmployment <- apiDataConverter("LAUCN211110000000005")
KentuckyEmployment        <- apiDataConverter("LAUST210000000000005")
LouisvilleEmployment      <- apiDataConverter("LAUMT213114000000005")

### Unemployment Rate Series ID's ###
JeffersonCountyUnemployment <- apiDataConverter("LAUCN211110000000003")
KentuckyUnemployment        <- apiDataConverter("LAUST210000000000003")
LouisvilleUnemployment      <- apiDataConverter("LAUMT213114000000003")
UnitedStatesUnemployment    <- apiDataConverter("LNU04000000")


#Add area variable to data
### Labor Force ###
JeffersonCountyLaborForce$area   <- "Jefferson County"
KentuckyLaborForce$area          <- "Kentucky"
LouisvilleLaborForce$area        <- "Louisville MSA"
UnitedStatesLaborForce$area      <- "United States"
#UnitedStatesLaborForce$value    <- (UnitedStatesLaborForce$value)*1000

###  Employment ###
JeffersonCountyEmployment$area   <- "Jefferson County"
KentuckyEmployment$area          <- "Kentucky"
LouisvilleEmployment$area        <- "Louisville MSA"

### Unemployment ###
JeffersonCountyUnemployment$area <- "Jefferson County"
KentuckyUnemployment$area        <- "Kentucky"
LouisvilleUnemployment$area      <- "Louisville MSA"
UnitedStatesUnemployment$area    <- "United States"


################### Combine dataframes
### Labor Force ###
laborForceData       <- rbind(JeffersonCountyLaborForce, 
                              KentuckyLaborForce, 
                              LouisvilleLaborForce)

### Employment ###
employmentData       <- rbind(JeffersonCountyEmployment, 
                              KentuckyEmployment, 
                              LouisvilleEmployment)

### Unemployment ###
unemploymentRateData <- rbind(UnitedStatesUnemployment,
                              KentuckyUnemployment, 
                              LouisvilleUnemployment, 
                              JeffersonCountyUnemployment
)

################## Filter for specified month
### Labor Force ###
laborForceData       <- laborForceData %>% filter(periodName == blsMonth)

###  Employment ###
employmentData       <- employmentData %>% filter(periodName == blsMonth)

### Unemployment ###
unemploymentRateData <- unemploymentRateData %>% filter(periodName == blsMonth)

save(laborForceData,       file = "laborForce.Rda")
save(employmentData,       file = "employment.Rda")
save(unemploymentRateData, file = "unemployment.Rda")
