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
#ud_model <- udpipe_download_model(language = "english", model_dir = "~/udpipe_models")
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

export_to_excel <- function(data, file_name) {
  df <- data.frame(Words = data, English = sapply(data, translate_word))
  write.xlsx(df, file_name, row.names = FALSE)
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
    req(input$file)
    
    text <- tolower(readLines(input$file$datapath, warn = FALSE))
    text <- tolower(paste(text, collapse = " "))
    
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
})
