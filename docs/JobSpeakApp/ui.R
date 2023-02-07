library(shiny)
library(shinyWidgets)
library(tm)
library(wordcloud)

fluidPage(
  setBackgroundColor("ghostwhite"),
  titlePanel(h2("JobSpeak: Decoding Job Descriptions", align = "Center")),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose a txt file",
                accept = c(".txt")),
      checkboxInput("stopword", "Remove Stopwords", TRUE),
      
      h5("Use this simple App to find the keywords from each job posting of interest. Simply copy the job descriptions and qualifications into a .txt file and upload it above.  This App will create a wordcloud and word frequency table of the most used important words in the posting."),
      h5("Many companies will use automated screening software to quickly review many job applications. For your resume to pass this screening, websites like indeed recommend all applicants include keywords throughout their resume. Resume keywords are words or phrases that describe your qualifications for a specific job. Keywords vary based on the job position, years of experience required, company and related factors."),
      h5("The best way to figure out likely resume keywords for a particular role is to carefully review the job posting. Look for specific words the posting uses to describe their ideal candidate's experiences or skills. If you believe you fit the job description, incorporate those exact words or phrases into your resume."), 
      h5("Integrate your keywords into the rest of your resume. Most screening programs prefer applications that do not list one keyword right after another, such as in a skills section filled with only keywords. The screening software is more likely to approve resumes that incorporate keywords into the rest of their text.")),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Wordcloud", plotOutput("wordcloud")),
                  tabPanel("Word Frequency Table", dataTableOutput("frequency"))
                  )
      )
    )
  )
