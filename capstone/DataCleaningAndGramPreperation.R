suppressMessages(library(ggplot2))
suppressMessages(library(NLP))
library(tm)
library(SnowballC)
library(stringi)
library(RColorBrewer)
library(wordcloud)
library(RWeka)
library(slam)


us_blogs_file <- "./final/en_US/en_US.blogs.txt"
us_news_file  <- "final/en_US/en_US.news.txt"
us_twitter_file <-  "final/en_US/en_US.twitter.txt"

file.size(us_blogs_file)
paste0("US_blog file Size ",round(file.size(us_blogs_file)/1024/1024,2), " Mb")
file.size(us_news_file)
file.size(us_twitter_file)

fn_con=file(us_blogs_file,open="r")
lines<-readLines(fn_con)
stri_stats_general(lines)
close(fn_con)

fn_con=file(us_news_file,open="r")
lines<-readLines(fn_con)
stri_stats_general(lines)
close(fn_con)

fn_con=file(us_blogs_file,open="r")
lines<-readLines(fn_con)
stri_stats_general(lines)
close(fn_con)


SampleFile<-function(fn) {
    paste("Reading 5% sample of file ",fn)
    fn_con=file(fn,open="r")
    DataFinal<-NULL
    LineChunk=3000
    longmaxline=0;
    set.seed(1913)
    while ( TRUE ) {
         line = readLines(fn_con, n = LineChunk,skipNul=TRUE)
         if ( length(line) == 0 ) {
             break
         }
         if(sample(1:20,1)==5) {  #random 1:20==5 to select 5% of the lines
             DataFinal<-c(DataFinal,line)
         }
    }
    close(fn_con)
    return(DataFinal)
}

# Create the trim_data.txt once so that everytime it is not created
DataFinalFile="trim_data.txt"
if(!file.exists(DataFinalFile)){
    us_blogs <- SampleFile("final/en_US/en_US.blogs.txt")
    us_news  <- SampleFile("final/en_US/en_US.news.txt")
    us_twitter  <- SampleFile("final/en_US/en_US.twitter.txt")
    DataFinal=c(us_blogs,us_news, us_twitter)
    writeLines(DataFinal, "trim_data.txt")
} else {
    DataFinal<-readLines(DataFinalFile, encoding = "UTF-8", skipNul=TRUE)
}
print("General statistics Of Sampled Data")
stri_stats_general(DataFinal)


set.seed(1913)
DataSample = sample(DataFinal,5000, replace = FALSE)

#Corpus Creation
CleanData <- VCorpus(VectorSource(DataSample))

# Data Cleanup 
# - 1) Remove white space 2) Remove Punctuation 3) Lower case 4) Remove Numbers stop words and URLs and 5) Remove bad words
CleanData <- tm_map(CleanData, content_transformer(tolower))
CleanData <- tm_map(CleanData, content_transformer(removePunctuation))
CleanData <- tm_map(CleanData, stripWhitespace)
CleanData <- tm_map(CleanData, removeWords, stopwords("english"))
CleanData <- tm_map(CleanData, removeNumbers)
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
CleanData <- tm_map(CleanData,  content_transformer(removeURL))
profaneWords <- read.table("./bad-words_list.txt", header = FALSE)
CleanData <- tm_map(CleanData, removeWords, unlist(profaneWords))


final_data_cleaned <- tm_map(final_data_cleaned, content_transformer(tolower))
final_data_cleaned <- tm_map(final_data_cleaned, content_transformer(removePunctuation))
final_data_cleaned <- tm_map(final_data_cleaned, stripWhitespace)
final_data_cleaned <- tm_map(final_data_cleaned, removeWords, stopwords("english"))
#final_data_cleaned <- tm_map(final_data_cleaned, removeWords, unlist(profanityWords))
final_data_cleaned <- tm_map(final_data_cleaned, removeNumbers)
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
final_data_cleaned <- tm_map(final_data_cleaned,  content_transformer(removeURL))
#remove profanity words
profanityWords <- read.table("./full-list-of-bad-words-text-file_2018_03_26.txt", header = FALSE)
final_data_cleaned <- tm_map(final_data_cleaned, removeWords, unlist(profanityWords))



# Weka Package - Thank you. Creating 2,3 Tokens
BGTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TGTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))

#Create the Matrices - Unigram, BiGram, TriGram

DTMatrix<-DocumentTermMatrix(CleanData)
DTMatrixmatUni<-as.matrix(DTMatrix)
Ufreq<-colSums(DTMatrixmatUni)
Ufreq<-sort(Ufreq,decreasing = TRUE)

#two words (2-grams)
DTMatrixBG <- DocumentTermMatrix(CleanData, control = list(tokenize = BGTokenizer, stemming = TRUE))
DTMatrixBGMatrix<-as.matrix(DTMatrixBG)
BGFreq<-colSums(DTMatrixBGMatrix)
BGFreq<-sort(BGFreq,decreasing = TRUE)

#three words (3-grams)
DTMatrixTG <- DocumentTermMatrix(CleanData, control = list(tokenize = TGTokenizer, stemming = TRUE))
DTMatrixTGMatrix<-as.matrix(DTMatrixTG)
TGFreq<-colSums(DTMatrixTGMatrix)
TGFreq<-sort(TGFreq,decreasing = TRUE)

# World Cloud - Thank you worldcloud
words<-names(Ufreq)
wordcloud(words[1:100],Ufreq[1:100],random.order = F,random.color = F,colors = brewer.pal(9,"RdPu"))
words_bigram<-names(BGFreq)
wordcloud(words_bigram[1:100],BGFreq[1:100],random.order = F,random.color = F,          colors = brewer.pal(9,"BuGn"))
words_trigram<-names(TGFreq)
wordcloud(words_trigram[1:100],TGFreq[1:100],random.order = F,random.color = F,colors = brewer.pal(9,"OrRd"))


# Histogram
unigram_freq <- rowapply_simple_triplet_matrix(DTMatrix,sum)
bigram_freq <- rowapply_simple_triplet_matrix(DTMatrixBG,sum)
trigram_freq <- rowapply_simple_triplet_matrix(DTMatrixTG,sum)
par(mfrow = c(1,3), oma=c(0,0,3,0))
hist(unigram_freq, breaks = 50, main = 'Uni-Gram', xlab='Uni-Gram')
hist(bigram_freq, breaks = 50, main = 'Bi-Gram', xlab='Bi-Gram')
hist(trigram_freq, breaks = 50, main = 'Tri-Gram', xlab='Tri-Gram')
title("1-2-3 Gram Histogram",outer=T)




#Words in freq - needed??
length(Ufreq)
#sum of frequencies -???
freqtot<-sum(Ufreq)
#sum freq of first 200 words ???
freq150<-sum(Ufreq[1:150])
calcfreq <- function(Ufreq, i) {
    freqtot<-sum(Ufreq)
    freqtot
    freqi<-sum(Ufreq[1:i])
    ratio<-i/length(Ufreq)
    coverage<-freqi/freqtot
    cat(sprintf("Tot words: %d Analized (top frequency) %d words Ratio=%.2f Coverage %.2f\n",length(Ufreq),i,ratio,coverage))
}    
for (i in seq(100,1000,100)) {
    calcfreq(Ufreq,i) 
}



# 30 most frequent 1-2-3 gram words
num <- 30
UDf <- head(data.frame(terms=names(Ufreq), freq=Ufreq),n=num) 
BGDf <- head(data.frame(terms=names(BGFreq), freq=BGFreq),n=num)
TGDf <- head(data.frame(terms=names(TGFreq), freq=TGFreq),n=num)
plot_unigram  <-ggplot(UDf,aes(terms,freq))   
plot_unigram  <- plot_unigram  + geom_bar(fill="white",colour=UDf$freq,stat="identity") + scale_x_discrete(limits=UDf$terms)
plot_unigram  <- plot_unigram  + theme(axis.text.x=element_text(angle=45, hjust=1))  
plot_unigram  <- plot_unigram  + labs(x = "Words", y="Frequency", title="30 most frequent 1-gram Words")
plot_unigram  
plot_bigram <-ggplot(BGDf,aes(terms, freq))   
plot_bigram <-plot_bigram + geom_bar(fill="white", colour=BGDf$freq,stat="identity") + scale_x_discrete(limits=BGDf$terms)
plot_bigram <- plot_bigram + theme(axis.text.x=element_text(angle=45, hjust=1))  
plot_bigram<- plot_bigram+ labs(x = "Words", y="Frequency", title="30 most frequent 2-gram words")
plot_bigram
plot_trigram <-ggplot(TGDf,aes(terms, freq))   
plot_trigram <- plot_trigram + geom_bar(fill="white",colour=TGDf$freq,stat="identity") + scale_x_discrete(limits=TGDf$terms)
plot_trigram <- plot_trigram + theme(axis.text.x=element_text(angle=45, hjust=1))  
plot_trigram <- plot_trigram + labs(x = "Words", y="Frequency", title="30 most frequent 3-gram words")
plot_trigram


