library(revealjs)

revealjs::revealjs_presentation(title = "Hello World", theme = "black", highlight = "atom-one-light")

slide("Hello World", type = "title")

slide("Hello World", type = "subtitle")

slide("This is a sample presentation using Reveal.js in RStudio.", type = "fragment")

slide("This is a simple example of how to create a slide show using the Reveal.js library in R.", type = "fragment")

slide("Thank you for using Reveal.js in RStudio!", type = "fragment")

revealjs::revealjs_presentation_end()

