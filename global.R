## FIND POSTINGS ON BURNING GLASS LABOR INSIGHTS  http://laborinsight.burning-glass.com/jobs/us#
# RELEASE DATES HERE: http://www.bls.gov/schedule/news_release/metro.htm
load("metaData.Rda")


### UPDATE ITEMS ON LINES 7 - 10
dataRelease        <- "5/3/17" # FOR BLS DATA  , Should be the same day you are updating this
totalPostings      <- 10366
asPostings         <- 3142
baPostings         <- 2695
#########################

month              <- paste(metaData$blsMonth[1]) 
yearRange          <- paste(metaData$startYear, "-", metaData$endYear)
currentYear        <- metaData$endYear
