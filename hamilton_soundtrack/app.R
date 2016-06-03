############################################################
## Hamilton Soundtrack Stats
############################################################

library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)

# Load data
data <- read.table("data/2016-06-01_hamilton_soundtrack.txt", sep="\t",
                   header=FALSE, stringsAsFactors=FALSE, quote="", 
                   comment.char="")

# Select and rename columns
data <- data %>% select(V2, V3, V8, V9) %>%
  S4Vectors::rename(V2="name", V3="time", V8="fav", V9="plays") %>%
  mutate(index=seq_len(nrow(data)),
         fav=as.factor(fav)) %>%
  select(index, everything())

############################################################
## UI

ui <- fluidPage(
  titlePanel("Hamilton Soundtrack Play Count"),
  
  sidebarLayout(
    sidebarPanel(
      # Y-axis range slider
      sliderInput("y_range", 
                  label = h4("Y-axis range:"), 
                  min = 0, 
                  max = 100, 
                  value = c(10, 90))
    ),
    
    mainPanel(
      # Show plot
      plotlyOutput("plot")
    )
  )
)

############################################################
## Server

server <- function(input, output) {
  output$plot <- renderPlotly({
    ggplot(data, aes(x=index, y=plays, text=name)) + 
      geom_point() +
      coord_cartesian(ylim=input$y_range)
  })
}

############################################################
## Run

shinyApp(ui=ui, server=server)
