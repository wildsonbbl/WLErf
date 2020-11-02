#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(data.table)
library(dplyr)

trainingpath <- './pml-training.csv'
#' Use fread to load data into R environment.
training <- fread(file = trainingpath, data.table = F,stringsAsFactors = T)
#' Cleaning data
training1 <- training %>% 
    select(!where(anyNA)) %>%
    select(classe,ends_with(c('x','y','z')))

xvariables <- training1 %>%
    select(ends_with(c('x'))) %>% names()
yvariables <- training1 %>%
    select(ends_with(c('y'))) %>% names()
zvariables <- training1 %>%
    select(ends_with(c('z'))) %>% names()

#' Define UI for application that draws 3D plots of 
#' the Weight Lifting Exercises Dataset

shinyUI(
    fluidPage(

    # Application title
    titlePanel("Weight Lifting Exercises Dataset"),

    # Sidebar with select lists for the variables to be displayed 
    sidebarLayout(
        sidebarPanel(
            selectInput('xvariable','Select the x variable',
                        xvariables,
                        selected = 'gyros_belt_x'),
            selectInput('yvariable','Select the correspondent y variable',
                        yvariables,
                        selected = 'gyros_belt_y'),
            selectInput('zvariable','Select the correspondent z variable',
                        zvariables,
                        selected = 'gyros_belt_z'),
            submitButton('Submit')
        ),

        # Show a plot of the variables
        mainPanel(
            tabsetPanel(type = 'tabs',
                        tabPanel('Plot',
                                 h3('3D plot of the selected variables'),
                                 plotlyOutput('plot')),
                        tabPanel('Instructions', 
                                 p('At the left panel, select the spacial variables of the
                                    Weight Lifting Exercises Dataset you want to analyse,
                                    then press the submit button. 
                                    
                                    The 3D plot will reload with the variables selected.'))
            )
            
        )
    )
))
