#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel("France Birth"),
    tags$style(type = "text/css", "#map {height: 80vh !important;}"),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            fluidRow(sliderInput(
                "year",
                "Year",
                min = 1975,
                max = 2018,
                value = 2018,
                step = 1
            )),
            fluidRow(plotOutput("regPlot"))
        ),
        
        # Show a plot of the generated distribution
        mainPanel(tabsetPanel(
            tabPanel("France Birth Data",
                     leafletOutput("map")),
            
            tabPanel("Documentation",
                     includeMarkdown("documentation.md"))
        ))
    )
))
