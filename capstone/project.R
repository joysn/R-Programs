my_path <- getwd()
remote_url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
downloaded_zip_file = "Coursera-SwiftKey.zip"
download.file(remote_url, file.path(my_path, downloaded_zip_file))
unzip(zipfile = downloaded_zip_file)



con <- file(".\\final\\en_US\\en_US.twitter.txt", "r") 
lineTwitter<-readLines(con)
length(lineTwitter)
readLines(con, 1) ## Read the first line of text 
readLines(con, 1) ## Read the next line of text 
readLines(con, 5) ## Read in the next 5 lines of text 
# 
# while(isIncomplete(con)) {
#     Sys.sleep(1)
#     z <- readLines(con2)
#     if(length(z)) print(z)
# }
# close(con2)

file.size(".\\final\\en_US\\en_US.blogs.txt")

close(con) ## It's important to close the connection when you are done

# Quiz 1
# 1. The en_US.blogs.txt  file is how many megabytes?
file.size(".\\final\\en_US\\en_US.blogs.txt")
# 210160014

# 2. The en_US.twitter.txt has how many lines of text?
con <- file(".\\final\\en_US\\en_US.twitter.txt", "r") 
lineTwitter<-readLines(con)
length(lineTwitter)
# 2360148
close(con) 


# 3. What is the length of the longest line seen in any of the three en_US data sets?

# Step: Read in the lines to arrays:
# Twitter data
con <- file(".\\final\\en_US\\en_US.twitter.txt", "r") 
longTwitter<-length(lineTwitter)
close(con)

# Blog data
con <- file(".\\final\\en_US\\en_US.blogs.txt", "r")
lineBlogs<-readLines(con) 
close(con)

# News data
con <- file(".\\final\\en_US\\en_US.news.txt", "r")
lineNews<-readLines(con) 
close(con)

# Need the longest line in each array.
require(stringi)
longBlogs<-stri_length(lineBlogs)
max(longBlogs)
# [1] 40835

#Apparently below is max of lineNews
longNews<-stri_length(lineNews)
max(longNews)
# [1] 5760

# Apparently below is max of lineTwitter
longTwitter<-stri_length(lineTwitter)
max(longTwitter)
# [1] 213



# 4. In the en_US twitter data set, if you divide the number of lines where the word "love" (all lowercase) occurs 
# by the number of lines the word "hate" (all lowercase) occurs, about what do you get?

loveTwitter<-grep("love",lineTwitter)
length(loveTwitter)
# [1] 90956
hateTwitter<-grep("hate",lineTwitter)
length(hateTwitter)
# [1] 22138
length(loveTwitter)/length(hateTwitter)
# [1] 4.108592

# 5. The one tweet in the en_US twitter data set that matches the word "biostats" says what?
biostatsTwitter<-grep("biostats",lineTwitter)
lineTwitter[biostatsTwitter]
# [1] "i know how you feel.. i have biostats on tuesday and i have yet to study =/"

# 6. How many tweets have the exact characters "A computer once beat me at chess, but it was no match for me at kickboxing". (I.e. the line matches those characters exactly.)
sentenceTwitter<-grep("A computer once beat me at chess, but it was no match for me at kickboxing",lineTwitter)
length(sentenceTwitter)
# [1] 3


## Sampling
# sampleFile <- ".\\final\\en_US\\en_US.twitter.txt.sample"
# metaFile <- ".\\final\\en_US\\en_US.twitter.sample.meta.txt"

sampleFile <- function(filePath, sampleFactor=0.1, recreate=FALSE){
    
    sampleFile <- paste0(filePath,".sample")
    metaFile <- paste0(filePath,".meta")
    
    locale <- gsub(".*([a-z]{2}_[A-Z]{2}).*", "\\1",filePath)
    
    if(file.exists(sampleFile) && file.exists(metaFile) && !recreate) {
        print(paste0("Already exists ",sampleFile, " and ",metaFile))
        load(metaFile)
        sampleLines <- readLines(sampleFile)
    }
    else{
        con <- file(filePath, "r") 
        OrigLines<-readLines(con)
        close(con)
        
        OrigLinesLength <- nchar(OrigLines)
        OrigLinesLengthSummary <- summary(OrigLinesLength)
        OrgLinesCount <- length(OrigLines)
        
        
        sampleLines <- OrigLines[rbinom(OrgLinesCount, 1,  sampleFactor)==1]
        writeLines(sampleLines, sampleFile)
        sampleLinesCount <- length(sampleLines)
    
        save(OrigLinesLength, OrigLinesLengthSummary, OrgLinesCount, file=metaFile)
    }
    
    retData <- list(sample.data=sampleLines, 
                    org.lines.length=OrigLinesLength,
                    org.lines.summary=OrigLinesLengthSummary,
                    org.lines.count=OrgLinesCount, 
                    org.file.path=filePath, 
                    sample.file.path=sampleFile, 
                    sample.meta.file.path=metaFile,
                    locale=locale)
    
    return(retData)
     
}

filename <- ".\\final\\en_US\\en_US.twitter.txt"
sampleFactor = 0.15
twitter <- sampleFile(filename,sampleFactor)
twitter$org.lines.summary
twitter$org.file.path
twitter$locale
twitter$org.lines.count




tokenize <- function(dataset, flatten=FALSE){
    dataset <- unlist(strsplit(dataset, "[\\.\\,!\\?\\:]+"))
    dataset <- tolower(dataset)
    dataset <- gsub("[^a-z'\\s]", " ", dataset)
    dataset <- gsub("\\s+", " ", dataset)
    dataset <- trimws(dataset)
    dataset <- strsplit(dataset, "\\s")
    if(!flatten){
        return(dataset)
    }else{
        terms <- unlist(dataset)
        indexes <- which(terms == "")
        if(length(terms) > 0){
            terms <- terms[-indexes]
        } 
        return(terms)
    }
}

twitterENTokenized <- tokenize(twitter$sample.data)


createNgram <- function(givenLine, ngram=2){
    lengthOfLine <- length(givenLine) 
    if(lengthOfLine < ngram){
        return(c())
    }else if(lengthOfLine == ngram){
        return(paste(givenLine, collapse=" "))
    }else{
        numNgrams <- lengthOfLine-ngram+1
        mtrx <- matrix(nrow=numNgrams, ncol=ngram)
        for(i in 1:ngram){
            m <- lengthOfLine - ngram + i
            mtrx[,i] <- givenLine[i:m]
        }
        ngrams <- apply(mtrx, 1, paste, collapse=" ")
        return(ngrams)
    }
} 

transformNGram <- function(termList, ngram=2){
    if(ngram <= 1) unlist(termList)
    else unlist(lapply(termList, createNgram, ngram=ngram))
}

twitterENBiGrams <- transformNGram(twitterENTokenized, 2)



#twitterENTermFrequency <- frequencyTable(twitterENTokenized)




library(tm)
corpus <- VCorpus(VectorSource(twitter$sample.data))
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)
unicorpus <- tm_map(corpus, removeWords, stopwords("en"))


library(RWeka)

# getFreq <- function(tdm) {
#     freq <- sort(rowSums(as.matrix(tdm)), decreasing = TRUE)
#     return(data.frame(word = names(freq), freq = freq))
# }
# 
# freq1 <- getFreq(removeSparseTerms(TermDocumentMatrix(unicorpus), 0.999))
# save(freq1, file="nfreq.f1.RData")

# Prepare n-gram frequencies
library(slam)
getFreq <- function(tdm) {
    freq <- sort(rowSums(as.matrix(rollup(tdm, 2, FUN = sum)), na.rm = T), decreasing = TRUE)
    return(data.frame(word = names(freq), freq = freq))
}
# freq1_new <- getFreq(removeSparseTerms(TermDocumentMatrix(unicorpus), 0.999))
# save(freq1_new, file="nfreq_new.f1.RData")

bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
quadgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
pentagram <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
hexagram <- function(x) NGramTokenizer(x, Weka_control(min = 6, max = 6))


freq1 <- getFreq(removeSparseTerms(TermDocumentMatrix(unicorpus), 0.999))
save(freq1, file="nfreq.f1.RData")
freq2 <- getFreq(TermDocumentMatrix(unicorpus, control = list(tokenize = bigram, bounds = list(global = c(5, Inf)))))
save(freq2, file="nfreq.f2.RData")
freq3 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = trigram, bounds = list(global = c(3, Inf)))))
save(freq3, file="nfreq.f3.RData")
freq4 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = quadgram, bounds = list(global = c(2, Inf)))))
save(freq4, file="nfreq.f4.RData")
freq5 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = pentagram, bounds = list(global = c(2, Inf)))))
save(freq5, file="nfreq.f5.RData")
freq6 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = hexagram, bounds = list(global = c(2, Inf)))))
save(freq6, file="nfreq.f6.RData")
nf <- list("f1" = freq1, "f2" = freq2, "f3" = freq3, "f4" = freq4, "f5" = freq5, "f6" = freq6)
save(nf, file="nfreq.v5.RData")
