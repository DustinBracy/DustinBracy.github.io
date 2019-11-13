library(shiny)

ui <- fluidPage(
  
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Read Beer File:
      fileInput("file", label = h3("Upload Beer Data")),

      # Input: radio buttons for boxplot/histogram
      radioButtons("RadioPlotType", label = h3("Plot Type"),
                   choices = list("Histogram" = 'histogram', "Boxplot" = 'boxplot'), 
                   selected = 'histogram'),
      
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
      selectInput("states", label = h3("State Filter"), choices = NULL, multiple = T),
      
      hr(),
      fluidRow(column(1, verbatimTextOutput("FileName"))),
      fluidRow(column(2, verbatimTextOutput("PlotTypeValue"))),
      fluidRow(column(3, verbatimTextOutput("states"))),
      fluidRow(column(4, verbatimTextOutput("IBUbins"))),
      fluidRow(column(5, verbatimTextOutput("ABVbins")))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "IBUplot"),
      plotOutput(outputId = "ABVplot"),
      tableOutput('FileContents')
    )
  )
)
