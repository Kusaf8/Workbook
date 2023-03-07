library(shiny)
library(shinyWidgets)
library(tm)
library(tibble)
library(dplyr)
library(textreadr)
library(wordcloud)
library(RCurl)
library(XML)

Gettysburg_Address = "Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in liberty, and dedicated to the proposition that all men are created equal.Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battlefield of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But in a larger sense, we cannot dedicate - we cannot consecrate - we cannot hallow - this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember, what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us - that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion - that we here highly resolve that these dead shall not have died in vain - that this nation, under God, shall have a new birth of freedom - and that government of the people, by the people, for the people, shall not perish from the earth."

function(input, output) {
  data = reactive({
    
    if (input$source == "Example") {
      data_source = Gettysburg_Address
    } 

    else if (input$source == "file") {
      if (is.null(input$file)) {
        return(NULL)
        }  
        else {
          data_source = read_document(input$file$datapath)
          }
        }
    
    else if (input$source == "link") {
      if (nchar(input$link) < 5) {
        return(NULL)
        }
        else {
          data_source = read_document(input$link)
        }
      }
 
    #text = read_document(inFile$datapath)
    temp = VCorpus(VectorSource(data_source))
    temp = tm_map(temp, removePunctuation)
    temp = tm_map(temp, removeNumbers)
    temp = tm_map(temp, removeWords, stopwords("english"))
    temp = tm_map(temp, stripWhitespace)
    dtm = TermDocumentMatrix(temp)
    matrix = as.matrix(dtm)
    words = sort(rowSums(matrix),decreasing=TRUE) 
    df = data.frame(word=names(words), freq=words)
    return(df)
    })
  
  set.seed(1234) # for reproducibility 
  png("wordcloud_packages.png", width=20,height=20, units='in', res=300)
  dev.off()
  
  output$wordcloud = renderPlot({
    if (is.null(data())) return()
    wordcloud(data()$word,
              data()$freq,
              scale=c(3,.5), 
              min.freq=2,
              max.words=100, 
              random.order=FALSE, 
              rot.per=0.35, 
              use.r.layout=FALSE, 
              colors=brewer.pal(8, "Dark2"))
  })
  
  output$frequency = renderDataTable({
    if (is.null(data())) return()
    return(head(data(), n = 100))
    })
}