library(shiny)

shinyUI(fluidPage(
  titlePanel("Russian Cyrillic Text Processing App"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose a text file"),
      actionButton("processButton", "Process Text"),
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
