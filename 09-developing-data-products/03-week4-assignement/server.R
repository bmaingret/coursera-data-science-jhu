#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(ggplot2)

pal <- colorNumeric("viridis", NULL)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$map <- renderLeaflet({
        leaflet(regions) %>%
            addTiles() %>%
            addPolygons(
                stroke = FALSE,
                smoothFactor = 0.3,
                fillOpacity = 1,
                fillColor = as.formula(paste0("~pal(y", input$year, ")")),
                label = as.formula(paste0("~paste0(y", input$year, ")"))
            ) %>%
            addLegend(
                pal = pal,
                values = as.formula(paste0("~y", input$year)),
                opacity = 1.0,
                labFormat = labelFormat(
                    transform = round
                )
            )
    })

output$regPlot <- renderPlot({
    ggplot(data = data, aes(x = year, y = value, color = region)) + geom_line() + geom_point(data=data[data$year==input$year, ], mapping=aes(x=input$year, y = value, color=region)) + geom_vline(xintercept = input$year)
})


})
