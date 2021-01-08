
library(tidyverse);library(pdftools); library(tidytext)

get_pdf <- function(pdf_url){
  
  info <- pdf_info(pdf_url)
  
  df <- 
    pdf_text(pdf_url) %>% 
    enframe(name = NULL) %>%
    rename(text = value) %>%
    mutate(
      author = info$keys$Author,
      title = info$keys$Title,
      page = row_number()
    ) %>%
    # Change rows from pages into sentences
    unnest_tokens(text, text, token = "sentences")
  
}

# Examples

# ong <- get_pdf("https://monoskop.org/images/d/db/Ong_Walter_J_Orality_and_Literacy_2nd_ed.pdf")
# philokalia <- get_pdf("https://holybooks.com/wp-content/uploads/Philokalia.pdf")
# bohm <- get_pdf("http://www.gci.org.uk/Documents/DavidBohm-WholenessAndTheImplicateOrder.pdf")


