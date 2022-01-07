#
# This is the server logic of a Shiny web application. 
# Author: Karl Melgarejo Castillo.
# Date: January 6, 2022.
#

library(shiny)
library(stringr)

# Define server logic 
shinyServer(function(input, output) {

    freq2_110 <- read.table(file = "./freq2_110_app.txt")
    freq3_110 <- read.table(file = "./freq3_110_app.txt")
    freq4_110 <- read.table(file = "./freq4_110_app.txt")
    
    output$output <- renderText({

        req(input$input)
        l <- sapply(strsplit(input$input, " "),length)
   
    # Loop to predict the next word with 4, 3 and 2 grams model.     
        if(l > 2){
            w <- str_extract(input$input,"\\w+ \\w+ \\w+$")
            w <- tolower(w)
            w <- paste("-_-", w)
            r <- freq4_110[freq4_110$ng3 == w,]
            r$prob <- round(r$freq / sum(r$freq)*100, 2)
            ror <- order(r$freq, decreasing = TRUE)
            rf <- paste(input$input, r[ror,][1,4])
            strsplit(rf, '')[[1]]
            
            if(is.na(r[ror,][1,4]) == TRUE){
            w <- str_extract(input$input,"\\w+ \\w+$")
            w <- tolower(w)
            w <- paste("-_-", w)
            r <- freq3_110[freq3_110$ng2 == w,]
            r$prob <- round(r$freq / sum(r$freq)*100, 2)
            ror <- order(r$freq, decreasing = TRUE)
            rf <- paste(input$input, r[ror,][1,4])
            strsplit(rf, '')[[1]]
            
            if(is.na(r[ror,][1,4]) == TRUE){
                w <- str_extract(input$input,"\\w+$")
                w <- tolower(w)
                w <- paste("-_-", w)
                r <- freq2_110[freq2_110$ng1 == w,]
                r$prob <- round(r$freq / sum(r$freq)*100, 2)
                ror <- order(r$freq, decreasing = TRUE)
                rf <- paste(input$input, r[ror,][1,4])
                strsplit(rf, '')[[1]]
            } else {
                strsplit(rf, '')[[1]] 
            }
            }
            else {
                strsplit(rf, '')[[1]] 
            }
        }

        
        else if(l > 1 & l < 2) {
            w <- str_extract(input$input,"\\w+ \\w+$")
            w <- tolower(w)
            w <- paste("-_-", w)
            r <- freq3_110[freq3_110$ng2 == w,]
            r$prob <- round(r$freq / sum(r$freq)*100, 2)
            ror <- order(r$freq, decreasing = TRUE)
            rf <- paste(input$input, r[ror,][1,4])
            strsplit(rf, '')[[1]]
            
            if(is.na(r[ror,][1,4]) == TRUE){
                w <- str_extract(input$input,"\\w+$")
                w <- tolower(w)
                w <- paste("-_-", w)
                r <- freq2_110[freq2_110$ng1 == w,]
                r$prob <- round(r$freq / sum(r$freq)*100, 2)
                ror <- order(r$freq, decreasing = TRUE)
                rf <- paste(input$input, r[ror,][1,4])
                strsplit(rf, '')[[1]]
            } else {
                strsplit(rf, '')[[1]] 
            }
                
                        
        } else {
            w <- str_extract(input$input,"\\w+$")
            w <- tolower(w)
            w <- paste("-_-", w)
            r <- freq2_110[freq2_110$ng1 == w,]
            r$prob <- round(r$freq / sum(r$freq)*100, 2)
            ror <- order(r$freq, decreasing = TRUE)
            rf <- paste(input$input, r[ror,][1,4])
            strsplit(rf, '')[[1]]
        }

    })
    
    output$other <- renderTable({

        req(input$input)
        l <- sapply(strsplit(input$input, " "),length)
    
    # Loop to predict other suggestions for the next word.
        
        if(l > 2){
            w <- str_extract(input$input,"\\w+ \\w+ \\w+$")
            w <- tolower(w)
            w <- paste("-_-", w)
            r <- freq4_110[freq4_110$ng3 == w,]
            r$prob <- round(r$freq / sum(r$freq)*100, 2)
            ror <- order(r$freq, decreasing = TRUE)
            rf <- r[ror,][2:6,c(4,5)]
            names(rf) <- c("Word", "Probability (%)")
            rf
            
            if(is.na(r[ror,][1,4]) == TRUE){
                w <- str_extract(input$input,"\\w+ \\w+$")
                w <- tolower(w)
                w <- paste("-_-", w)
                r <- freq3_110[freq3_110$ng2 == w,]
                r$prob <- round(r$freq / sum(r$freq)*100, 2)
                ror <- order(r$freq, decreasing = TRUE)
                rf <- r[ror,][2:6,c(4,5)]
                names(rf) <- c("Word", "Probability (%)")
                rf
                
                if(is.na(r[ror,][1,4]) == TRUE){
                    w <- str_extract(input$input,"\\w+$")
                    w <- tolower(w)
                    w <- paste("-_-", w)
                    r <- freq2_110[freq2_110$ng1 == w,]
                    r$prob <- round(r$freq / sum(r$freq)*100, 2)
                    ror <- order(r$freq, decreasing = TRUE)
                    rf <- r[ror,][2:6,c(4,5)]
                    names(rf) <- c("Word", "Probability (%)")
                    rf
                } else {
                    rf 
                }
            }
            else {
                rf 
            }
        }
        
        
        else if(l > 1 & l < 2) {
            w <- str_extract(input$input,"\\w+ \\w+$")
            w <- tolower(w)
            w <- paste("-_-", w)
            r <- freq3_110[freq3_110$ng2 == w,]
            r$prob <- round(r$freq / sum(r$freq)*100, 2)
            ror <- order(r$freq, decreasing = TRUE)
            rf <- r[ror,][2:6,c(4,5)]
            names(rf) <- c("Word", "Probability (%)")
            rf
            
            if(is.na(r[ror,][1,4]) == TRUE){
                w <- str_extract(input$input,"\\w+$")
                w <- tolower(w)
                w <- paste("-_-", w)
                r <- freq2_110[freq2_110$ng1 == w,]
                r$prob <- round(r$freq / sum(r$freq)*100, 2)
                ror <- order(r$freq, decreasing = TRUE)
                rf <- r[ror,][2:6,c(4,5)]
                names(rf) <- c("Word", "Probability (%)")
                rf
            } else {
                rf 
            }
            
            
        } else {
            w <- str_extract(input$input,"\\w+$")
            w <- tolower(w)
            w <- paste("-_-", w)
            r <- freq2_110[freq2_110$ng1 == w,]
            r$prob <- round(r$freq / sum(r$freq)*100, 2)
            ror <- order(r$freq, decreasing = TRUE)
            rf <- r[ror,][2:6,c(4,5)]
            names(rf) <- c("Word", "Probability (%)")
            rf
        }
    })

    # Information about the author and the app
    
    output$author<- renderText({
        "Author: Karl Melgarejo Castillo."
    })
    output$date<- renderText({
        "Date: January 6, 2022."
    })
    output$present<- renderText({
        "For more detail on how this app works, read the following document:"
    })
    output$report<- renderText({
        "For more technical details, read the following document:"
    })
})
