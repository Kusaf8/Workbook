install.packages("wordcloud")
install.packages("RColorBrewer")
install.packages("wordcloud2")
install.packages("tm")
install.packages("textreadr")
install.packages("devtools")
library(wordcloud)
library(RColorBrewer)
library(tm)
library(textreadr)
library(tibble)

articles = read_document("C:\\Users\\Kevin\\Desktop\\CodePractice\\ResumeProject\\Workbook\\docs\\EvaluationWords.docx")
docs = VCorpus(VectorSource(articles))
remove(articles)
  
# Text analysis - Preprocessing 
transform.words = content_transformer(function(x, from, to) gsub(from, to, x))
temp = tm_map(docs, transform.words, "<.+?>", " ")
temp = tm_map(temp, transform.words, "\t", " ")
temp = tm_map(temp, content_transformer(tolower)) # Conversion to Lowercase
temp = tm_map(temp, PlainTextDocument)
temp = tm_map(temp, stripWhitespace)
temp = tm_map(temp, removeWords, stopwords("english"))
temp = tm_map(temp, removePunctuation)
temp = tm_map(temp, removeNumbers)
remove(docs)

# Create Dtm 
dtm = TermDocumentMatrix(temp)
matrix = as.matrix(dtm)
words = sort(rowSums(matrix),decreasing=TRUE) 
df = data.frame(word = names(words),freq=words)

set.seed(1234) # for reproducibility 
png("wordcloud_packages.png", width=12,height=8, units='in', res=300)

wc = wordcloud(words = df$word,
          freq = df$freq, 
          min.freq = 2,
          #max.words=100, 
          random.order=FALSE, 
          rot.per=0.35,
          scale=c(2,.1),
          use.r.layout=FALSE,
          colors = brewer.pal(8, "Dark2"))



wc
