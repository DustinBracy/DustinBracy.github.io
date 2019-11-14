library(shiny)
library(tidyverse)
library(shinyjs)
library(rsconnect)

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
  #getData <- reactive({
   # if( is.null(input$beerFile))
    #  return(NULL)
   # beerdata <- read.csv(req(input$beerFile$datapath), header=T)
   # })
  
  #prints filename after upload
  output$FileName <- renderPrint({
    str(input$BeerFile)
  })
  
  #output$PlotTypeValue <- renderPrint({str(input$RadioPlotType)})
  
  #output$states <-renderPrint(input$states)
 # output$states <- renderUI({
 #   beerdata <- read.csv(req(input$BeerFile$datapath), header=T)
 #   stateList <- unique(beerdata$State) #%>% arrange(State)
    #selectInput("states", choices = stateList, label = h3("State Filter"))
    
 # })
  
#  observeEvent(getData(), {
#    beerdata <- read.csv(req(input$BeerFile$datapath), header=T)
 #   stateList <- unique(beerdata$State) #%>% arrange(State)
 #   updateSelectInput("states", choices = stateList)
 # })

  #render head of the data, can delete
  #output$FileContents <- renderTable(
   # head(read.csv(req(input$BeerFile$datapath), header=T))
    #head(getData)
   # )
  
  #render IBU Plots
  output$IBUplot <- renderPlot({
   # req(input$RadioPlotType != "scatterplot")
   # show("IBUplot")
   # hide("ScatterPlot")
    beerdata <- read.csv(req(input$BeerFile$datapath), header=T)
    beerdata <- beerdata %>% filter(!is.na(IBU)) %>% filter(beerdata$state %in% input$states)
    x <- beerdata %>% select(IBU) 
    x <- as.numeric(x$IBU)
    IBUbins <- seq(min(x), max(x), length.out = input$IBUbins + 1)
    
    if (input$RadioPlotType == "boxplot") {
      boxplot(x, col = "#75AADB", border = "black",
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
   # req(input$RadioPlotType != "scatterplot")
   # show("ABVplot")
   # hide("ScatterPlot")
    beerdata <- read.csv(req(input$BeerFile$datapath), header=T)
    x <- beerdata %>% select(ABV) %>% filter(!is.na(ABV)) %>% filter(beerdata$state %in% input$states)
    x <- as.numeric(x$ABV)
    ABVbins <- seq(min(x), max(x), length.out = input$ABVbins + 1)
    
    if (input$RadioPlotType == "boxplot") {
    boxplot(x, col = "#75AADB", border = "black",
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
  
  #render Scatter Plot
  output$ScatterPlot <- renderPlot({
   # req(input$RadioPlotType == "scatterplot")
   # hide("ABVplot")
   # hide("IBUplot")
   # show("ScatterPlot")
    beerdata <- read.csv(req(input$BeerFile$datapath), header=T)
    Brewdata <- beerdata %>% filter(!is.na(IBU) & !is.na(ABV) & !is.na(Style)) %>% filter(beerdata$state %in% input$states)
    plot <- ggplot(Brewdata, aes(x=IBU, y= ABV)) + 
      geom_point() + 
      theme_classic() +
      theme(axis.text.x=element_text(size=rel(1.0))) +
      labs(x="IBU",y="ABV") +
      ggtitle("Correlation between IBU and ABV")
    
    if(input$line == T){
      plot + geom_smooth(method=lm)
      } 
    else {
      plot
      }
    })


# Calculate Top 10 Cities with the most Breweries
  output$CityPlot <- renderPlot({
    beerdata <- read.csv(req(input$BeerFile$datapath), header=T)
    Brewdata <- beerdata %>% filter(!is.na(IBU) & !is.na(ABV) & !is.na(Style)) %>% filter(beerdata$state %in% input$states)
    TopCities <- Brewdata %>% mutate(City = paste0(City, ', ', state)) %>% group_by(City) %>% 
      summarise(Breweries = n()) %>% arrange(desc(Breweries)) %>% top_n(10)
    
    ggplot(data=TopCities, mapping=aes(x=City, y=Breweries)) + geom_col(color="white",fill="#75AADB") +
      ggtitle("Top 10 Cities with Most Breweries") +
      theme_classic() +
      theme(axis.text.x = element_text(angle = 60, vjust=1, hjust=1))

  })

  # Calculate Top 10 Breweries with the most original beers
  output$BrewPlot <- renderPlot({
    beerdata <- read.csv(req(input$BeerFile$datapath), header=T)
    Brewdata <- beerdata %>% filter(!is.na(IBU) & !is.na(ABV) & !is.na(Style)) %>% filter(beerdata$state %in% input$states)
    
    TopBreweries <- Brewdata %>% mutate(Brewery = paste0(Brewery,'\n', City, ', ', state)) %>% 
      group_by(Brewery) %>% summarise(Beers = n()) %>% arrange(desc(Beers)) %>% top_n(10)
    ggplot(data=TopBreweries, mapping=aes(x=Brewery, y=Beers)) + geom_col(color="white",fill="#75AADB") +
      theme_classic() +
      ggtitle("Top 10 Breweries with Most Original Beers") +
      theme(axis.text.x = element_text(angle = 60, vjust=1, hjust=1))

  
  })
}

deployApp()

#shinyApp(ui, server)