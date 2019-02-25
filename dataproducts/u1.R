library(shiny)

# Define UI for application that draws a histogram
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("my first app"),
#   
#   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
#     sidebarPanel(
#        sliderInput("bins",
#                    "Number of bins:",
#                    min = 1,
#                    max = 50,
#                    value = 30)
#     ),
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#        plotOutput("distPlot")
#     )
#   )
# ))


## Simple Slider Example
library(shiny)
# shinyUI(fluidPage(
#     titlePanel("Slider App"),
#     sidebarLayout(
#         sidebarPanel(
#             h1("Move the Slider!"),
#             sliderInput("slider", "Slide Me!", 0, 100, 0)
#         ),
#         mainPanel(
#             h3("Slider Value:"),
#             textOutput("text")
#         )
#     )
# ))


## Slider + Graph
library(shiny)
# shinyUI(fluidPage(
#     titlePanel("Plot Random Numbers"),
#     sidebarLayout(
#         sidebarPanel(
#             numericInput("numeric", "How Many Random Numbers Should be plotted?"
#                          , value = 1000, min = 1, max = 1000, step = 1),
#             sliderInput("sliderX", "Pick Minimum and Maximum X Values"
#                         ,-100, 100, value = c(-50, 50)),
#             sliderInput("sliderY", "Pick Minimum and Maximum Y Values"
#                         ,-100, 100, value = c(-50, 50)),
#             checkboxInput("show_xlab", "Show/Hide X Axis Label", value = TRUE),
#             checkboxInput("show_ylab", "Show/Hide Y Axis Label", value=TRUE),
#             checkboxInput("show_title", "Show/Hide Title")
#         ),
#         mainPanel(
#             h3("Graph of Random Points"),
#             plotOutput("plot1")
#         )
#     )
# ))


library(shiny)
# shinyUI(fluidPage(
#     titlePanel("Predict Horsepower from MPG"),
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("sliderMPG", "What is the MPG of the car?", 10, 35, value = 20),
#             checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
#             checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
#             submitButton("Submit") # New!
#         ),
#         mainPanel(
#             plotOutput("plot1"),
#             h3("Predicted Horsepower from Model 1:"),
#             textOutput("pred1"),
#             h3("Predicted Horsepower from Model 2:"),
#             textOutput("pred2")
#         )
#     )
# ))


# Tab
# library(shiny)
# shinyUI(fluidPage(
#     titlePanel("Tabs!"),
#     sidebarLayout(
#         sidebarPanel(
#             textInput("box1", "Enter Tab 1 Text:", value = "Tab 1!"),
#             textInput("box2", "Enter Tab 2 Text:", value = "Tab 2!"),
#             textInput("box3", "Enter Tab 3 Text:", value = "Tab 3!")
#         ),
#         mainPanel(
#             tabsetPanel(type = "tabs",
#                         tabPanel("Tab 1", br(), textOutput("out1")),
#                         tabPanel("Tab 2", br(), textOutput("out2")),
#                         tabPanel("Tab 2", br(), textOutput("out3"))
#             )
#         )
#     )
# ))


# Interactive