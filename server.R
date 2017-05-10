
# library(devtools)
# install_github("mikeasilva/blsAPI")
library(shiny)
library(RCurl)
library(RJSONIO)
library(ggplot2)
library(dplyr)
library(scales)
library(plotly)
library(treemap)

load('laborForce.Rda')
load('employment.Rda')
load('unemployment.Rda')



as <- asPostings - baPostings
ba <- baPostings
other <- totalPostings - asPostings

as    <- as.data.frame(as)
ba    <- as.data.frame(ba)
other <- as.data.frame(other)

colnames(as)[1] <- "postings"
colnames(ba)[1] <- "postings"
colnames(other)[1] <- "postings"

as$label    <- paste("Associate's degree job postings", "\n", percent(as$postings/totalPostings))
ba$label    <- paste("Bachelor's or higher job postings", "\n", percent(ba$postings/totalPostings))
other$label <- paste("All other job postings", "\n",  percent(other$postings/totalPostings))

eduPostings <- rbind(other, as, ba)

###################### Convert values to numeric 
### Labor Force ###
# laborForceData$value         <- as.numeric(as.character(laborForceData$value))
# UnitedStatesLaborForce$value <- as.numeric(as.character(UnitedStatesLaborForce$value))
# 
# ### Unemployment ###
# unemploymentRateData$value   <- as.numeric(as.character(unemploymentRateData$value))

# lastYearUnemployment <- unemploymentRateData %>%
#                             filter(year == 2015 | year == 2016) %>%
#                             select(area, value, year)
# 
# 
# thisYearUnemployment <- unemploymentRateData %>%
#                             filter(year == 2017)

font     <- list(
       family = "Helvetica, sans-serif",
       size = 20,
       color = "#1f1f2e")

axisFont <- list(
       size = 18)

xAxis    <- list(
       title = "Year",
       titlefont = axisFont)


yAxisLaborForce       <- list(
                            title = "Labor Force",
                            titlefont = axisFont)

yAxisEmployment       <- list(
                            title = "Employment",
                            titlefont = axisFont)

yAxisUnemploymentRate <- list(
                            title = "Unemployment Rate",
                            titlefont = axisFont)
       

margin = list(
              l = 80,
              r = 50,
              b = 100,
              t = 50,
              pad = 1)

################################################### SHINY SERVER

shinyServer(function(input, output) {
  #      
  # output$unemploymentLastYear <- renderDataTable({
  #        lastYearUnemployment
  # 
  # })
  # output$unemploymentThisYear <- renderPrint({
  #        print(thisYearUnemployment)
  # })

           
  output$laborForcePlot <- renderPlotly({
         
         plot_ly(laborForceData, 
                 x = ~year, 
                 y = ~value, 
                 color = ~area,
                 type = 'scatter', 
                 mode = 'lines+markers') %>%
                layout(
                       autosize = F, 
                       # width  = 700, 
                       # height = 500, 
                       margin = margin, 
                       xaxis  = xAxis, 
                       yaxis  = yAxisLaborForce,
                       font   = font, 
                       legend = list(
                              x = .6, 
                              y = .6))
  })
  
  
  output$unemploymentRatePlot <-  renderPlotly({
         
         plot_ly(unemploymentRateData, 
                 x = ~year, 
                 y = ~value, 
                 color = ~area,
                 type = 'scatter', 
                 mode = 'lines+markers') %>%
                layout(
                       autosize = F, 
                       # width  = 700, 
                       # height = 500, 
                       margin = margin, 
                       xaxis  = xAxis, 
                       yaxis  = yAxisUnemploymentRate,
                       font   = font, 
                       legend = list(
                              x = .7, 
                              y = .95))

  })
  
  output$employmentPlot <- renderPlotly({
         
         plot_ly(employmentData, 
                 x = ~year, 
                 y = ~value, 
                 color = ~area,
                 type = 'scatter', 
                 mode = 'lines+markers') %>%
                layout(
                       autosize = F, 
                       # width  = 700, 
                       # height = 500, 
                       margin = margin, 
                       xaxis  = xAxis, 
                       yaxis  = yAxisEmployment,
                       font   = font, 
                       legend = list(
                              x = .6, 
                              y = .6))
  })
  
  output$postingsTreemap <- renderPlot({
         treemap(eduPostings, "label",  "postings", title = "")
  })

})
