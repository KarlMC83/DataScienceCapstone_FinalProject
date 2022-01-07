#
# This is the user-interface definition of a Shiny web application.
# Author: Karl Melgarejo Castillo.
# Date: January 6, 2022.
#

library(shiny)

# Define UI for application 
shinyUI(fluidPage(

    # Application title
    titlePanel("'Next Word' Prediction Algorithm"),
    
    # Documentation about the APP              
    fluidRow(includeText("Documentation.txt")),
    fluidRow(includeText("Documentation1.txt")),
    fluidRow(includeText("Documentation2.txt")),
    fluidRow(includeText("Documentation3.txt")),
    fluidRow(includeText("Documentation4.txt")),

    # Text box
    textInput('input', 'Enter text:'),
    
    mainPanel(
        h5("Predicted Sentence:"),
        verbatimTextOutput('output'),
    ),
    
    checkboxInput(inputId = "other", label = strong("Other 'Next Word' suggestions:"), value = FALSE),
    
    # Display only if 'other' is checked
    conditionalPanel(condition = "input.other == true",
                     tableOutput("other")
    ),
    
    mainPanel(
        textOutput(outputId = "author"),
        textOutput(outputId = "date"),
        textOutput(outputId = "present"),
        tags$a(href = "https://rpubs.com/Karl83/853684", "Presentation.", target = "_blank"),
        textOutput(outputId = "report"),
        tags$a(href = "https://rpubs.com/Karl83/853680", "Technical Report.", target = "_blank")

    )
    
    
    )

)