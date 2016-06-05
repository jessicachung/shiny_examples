############################################################
## N-gram Babbler
############################################################

# Inspired by King James Programming 
#   http://kingjamesprogramming.tumblr.com/
# and Modern Applied Statistics in R'lyeh
#   http://librestats.com/2014/07/01/modern-applied-statistics-in-rlyeh/

library(shiny)
library(ngram)

book_list <- list("Book 1" = 1,
                  "Book 2" = 2,
                  "Book 3" = 3)

############################################################
## UI

ui <- fluidPage(
  titlePanel("N-gram Babbler"),
  
  sidebarLayout(
    sidebarPanel(
      # Text 1
      selectInput("text_1", 
                  label="First text:",
                  choices=book_list,
                  selected=1),
      
      # Text 2
      selectInput("text_2", 
                  label="Second text:",
                  choices=book_list,
                  selected=2),
      
      # Babble length
      numericInput("n",
                   label="Babble length:",
                   value=50,
                   min=1,
                   max=1000),
      
      # Set seed
      checkboxInput("set_seed",
                    label="Set seed",
                    value=FALSE),
      
      # Babble seed
      conditionalPanel(
        condition="input.set_seed == true",
        numericInput("input_seed",
                     label="Set seed:",
                     value=0,
                     min=0)
        
      ),
      
      # Submit button
      actionButton("submit", 
                   label="Babble!")
      
    ),
    
    mainPanel(
      h3(textOutput("babble")),
      
      hr(),
      
      textOutput("seed_text")
    )
    
  )
)

############################################################
## Server

server <- function(input, output) {
  
}

############################################################
## Run

shinyApp(ui=ui, server=server)
