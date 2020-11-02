#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

library(shiny)
library(plotly)
library(dplyr)

trainingpath <- './pml-training.csv'
#' Use fread to load data into R environment.
training <- fread(file = trainingpath, data.table = F,stringsAsFactors = T)
#' Cleaning data
training1 <- training %>% 
        select(!where(anyNA)) %>%
        select(classe,ends_with(c('x','y','z')))

# Define server logic required to draw the 3D plot
shinyServer(function(input, output) {
        
        xinput <- reactive({
                training1[,input$xvariable]
                })
        
        yinput <- reactive({
                training1[,input$yvariable]
        })
        
        zinput <- reactive({
                training1[,input$zvariable]
        })
        
        output$plot <- renderPlotly({
                plot1 <- plot_ly( x = xinput(),
                                  y = yinput(),
                                  z = zinput(),
                                  type='scatter3d',
                                  color=training1$classe,
                                  mode='markers' )
        })
})
