# server.R

library(shiny)
library(openxlsx)
library(tm)

if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}
if (!requireNamespace("openxlsx", quietly = TRUE)) {
  install.packages("openxlsx")
}
if (!requireNamespace("udpipe", quietly = TRUE)) {
  install.packages("udpipe")
}

library(shiny)
library(openxlsx)
library(udpipe)

# Download English model if not already downloaded
ud_model <- udpipe_download_model(language = "russian", model_dir = "~/udpipe_models")

# Load English model
ud_model <- udpipe_load_model(ud_model$file_model)

# Tokenize and tag part of speech
process_text <- function(text) {
  x <- udpipe_annotate(ud_model, x = text)
  x <- as.data.frame(x)
  
  # Extract verbs, nouns, prepositions, and adjectives
  verbs <- x$lemma[x$upos %in% c("VERB")]
  nouns <- x$lemma[x$upos %in% c("NOUN")]
  prepositions <- x$lemma[x$upos %in% c("ADP")]
  adjectives <- x$lemma[x$upos %in% c("ADJ")]
  adverbs <- x$lemma[x$upos %in% c("ADV")]
  
  return(list(verbs = verbs, nouns = nouns, prepositions = prepositions, adjectives = adjectives, adverbs = adverbs))
}

shinyServer(function(input, output) {
  data <- reactiveValues(
    verbs = NULL,
    nouns = NULL,
    prepositions = NULL,
    adjectives = NULL,
    adverbs = NULL
  )
  
  observeEvent(input$processButton, {
    req(input$textInput)
    
    #text <- tolower(readLines(input$file$datapath, warn = FALSE))
    #text <- tolower(readLines(input$textInput, warn = FALSE))
    
    text <- tolower(paste(input$textInput, collapse = " "))
    
    result <- process_text(text)
    data$verbs <- result$verbs
    data$nouns <- result$nouns
    data$prepositions <- result$prepositions
    data$adjectives <- result$adjectives
    data$adverbs <- result$adverbs
   })
  
  output$verbsTable <- renderTable({data$verbs})
  output$nounsTable <- renderTable({data$nouns})
  output$prepositionsTable <- renderTable({data$prepositions})
  output$adjectivesTable <- renderTable({data$adjectives})
  output$adverbsTable <- renderTable({data$adverbs})
  
  observeEvent(input$downloadData, {
    wb <- createWorkbook()
    addWorksheet(wb, "Verbs")
    addWorksheet(wb, "Nouns")
    addWorksheet(wb, "Prepositions")
    addWorksheet(wb, "Adjectives")
    addWorksheet(wb, "Adverbs")
    
    writeData(wb, sheet = 1, x = result$verbs, startCol = 1, startRow = 1)
    writeData(wb, sheet = 2, x = result$nouns, startCol = 1, startRow = 1)
    writeData(wb, sheet = 3, x = result$prepositions, startCol = 1, startRow = 1)
    writeData(wb, sheet = 4, x = result$adjectives, startCol = 1, startRow = 1)
    writeData(wb, sheet = 5, x = result$adverbs, startCol = 1, startRow = 1)
  })
})
