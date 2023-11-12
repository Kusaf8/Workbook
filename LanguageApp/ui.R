library(shiny)

shinyUI(fluidPage(
  titlePanel("Russian Cyrillic Text Processing App"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput("textInput", "Enter Text", "", width = "400px", height = "400px"),
      actionButton("processButton", "Process Text"),
      downloadButton("downloadData", "Download"),
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Verbs", tableOutput("verbsTable")),
        tabPanel("Nouns", tableOutput("nounsTable")),
        tabPanel("Prepositions", tableOutput("prepositionsTable")),
        tabPanel("Adjectives", tableOutput("adjectivesTable")),
        tabPanel("Adverbs", tableOutput("adverbsTable")),
        )
      )
    )
  )
)
