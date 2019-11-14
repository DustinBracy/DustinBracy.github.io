library(shiny)
library(shinyjs)
library(rsconnect)
ui <- fluidPage(
  useShinyjs(),
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
     
       # Read Beer File:
      fileInput("BeerFile", label = h3("Upload Beer Data")),
     
       # Input: radio buttons for boxplot/histogram
      radioButtons("RadioPlotType", label = h3("Plot Type"),
                   choices = list("Histogram" = 'histogram', "Boxplot" = 'boxplot'),# "Scatterplot"='scatterplot'), 
                   selected = 'histogram'),
     
       # Input: Regression line boolean
      checkboxInput("line", label = "Include Regression Line", value = TRUE),
      
      # Input: Slider for the number of IBU bins
      sliderInput(inputId = "IBUbins",
                  label = "IBU Bin Control:",
                  min = 1,
                  max = 50,
                  value = 30),
      
      # Input: Slider for the number of ABV bins
      sliderInput(inputId = "ABVbins",
                  label = "ABV Bin Control:",
                  min = 1,
                  max = 50,
                  value = 30),

      # Input: State picker 
      selectInput("states", label = h3("State Filter"), multiple =T, 
                  choices = list("AK"="AK","AL"="AL","AR"="AR","AZ"="AZ","CA"="CA","CO"="CO","CT"="CT","DC"="DC","DE"="DE","FL"="FL","GA"="GA","HI"="HI","IA"="IA","ID"="ID","IL"="IL","IN"="IN","KS"="KS","KY"="KY","LA"="LA","MA"="MA","MD"="MD","ME"="ME","MI"="MI","MN"="MN","MO"="MO","MS"="MS","MT"="MT","NC"="NC","ND"="ND","NE"="NE","NH"="NH","NJ"="NJ","NM"="NM","NV"="NV","NY"="NY","OH"="OH","OK"="OK","OR"="OR","PA"="PA","RI"="RI","SC"="SC","TN"="TN","TX"="TX","UT"="UT","VA"="VA","VT"="VT","WA"="WA","WI"="WI","WV"="WV","WY"="WY"),
                  selected = c("AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","TN","TX","UT","VA","VT","WA","WI","WV","WY")
                  ),

      
      
      hr(),
     # fluidRow(column(12, verbatimTextOutput("FileName"))),
     # fluidRow(column(12, verbatimTextOutput("PlotTypeValue"))),
     # fluidRow(column(12, verbatimTextOutput("states"))),
     # fluidRow(column(12, verbatimTextOutput("IBUbins"))),
     # fluidRow(column(12, verbatimTextOutput("ABVbins")))
      #?fluidRow
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "IBUplot"),
      plotOutput(outputId = "ABVplot"),
      plotOutput(outputId = "ScatterPlot"),
      plotOutput(outputId = "CityPlot"),
      plotOutput(outputId = "BrewPlot")
      #tableOutput("FileContents")
    )
  )
)
