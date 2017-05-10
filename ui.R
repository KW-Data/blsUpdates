library(shiny)
library(blsAPI)
library(RCurl)
library(RJSONIO)
library(ggplot2)
library(dplyr)
library(scales)
library(plotly)
library(shinythemes)


################################################################################################################################################################
################################################################################################################################################################
totalJobPostings  <- format(totalPostings, big.mark = ',')
baPlusJobPostings <- format(baPostings,    big.mark = ',')
asPlusJobPostings <- format(asPostings,    big.mark = ',')
percentBachelors  <- percent(round((baPostings/totalPostings), digits = 4)) 
percentAssociates <- percent(round((asPostings/totalPostings), digits = 4)) 
percentageBaPlus  <- percentBachelors
#postingsChange    <- (totalPostings - lastMonthsPostings)
#baChange          <- (baPostings - baLastMonth)



shinyUI(fluidPage(
       theme = shinytheme("journal"),

    # Show a plot of the generated distribution
   fluidRow(
    column(12, 
       align = "center",
       h1("Unemployment Rate,", month, yearRange),
       h6('Data Source: Bureau of Labor Statistics, Local Area Unemployment Statistics. Data Released: ', dataRelease),
       plotlyOutput("unemploymentRatePlot"),
       br(),
       br()),
    
    column(12, 
       br(), 
       br(),
       align = "center",
       h1("Size of Labor Force,", month,  yearRange),
       h6('Data Source: Bureau of Labor Statistics, Local Area Unemployment Statistics. Data Released: ', dataRelease),
       plotlyOutput("laborForcePlot")
    ),
    
    column(12, 
           br(),
           br(),
           br(),
           br(),
           align = "center",
           h1("Employment,", month, yearRange),
           h6('Data Source: Bureau of Labor Statistics, Local Area Unemployment Statistics. Data Released: ', dataRelease),
           plotlyOutput("employmentPlot"),
           br(),
           br()),
    
    column(12,
       align = "center",
       br(), 
       br(),
       br(), 
       br(),
       h1("Online Job Postings, ", month, currentYear), 
       h3("Total: ", totalJobPostings, br(), "Associates or higher:", asPlusJobPostings, br(), "Bachelors or higher: ", baPlusJobPostings)
           ), 
       align = "center",
       h4(percentAssociates, "of online job postings are adverstising for a associates's degree or higher in the Louisville MSA"), 
       h6('Data Source: Burning Glass Labor Insights'), 
       plotOutput('postingsTreemap'),
    br(), 
    br(),
    br(), 
    br(),
    br(), 
    br()
  )))



