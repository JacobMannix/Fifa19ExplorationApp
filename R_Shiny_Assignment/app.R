#
# R Shiny Assignment
# Jacob Mannix

# Libraries
library(shiny)
library(shinythemes)
library(dplyr)
library(xtable)
library(ggplot2)
library(shinyWidgets)
library(ggthemes)

# Data
fifa <- read.csv("data/data.csv")

#Renaming Columns
colnames(fifa)[colnames(fifa) == 'Weak.Foot'] <- 'WeakFoot'
colnames(fifa)[colnames(fifa) == 'Skill.Moves'] <- 'SkillMoves'
colnames(fifa)[colnames(fifa) == 'Work.Rate'] <- 'WorkRate'
colnames(fifa)[colnames(fifa) == 'Body.Type'] <- 'BodyType'
colnames(fifa)[colnames(fifa) == 'Real.Face'] <- 'RealFace' #may not need
colnames(fifa)[colnames(fifa) == 'Loaned.From'] <- 'LoanedFrom'
colnames(fifa)[colnames(fifa) == 'Contract.Valid.Until'] <- 'ContractValidUntil'
colnames(fifa)[colnames(fifa) == 'Jersey.Number'] <- 'JerseyNumber'
colnames(fifa)[colnames(fifa) == 'Release.Clause'] <- 'ReleaseClause'

# Specifying List of certain attributes
playerAtt <- c("Name", "Age", "Nationality", "Overall", "Club", "Value", "Wage", "Height", "Weight", "JerseyNumber", "ReleaseClause")
playerAttNUM <- c("Age", "Wage", "Height", "Weight", "ReleaseClause")

fifaAtt <- c("Name", "Nationality", "Overall", "Club", "WeakFoot", "SkillMoves", "WorkRate", "BodyType", "RealFace", "Position", "JerseyNumber", "Joined",                 
             "LoanedFrom", "ContractValidUntil", "Height", "Weight", "LS", "ST", "RS", "LW", "LF", "CF", "RF", "RW",                      
             "LAM", "CAM", "RAM", "LM", "LCM", "CM", "RCM", "RM", "LWB", "LDM", "CDM", "RDM", "RWB", "LB", "LCB", "CB")

# Creating shortened dataframes for specific attributes
#nums <- unlist(lapply(fifa, is.numeric))  
fifa2 <- fifa[playerAtt]
fifa3 <- fifa[fifaAtt]
fifaNUM <- fifa[playerAttNUM]

# UI for application
ui <- fluidPage(
    #theme = shinytheme("sandstone"),  # try "flatly", "journal", "sandstone", "united", "darkly"
    setBackgroundColor("#00AAD6"), 
    titlePanel(h1("Compare Players in Fifa 19", align = "center"), windowTitle = "Fifa 19 Comparisons"),
    tags$style(HTML("
    .tabbable > .nav > li > a               {background-color: #0B5279; color:#D6BD86}
    .tabbable > .nav > li[class=active] > a {background-color: #1D3468; color:#D6BD86}
    
    .item { #background: #0B5279 !important; #color: #D6BD86 !important;}
            .selectize-dropdown-content .active {background: #1D3468 !important; color: #D6BD86 !important;}
    ")),
    
    tabsetPanel(
        tabPanel("About",
                 img(src="fifa19banner3.jpg", width = "100%", style="display: block; margin-left: auto; margin-right: auto; margin-bottom: -2.25%"),
                 hr(),
                 h3(strong("Whats the point?")), 
                    p("The purpose of this app is to allow the user to easily compare FIFA 19 players on the basis of many attributes that are included in the game."),
                 hr(),
                 h3(strong("What is FIFA19?")),
                    p("FIFA 19 is a football simulation video game developed by EA Vancouver as part of Electronic Arts' FIFA series. 
                      It is the 26th installment in the FIFA series, and was released on 28 September 2018 for PlayStation 3, PlayStation 4, 
                      Xbox 360, Xbox One, Nintendo Switch, and Microsoft Windows."),
                 hr(),
                 h3(strong("About the dataset")),
                    h4("Where is the dataset from?"),
                        p("This dataset comes from Kaggle and was created by", a(href="https://www.kaggle.com/karangadiya", "Karan Gadiya.")), 
                        p("A link to the dataset can be found here:", a(href="https://www.kaggle.com/karangadiya/fifa19", "Kaggle 'FIFA 19 complete player dataset.'")),
                    h4("What is the content of the dataset?"),
                        p("This dataset contains detailed attributes for every player registered in the latest edition of FIFA 19 database (December 20th, 2018).",
                            "The data has been scraped from the website", a(href="https://sofifa.com/", "sofifa"),
                            "and the scraping code can be found on", a(href="https://github.com/amanthedorkknight/fifa18-all-player-statistics/tree/master/2019", "Github.")),
                        p("- 18k+ FIFA 19 players"),
                        p("- ~90 attributes extracted from the latest FIFA database"),
                    h4("Inspiration for the dataset"),
                        p("Inspired from this dataset:", a(href="https://www.kaggle.com/thec03u5/fifa-18-demo-player-dataset", "Kaggle: 'Fifa 18 demo player dataset'")),
                 hr()
                 #p("Create by Jacob Mannix")
                 ),
        
        tabPanel("Compare Players", 
            titlePanel("Select Players to compare"),
            p("Use the search box below to find and select players to compare their attributes."),
            p("The description tab will allow you to see an overall view of the players and their attributes while the vizualization tab will give a closer look at a specific attribute."),
                sidebarLayout(
                    sidebarPanel(
                        selectizeInput(inputId = 'name', label = 'Search Players', choices = fifa$Name,
                                       selected = "L. Messi", multiple = TRUE, options = list(create = FALSE))),
                mainPanel(
                    tabsetPanel(
                        tabPanel("Description", tableOutput("table1")),
                        tabPanel("Viz",
                                 selectInput("att", "Choose a variable to compare:",
                                     choices = colnames(fifaNUM)#,
                                     #selected = colnames(fifaNUM)[1]
                                 ),
                                 #selectizeInput(inputId = 'att', label = 'Search ', choices = colnames(fifa),
                                 #               selected = "Wage", multiple = FALSE, options = list(create = FALSE)),
                                 plotOutput("plot"))
                        )))),
        
        tabPanel("Filter by Attribute",
            titlePanel("Choose and Attribute to filter players"),
            p("Choose an attribute by tab in order to filter players."),
                    mainPanel(
                        tabsetPanel(
                            tabPanel("Overall", 
                                     sliderInput("overall", "Choose an Overall Rating:", min = 46, max = 94, value = 92),
                                     tableOutput("tableOverall")),
                            tabPanel("Age",
                                     sliderInput("age", "Choose an Age:", min = 15, max = 45, value = c(25)),
                                     tableOutput("tableAge")),
                            tabPanel("Nationality",
                                     selectInput("nationality", "Choose a Nationality:", choices = fifa$Nationality, selected = "FC Barcelona"),
                                     tableOutput("tableNationality")),
                            tabPanel("Club",
                                     selectInput("Club", "Choose a Club:", choices = fifa$Club, selected = "Argentina"),
                                     tableOutput("tableClub"))
                                     )))))

# Server logic
server <- function(input, output) {

# First TAB Compare PLAYERS
    # Compare Players
    fifa_subset <- reactive({filter(fifa2, Name %in% input$name)})
    output$table1 <- renderTable({xtable(fifa_subset())})
    
    # Compare Players Plot
    output$plot <- renderPlot({
        y_axis = input$att
        ggplot(fifa_subset(), aes_string(x = fifa_subset()$Name, y = y_axis)) + 
            #theme_classic() +
            theme_economist() +
            theme(panel.border = element_blank(),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  plot.background = element_rect(fill = "#00AAD6")) +
            geom_bar(stat = "identity", fill = '#003366', color = '#add8e6')
    })
    
# Second Tab Compare FIFA ATTRIBUTES
    # Compare Fifa Attributes
    #Overall
    fifa_subset_overall <- reactive({filter(fifa2, Overall == input$overall)})
    output$tableOverall <- renderTable({xtable(fifa_subset_overall())})
    
    #Age
    fifa_subset_Age <- reactive({filter(fifa2, Age == input$age)})
    output$tableAge <- renderTable({xtable(fifa_subset_Age())})

    #Value
    fifa_subset_Nationality <- reactive({filter(fifa2, Nationality == input$nationality)})
    output$tableNationality <- renderTable({xtable(fifa_subset_Nationality())})
    
    #Release Clause
    fifa_subset_Club <- reactive({filter(fifa2, Club == input$Club)})
    output$tableClub <- renderTable({xtable(fifa_subset_Club())})
}

# Run the application 
shinyApp(ui = ui, server = server)