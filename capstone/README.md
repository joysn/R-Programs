# predictNextWord


## Introduction
This is application developed as a part of capstone project for Data Science Specialization
The main aim of this application is to predict the next word in a partial sentence. The application need to CPU and memory efficient so that it can be executed in all devices


The data used to develop this Application has been provided by Swiftkey
https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip

## The Model

From the given dataset , we generate all combination of 
- bigrams- 2 word combination
- Trigrams - 3 word combination
- Quagrams - 4 word comonination

This matrix with the frequency of each combination is used to predict the next word in a sentence.
If we fail to predict using N gram, we move to N-1 gram.

The word "it" is used in case we could not predict any word

## Performance

The whole takes around 20 minutes to load, clean and capture the data.
The data set consists of 3 files - from News articles (~200MB,80K lines), Blogs (~200MB,900K lines) and Tweets (~150Mb,900K lines).
we randomly choosen 50000 such lines from these files and create the bigram, trigrams and quagrams

The application take less than 0.5 seconds to predict the next word

The total size is close to 3.5Mb

## Code and Application
The shiny application is available at

The source code is available at
https://github.com/joysn/R-Programs/tree/master/capstone

Thank you for reviewing this project
