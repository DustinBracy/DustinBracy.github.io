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
      
      # Input: Slider for the number of IBU bins ----
      sliderInput(inputId = "IBUbins",
                  label = "IBU Bin Control:",
                  min = 1,
                  max = 50,
                  value = 30),
      
      # Input: Slider for the number of ABV bins ----
      sliderInput(inputId = "ABVbins",
                  label = "ABV Bin Control:",
                  min = 1,
                  max = 50,
                  value = 30),

      
      hr(),
      #fluidRow(column(4, verbatimTextOutput("value")))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "IBUplot"),
      plotOutput(outputId = "ABVplot"),
      tableOutput('contents')
    )
  )
)
