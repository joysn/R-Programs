#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)
library(tm)
library(NLP)

# Loading the collection of bigrams, trigrams and quadgrams with its frequencies
BGFreq <- readRDS("bg.RData"); 
TGFreq <- readRDS("tg.RData"); 
QGFreq <- readRDS("qg.RData")

# Get next word using BG provided the list of words from the partial sentence
predictWordBG<-function(pSplitSentence) {
    
    # Get the next word whose frequency is highest
    predictedWord<-as.character(head((BGFreq[BGFreq$word1==pSplitSentence[1],])$word2,1))
    freq<-as.character(head((BGFreq[BGFreq$word1==pSplitSentence[1],])$freq,1))
    # If null, then predict "it"
    if(identical(predictedWord,character(0))) {
        predictedWord<-"it"
        freq<-0
    }
    predictedWordwithFreq<-list(predictedWord, freq)
    return(predictedWordwithFreq)
}


# Get next word using TriGram provided the list of words from the partial sentence
predictWordTG<-function(pSplitSentence) {
    
    # Get the next word whose frequency is highest
    predictedWord<-as.character(head((TGFreq[TGFreq$word1==pSplitSentence[1] 
                                             & TGFreq$word2 == pSplitSentence[2],])$word3,1))
    
    # Get the frequency
    freq<-as.character(head((TGFreq[TGFreq$word1==pSplitSentence[1] & TGFreq$word2 == pSplitSentence[2],])$freq,1))
    
    predictedWordwithFreq<-list(predictedWord, freq)
    
    # If not found, then use BiGram
    if(identical(predictedWord,character(0))) {
        predictedWordwithFreq=predictWord(pSplitSentence[2])
    }
    return(predictedWordwithFreq)
}

# Get next word using TriGram provided the list of words from the partial sentence
predictWordQG<-function(pSplitSentence) {
    predictedWord<-as.character(head((QGFreq[QGFreq$word1==pSplitSentence[1] 
                                          & QGFreq$word2 == pSplitSentence[2]
                                          & QGFreq$word3 == pSplitSentence[3]
                                          ,])$word4,1))
    
    # Get the frequency
    freq<-as.integer(head((QGFreq[QGFreq$word1==pSplitSentence[1] 
                                   & QGFreq$word2 == pSplitSentence[2]
                                   & QGFreq$word3 == pSplitSentence[3]
                                   ,])$freq,1))
    
    predictedWordwithFreq<-list(predictedWord, freq)
    
    # If not found, use Trigram
    if(identical(predictedWord,character(0))) {
        predictedWordwithFreq=predictWord(paste(pSplitSentence[2],pSplitSentence[3],sep=" "))
    }
    return(predictedWordwithFreq)
}


# Predict the word based on the partial sentence provided
predictWord<-function(pSentence, ngrams_words=0)  {
    
    # Change to lower case and removing numbers since that is not part of the dataset
    pCleanSentence<-stripWhitespace(removeNumbers(tolower(pSentence),preserve_intra_word_dashes = TRUE))
    # Split the sentence
    pSplitSentence<- strsplit(pCleanSentence," ")[[1]]
    # Get the word count
    wordCount<-length(pSplitSentence)
    
    # If there is one word, we use Bigrams
    if(wordCount==1 || ngrams_words==2) { 
        predictedWordwithFreq<-predictWordBG(tail(pSplitSentence,1))
    }  # if itword count is 2 , we use trigram
    else if(wordCount==2 || ngrams_words==3) { 
        predictedWordwithFreq<-predictWordTG(tail(pSplitSentence,2))
    } # if word count is 3, we use quagrams
    else if(wordCount>2 || ngrams_words==3) {
        predictedWordwithFreq<-predictWordQG(tail(pSplitSentence,3))
    }
    else { # Default show "it"
        predictedWordwithFreq<-list("it",0)
    }
    return(predictedWordwithFreq)
}

shinyServer(function(input, output) {
    output$next_word<-renderPrint({
        result<-predictWord(input$partSentence,0)
        result[[1]]
        
    });
    output$bgOutput<-renderPrint({
        result<-predictWord(input$partSentence,2)
        result[[1]]
    });
    output$tgOutput<-renderPrint({
        result<-predictWord(input$partSentence,3)
        result[[1]]
    });
    output$qgOutput<-renderPrint({
        result<-predictWord(input$partSentence,4)
        result[[1]]
    });
})