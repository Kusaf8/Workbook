library(shiny)
library(shinyWidgets)
library(tm)
library(wordcloud)

function(input, output){
  data = reactive({
    inFile = input$file
    if (is.null(inFile)) return(NULL)
    text = readLines(inFile$datapath)
    text = paste(text, collapse = " ")
    textCorpus = Corpus(VectorSource(text))
    textCorpus = tm_map(textCorpus, tolower)
    textCorpus = tm_map(textCorpus, removePunctuation)
    if (input$stopword) {
      textCorpus = tm_map(textCorpus, removeWords, stopwords("english"))
    }
    textCorpus = tm_map(textCorpus, stripWhitespace)
    return(textCorpus)
  })
  set.seed(1234) # for reproducibility 
  png("wordcloud_packages.png", width=12,height=10, units='in', res=300)
  dev.off()
  
  output$wordcloud = renderPlot({
    if (is.null(data())) return()
    wordcloud(data(), 
              scale=c(5,.5), 
              min.freq=2,
              max.words=100, 
              random.order=FALSE, 
              rot.per=0.35, 
              use.r.layout=FALSE, 
              colors=brewer.pal(8, "Dark2"))
  })
  
  output$frequency = renderDataTable({
    if (is.null(data())) return()
    d = DocumentTermMatrix(data())
    freq = colSums(as.matrix(d))
    freq = sort(freq, decreasing = TRUE)
    words = names(freq)
    freq_table = data.frame(word = words, frequency = freq)
    return(head(freq_table, n = 100))
  })
  }

