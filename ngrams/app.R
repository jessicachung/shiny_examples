############################################################
## N-gram Babbler
############################################################

# Inspired by King James Programming 
#   http://kingjamesprogramming.tumblr.com/
# and Modern Applied Statistics in R'lyeh
#   http://librestats.com/2014/07/01/modern-applied-statistics-in-rlyeh/

library(shiny)
library(ngram)
library(dplyr)

load("data/books.rda")

# Make book list for drop-down menu
book_list <- list()
for (i in seq_along(books)) {
  book_list[[names(books)[i]]] <- i
}

combine_texts <- function(x1, x2) {
  "Make text_1 and text_2 equal length and combine them"
  text_1 <- as.numeric(x1)
  text_2 <- as.numeric(x2)
  # Get the length of the shortest book
  min_length <- min(nchar(books[[text_1]]), nchar(books[[text_2]]))
  print(min_length)
  # Combine texts of equal length
  x <- paste(substr(books[[text_1]], 1, min_length), 
             substr(books[[text_2]], 1, min_length), collapse=" ")
  return(x)
}

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
                  selected=sample(x=length(book_list), size=1)),
      
      # Text 2
      selectInput("text_2", 
                  label="Second text:",
                  choices=book_list,
                  selected=sample(x=length(book_list), size=1)),
      
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
                     min=0)),
      
      # Submit button
      actionButton("submit", 
                   label="Babble!")
      
    ),
    
    mainPanel(
      # Babble text
      div(align="center",
          h3(textOutput("babble"))),
      
      hr(),
      
      # Seed text
      div(align="right", 
          style="color:#aaaaaa;", 
          textOutput("seed_text"))
    )
    
  )
)

############################################################
## Server

server <- function(input, output) {
  
  # Set inital value of seed
  rv <- reactiveValues(
    babble_seed = round(runif(1, min=0, max=1e6))
  )
  
  # Generate ngrams when text_1 and text_2 changes
  bigram <- reactive({
    text <- combine_texts(input$text_1, input$text_2)
    ngram(text, n=2)
  })
  
  # Update seed with submit button
  observeEvent(input$submit, {
    if (input$set_seed) {
      rv$babble_seed <- input$input_seed
    } else {
      rv$babble_seed <- round(runif(1, min=0, max=1e6), digits=0)
    }
  })
  
  # If seed is not set, display seed below babble text
  output$seed_text <- renderText({
    ifelse(input$set_seed, "", sprintf("Seed: %d", rv$babble_seed))
  })
  
  # Generate babble text
  output$babble <- renderText({
    paste("...", 
          babble(bigram(), input$n, seed=rv$babble_seed),
          "...")
  })
}

############################################################
## Run

shinyApp(ui=ui, server=server)
