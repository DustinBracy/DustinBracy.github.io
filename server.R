library(shiny)
library(tidyverse)
#library(rsconnect)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  
  #require file
 # req(input$file)
  #Get beer data
  
  #prints filename after upload
  output$FileName <- renderPrint({
    str(input$file)
  })
  
  output$PlotTypeValue <- renderPrint({str(input$RadioPlotType)})
  

  #render head of the data, can delete
  output$FileContents <- renderTable(
    head(read.csv(req(input$file$datapath), header=T))
    )
  
  #render IBU Plots
  output$IBUplot <- renderPlot({
    beerdata <- read.csv(req(input$file$datapath), header=T)
    x <- beerdata %>% select(IBU) %>% filter(!is.na(IBU))
    x <- as.numeric(x$IBU)
    IBUbins <- seq(min(x), max(x), length.out = input$IBUbins + 1)
    
    if (input$RadioPlotType == "boxplot") {
      boxplot(x, col = "#75AADB", border = "white",
              xlab = "Beer Distribution",
              ylab = "IBU Rating",
              main = "Boxplot of International Bitterness Units (IBU)")
    } else {
    
      hist(x, breaks = IBUbins, col = "#75AADB", border = "white",
           xlab = "IBU Rating",
           ylab = "Number of Beers",
           main = "Histogram of International Bitterness Units (IBU)")
    }
  })
  
  #render ABV Plots
  output$ABVplot <- renderPlot({
    beerdata <- read.csv(req(input$file$datapath), header=T)
    x <- beerdata %>% select(ABV) %>% filter(!is.na(ABV))
    x <- as.numeric(x$ABV)
    ABVbins <- seq(min(x), max(x), length.out = input$ABVbins + 1)
    

    if (input$RadioPlotType == "boxplot") {
    boxplot(x, col = "#75AADB", border = "white",
            xlab = "Beer Distribution",
            ylab = "ABV Rating",
            main = "Boxplot of Alcohol by Volume (ABV)")
    } else {
      hist(x, breaks = ABVbins, col = "#75AADB", border = "white",
           xlab = "ABV Rating",
           ylab = "Number of Beers",
           main = "Histogram of Alcohol by Volume (ABV)")
    }
  })
}

#deployApp()

#shinyApp(ui, server)


