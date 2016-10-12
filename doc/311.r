library(wordcloud)
library(RColorBrewer)
library(scales)

word_fre <- read.csv("file:///C:/Users/Owner/Google Drive/2016 fall/Applied Data Science/data sets/freq.csv", header=F)
pal <- brewer.pal(8, "Dark2")
wordcloud(word_fre$V1, word_fre$V2, scale = c(8, 0.2), min.freq = 3, 
          max.words = Inf, random.order = F, rot.per = 0.15, colors = pal)