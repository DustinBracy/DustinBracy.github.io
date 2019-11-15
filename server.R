library(shiny)
library(tidyverse)
library(shinyjs)
library(rsconnect)

# replace state thing with this later: https://shiny.rstudio.com/gallery/custom-input-control.html

server <- function(input, output) {

  # Get beer data
  getData <- reactive({
    userFile <- read.csv(req(input$BeerFile$datapath), header=T)
    tidyFile <- userFile %>% filter(!is.na(IBU) & !is.na(ABV) & !is.na(Style)) %>% filter(userFile$state %in% input$states)
  })

  # Downloadable csv of beers dataset
  output$downloadData <- downloadHandler(
    filename = "beer.csv",
    content = function(file) {
      serverFile <- read.csv("./data/beer.csv", header=T)
      serverFile <- serverFile %>% filter(!is.na(IBU) & !is.na(ABV) & !is.na(Style))
      write.csv(serverFile, file, row.names = FALSE)
    }
  )
  
  # Render IBU Plots
  output$IBUplot <- renderPlot({
   # req(input$RadioPlotType != "scatterplot")
   # show("IBUplot")
   # hide("ScatterPlot")
    x <- getData() %>% select(IBU) 
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
  
  # Render ABV Plots
  output$ABVplot <- renderPlot({
   # req(input$RadioPlotType != "scatterplot")
   # show("ABVplot")
   # hide("ScatterPlot")
    x <- getData()
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
  
  # Render Scatter Plot
  output$ScatterPlot <- renderPlot({
   # req(input$RadioPlotType == "scatterplot")
   # hide("ABVplot")
   # hide("IBUplot")
   # show("ScatterPlot")
    plot <- ggplot(getData(), aes(x=IBU, y= ABV)) + 
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
    TopCities <- getData() %>% mutate(City = paste0(City, ', ', state)) %>% group_by(City) %>% 
      summarise(Breweries = n()) %>% arrange(desc(Breweries)) %>% top_n(10)
    
    ggplot(data=TopCities, mapping=aes(x=City, y=Breweries)) + geom_col(color="white",fill="#75AADB") +
      ggtitle("Top 10 Cities with Most Breweries") +
      theme_classic() +
      theme(axis.text.x = element_text(angle = 60, vjust=1, hjust=1))
  })

  # Calculate Top 10 Breweries with the most original beers
  output$BrewPlot <- renderPlot({
    TopBreweries <- getData() %>% mutate(Brewery = paste0(Brewery,'\n', City, ', ', state)) %>% 
      group_by(Brewery) %>% summarise(Beers = n()) %>% arrange(desc(Beers)) %>% top_n(10)
    ggplot(data=TopBreweries, mapping=aes(x=Brewery, y=Beers)) + geom_col(color="white",fill="#75AADB") +
      theme_classic() +
      ggtitle("Top 10 Breweries with Most Original Beers") +
      theme(axis.text.x = element_text(angle = 60, vjust=1, hjust=1))
  })

}

#deployApp()

#shinyApp(ui, server)