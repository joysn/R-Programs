#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(png)
suppressWarnings(library(markdown))

shinyUI(fluidPage(
    
    # Application title
    
    titlePanel("Prediction of the next word in a partial sentence"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            helpText("Enter a partial sentence to check the next guessed word"),
            h5("Example type  \"How are\" and see the result Or type  \"Have a\" and see the output"),
            hr(),
            textInput("partSentence", "Sentence:",value = ""),
            br(),
            h5('Instructions'),
            helpText("This application is used for predicting the next word while writing a sentence"),
            helpText("This is based on the frequency of words in bigrams, triagrams and quagrams - combination of 2, 3 and 4 words appearing together."),
            helpText("If no words are entered, it will display the predicted word as \"it\""),
            helpText("The dataset which is used to collect these combinations of words are provided by Swiftkey"),
            helpText("The dataset contains collections of News articles, Tweets and Blogs. Only English data is considered for this project")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h1("Predicted Next Word"),
            verbatimTextOutput("Guessing..."),
            h3(strong(code(textOutput('next_word')))),
            br(),
            br(),
            br(),
            h4(tags$b('Predicted Word using Bigrams:')),
            textOutput('bgOutput'),
            br(),
            h4(tags$b('Predicted Word using Trigrams:')),
            textOutput('tgOutput'),
            br(),
            h4(tags$b('Predicted Word using Quagrams:')),
            textOutput('qgOutput'),
            br(),
            br(),
            br(),
            br(),
            h4(),
            tags$b("Data Science Capstone Project"),
            br(),
            tags$b("Author: Sudipto Nandan"),
            helpText("Data Source :- https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"),
            h4("Thank you John Hopkins University, SwiftKey, Coursera")
        )
    )
))