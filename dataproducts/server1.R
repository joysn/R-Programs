# Define server logic required to draw a histogram
# shinyServer(function(input, output) {
#    
#   output$distPlot <- renderPlot({
#     
#     # generate bins based on input$bins from ui.R
#     x    <- faithful[, 2] 
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)
#     
#     # draw the histogram with the specified number of bins
#     hist(x, breaks = bins, col = 'darkgray', border = 'white')
#     
#   })
#   
# })


## Simple Slider Example
# library(shiny)
# shinyServer(function(input, output) {
#     output$text <- renderText(input$slider)
# })



## Slider + Graph
library(shiny)
# shinyServer(function(input, output) {
#     output$plot1 <- renderPlot({
#         set.seed(2016-05-25)
#         number_of_points <- input$numeric
#         minX <- input$sliderX[1]
#         maxX <- input$sliderX[2]
#         minY <- input$sliderY[1]
#         maxY <- input$sliderY[2]
#         dataX <- runif(number_of_points, minX, maxX)
#         dataY <- runif(number_of_points, minY, maxY)
#         xlab <- ifelse(input$show_xlab, "X Axis", "")
#         ylab <- ifelse(input$show_ylab, "Y Axis", "")
#         main <- ifelse(input$show_title, "Title", "")
#         plot(dataX, dataY, xlab = xlab, ylab = ylab, main = main,
#              xlim = c(-100, 100), ylim = c(-100, 100))
#     })
# })


# library(shiny)
# shinyServer(function(input, output) {
#     mtcars$mpgsp <- ifelse(mtcars$mpg - 20 > 0, mtcars$mpg - 20, 0)
#     model1 <- lm(hp ~ mpg, data = mtcars)
#     model2 <- lm(hp ~ mpgsp + mpg, data = mtcars)
#     model1pred <- reactive({
#         mpgInput <- input$sliderMPG
#         predict(model1, newdata = data.frame(mpg = mpgInput))
#     })
#     model2pred <- reactive({
#         mpgInput <- input$sliderMPG
#         predict(model2, newdata =
#                     data.frame(mpg = mpgInput,
#                                mpgsp = ifelse(mpgInput - 20 > 0,
#                                               mpgInput - 20, 0)))
#     })
#     output$plot1 <- renderPlot({
#         mpgInput <- input$sliderMPG
#         plot(mtcars$mpg, mtcars$hp, xlab = "Miles Per Gallon",
#              ylab = "Horsepower", bty = "n", pch = 16,
#              xlim = c(10, 35), ylim = c(50, 350))
#         if(input$showModel1){
#             abline(model1, col = "red", lwd = 2)
#         }
#         if(input$showModel2){
#             model2lines <- predict(model2, newdata = data.frame(
#                  mpg = 10:35, mpgsp = ifelse(10:35 - 20 > 0, 10:35 - 20, 0)
#             ))
#             lines(10:35, model2lines, col = "blue", lwd = 2)
#             #abline(10:35,model2lines, col = "blue", lwd = 2)
#         }
#         legend(25, 250, c("Model 1 Prediction", "Model 2 Prediction"), pch = 16,
#                col = c("red", "blue"), bty = "n", cex = 1.2)
#         points(mpgInput, model1pred(), col = "red", pch = 16, cex = 2)
#         points(mpgInput, model2pred(), col = "blue", pch = 16, cex = 2)
#     })
#     output$pred1 <- renderText({
#         model1pred()
#     })
#     output$pred2 <- renderText({
#         model2pred()
#     })
# })


## Tab
# library(shiny)
# shinyServer(function(input, output) {
#     output$out1 <- renderText(input$box1)
#     output$out2 <- renderText(input$box2)
#     output$out3 <- renderText(input$box3)
# })


# Interactive Graphics
library(shiny)
# shinyServer(function(input, output) {
#     model <- reactive({
#         set.seed(13019)
#         brushed_data <- trees[sample(nrow(trees), input$sliderNoOfData), ]
#         if(nrow(brushed_data) < 2){
#             return(NULL)
#         }
#         lm(Volume ~ Girth, data = brushed_data)
#     })
#     output$slopeOut <- renderText({
#         if(is.null(model())){
#             "No Model Found"
#         } else {
#             model()[[1]][2]
#         }
#     })
#     output$intOut <- renderText({
#         if(is.null(model())){
#             "No Model Found"
#         } else {
#             model()[[1]][1]
#         }
#     })
#     output$plot1 <- renderPlot({
#         plot(trees$Girth, trees$Volume, xlab = "Girth",
#              ylab = "Volume", main = "Tree Measurements",
#              cex = 1.5, pch = 19, bty = "n")
#         set.seed(13019)
#         brushed_data <- trees[sample(nrow(trees), input$sliderNoOfData), ]
#         points.default(brushed_data$Girth, y=brushed_data$Volume, type="p", pch=4, col="red",cex=4)
#         if(!is.null(model())){
#             abline(model(), col = "blue", lwd = 2)
#         }
#     })
# })




# shinyServer(function(input, output) {
#     model <- reactive({
#         set.seed(13019)
#         brushed_data <- mtcars[sample(nrow(mtcars), input$sliderNoOfData), ]
#         if(nrow(brushed_data) < 2){
#             return(NULL)
#         }
#         lm(mpg ~ wt, data = brushed_data)
#     })
#     output$slopeOut <- renderText({
#         if(is.null(model())){
#             "No Model Found"
#         } else {
#             model()[[1]][2]
#         }
#     })
#     output$intOut <- renderText({
#         if(is.null(model())){
#             "No Model Found"
#         } else {
#             model()[[1]][1]
#         }
#     })
#     output$plot1 <- renderPlot({
#         plot(mtcars$wt, mtcars$mpg, xlab = "wt",
#              ylab = "mpg", main = "Tree Measurements",
#              cex = 1.5, pch = 19, bty = "n")
#         set.seed(13019)
#         brushed_data <- mtcars[sample(nrow(mtcars), input$sliderNoOfData), ]
#         points.default(brushed_data$wt, y=brushed_data$mpg, type="p", pch=4, col="red",cex=4)
#         if(!is.null(model())){
#             abline(model(), col = "blue", lwd = 2)
#         }
#     })
# })

