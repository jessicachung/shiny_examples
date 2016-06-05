############################################################
## Download books from Project Gutenberg
############################################################

# Download public domain books for N-gram babbler.

library(dplyr)
library(gutenbergr)
library(stringr)

# Books to download from Project Gutenberg:
titles <- "Pride and Prejudice
Alice's Adventures in Wonderland
The King James Version of the Bible
The Adventures of Sherlock Holmes
Grimms' Fairy Tales
Shakespeare's Sonnets
Second Treatise of Government
The Republic
Utilitarianism
Meditations"

titles <- titles %>% str_split("\n") %>% unlist

# Get Gutenberg info for each title
title_info <- gutenberg_works() %>% 
  filter(title %in% titles) %>% 
  arrange(author) %>% as.data.frame

# View info
title_info

# Download each text and store in list
books <- list()
for (i in seq_len(nrow(title_info))) {
  title <- title_info[i,"title"]
  author <- title_info[i,"author"]
  
  # Combine title and author
  if (! is.na(author)) {
    name <- sprintf("%s (%s)", title, author)
  } else {
    name <- title
  }
  print(name)
  
  # Fetch book
  text <- gutenberg_download(title_info[i,"gutenberg_id"]) %>% .$text
  
  # Collapse 
  text_string <- paste(text, collapse=" ")
  books[[name]] <- text_string
  
  Sys.sleep(1)
}

# Save list
save(books, file="books.rda")
