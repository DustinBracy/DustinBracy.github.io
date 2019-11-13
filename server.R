library(shiny)
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
  output$value <- renderPrint({
    str(input$file)
  })
  
  beerdata <- reactive({
    beerdata <- input$file
    if (is.null(beerdata)){
      return(NULL)
    }
    return(read.csv(input$file$datapath, header=T))
  })
  
  output$contents <- renderTable(beerdata)
  
  output$IBUplot <- renderPlot({
    
    x    <- faithful$waiting
    IBUbins <- seq(min(x), max(x), length.out = input$IBUbins + 1)
    
    hist(x, breaks = IBUbins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
  
  output$ABVplot <- renderPlot({
    
    x    <- faithful$waiting
    ABVbins <- seq(min(x), max(x), length.out = input$ABVbins + 1)
    
    hist(x, breaks = ABVbins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
}
#deployApp()

#shinyApp(ui, server)


