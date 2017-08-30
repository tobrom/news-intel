###Colors for fall 2017

fall.colors <- c("#92B558",
                  "#DC4C46",
                  "#672E3B",
                  "#F3D6E4",
                  "#C48F65",
                  "#223A5E",
                  "#898E8C",
                  "#005960",
                  "#9C9A40",
                  "#4F84C4",
                  "#D2691E")

###Function to get article text

getArticles <- function(x) {
  
  url <- read_html(paste0("http://www.di.se", x))
  
  newsArticle <- url %>% 
    html_nodes("section.di_article-body") %>%
    html_text() %>%
    str_replace_all("\n", "") %>%
    str_replace_all("  ", " ") %>%
    str_replace_all("[\"]", "") %>%
    str_trim()
  
  return(newsArticle)
  
}