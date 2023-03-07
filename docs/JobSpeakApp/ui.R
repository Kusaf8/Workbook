library(shiny)
library(shinyWidgets)
library(tm)
library(wordcloud)

fluidPage(
  setBackgroundColor("ghostwhite"),
  titlePanel(h2("JobSpeak: Decoding Job Descriptions", align = "Center")),
  tabsetPanel(
    tabPanel(
      title = "Input Panel",
      sidebarLayout(
        sidebarPanel(
          radioButtons(
            inputId = "source",
            label = "Job Description Source",
            choices = c(
              "Example - [The Gettysburg Address]" = "Example",
              "Copy and Paste Link to Job Description" = "link",
              "Upload Your file" = "file")),
          
        hr(),
        conditionalPanel(
          h5("Copy and paste link into the below box."),
          condition = "input.source == 'link'",
          textInput("link", "Enter website URL", "")),

        conditionalPanel(
          h5("When selecting a file, make sure to upload a .pdf, .txt, .rtf, .docx, or .doc file."),
          condition = "input.source == 'file'",
          fileInput("file", "Select a file", 
                    accept = c(".pdf", ".txt", ".rtf", ".docx",
                               ".doc","text/csv", 
                               "text/comma-separated-values,text/plain", ".csv"))
          ),
        ),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Wordcloud", plotOutput("wordcloud")),
                      tabPanel("Word Frequency Table", dataTableOutput("frequency"))
                      )
          )
      )
    ),
    # Create an "About this app" tab
    tabPanel(
      title = "About this app",
      br(),
      HTML("<ul><li>Use this simple App to find the keywords from each interested job posting. Copy and paste the link to the job posting or upload a document as a file into the search bar. This App will create a wordcloud and word frequency table of the most frequently used words in the posting. </li>"),
      br(),
        HTML("<li>Many companies will use automated screening software to quickly review many job applications. For your resume to pass this screening, websites like indeed recommend all applicants include keywords throughout their resume. Resume keywords are words or phrases that describe your qualifications for a specific job. Keywords vary based on the job position, years of experience required, company and related factors. </li>"),
      br(),
        HTML("<li>The best way to figure out likely resume keywords for a particular role is to carefully review the job posting. Look for specific words the posting uses to describe their ideal candidate's experiences or skills. If you believe you fit the job description, incorporate those words or phrases into your resume. Ensure you adjust the language of your resume to strategically include these key words. </li>"),
      br(),  
        HTML("<li>Integrate your keywords into the rest of your resume. Most screening programs prefer applications that do not list one keyword right after another, such as in a skills section filled with only keywords. The screening software is more likely to approve resumes that incorporate keywords into the rest of their text.</li>"),
      br(),  
      HTML("<li>CAUTION: Do not load the keywords into your resume using meta tags, visible content, or backlink anchor text in an attempt to gain an unfair rank advantage in search engines. This is known as keyword stuffing and most resume screening software tools will identify this and flag your resume. </li></ul>"),
      
      )
    )
  )