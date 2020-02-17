#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

fifa <- read.csv("data/data.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("fifa"),

    # Sidebar with a slider input for number of bins 
    tabsetPanel(
    tabPanel("Compare Players", 
             titlePanel("Player Description"),
             sidebarLayout(
                 sidebarPanel(
                     selectizeInput(inputId = 'name', label = 'Search', choices = fifa$Name,
                                    selected = "L. Messi", multiple = TRUE, options = list(create = TRUE))
                     
                     #selectInput("overall", "Overall Rating:", fifa$Overall)),
                     # selectInput("Player Attributes", "Overall Rating:", fifa$Overall)),
                 ),
                 mainPanel(
                     tabsetPanel(
                         tabPanel("Description", tableOutput("table1"))
        )
    )
))))

# Define server logic required to draw a histogram
server <- function(input, output) {

    fifa_subset <- reactive({filter(fifa, Name %in% input$name)})
    
    output$table1 <- renderTable({
        xtable(fifa_subset())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
