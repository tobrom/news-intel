library(shiny)
library(ggplot2)
library(wordcloud)
library(tidyverse)
library(rvest)
library(stringr)
library(purrr)
library(tm)



shinyServer(function(input, output) {
  
  wordData <- reactive({
    
    input$update
    
    isolate({
      
      withProgress({
        
       setProgress(message = "Läser nyheter...")
       
    url <- read_html("http://www.di.se/")
    
    articleRefs <- url %>% 
      html_nodes("article a") %>%
      html_attr("href")
    
    newsOnly <- articleRefs[str_detect(articleRefs, "nyheter")] %>% 
      na.exclude() %>% 
      paste()
    
    
    ###Extracting all news articles
    articlesText <- newsOnly %>%
      map(getArticles) %>%
      map(function(x) {iconv(x, from = "UTF-8", to = "latin1")})
    
    
    ###Starting the text analysis
    
    bagWords <- Corpus(VectorSource(articlesText)) %>%
      tm_map(content_transformer(tolower)) %>%                            
      tm_map(removePunctuation) %>%                                         
      tm_map(removeNumbers) %>%
      tm_map(removeWords, iconv(stopwords("sv"), from = "UTF-8", to = "latin1")) %>%
      TermDocumentMatrix(control = list(minWordLength = 1)) %>%
      as.matrix()
    
    ###Counting and sorting top words 
    
    d <- sort(apply(bagWords, 1, sum), decreasing = T)
    
    
      })
  
    })    
      
  })
      
      
  
  output$plot1 <- renderPlot({
    
    req(wordData())
    
    if (input$plotType == "wc") { 
      
      wordcloud(names(wordData()), 
                wordData(), 
                scale = c(8,0.5),
                min.freq = 10, 
                max.words= input$nwords,
                colors = fall.colors)
      
    } else {
      
      
      wordFrame <- data.frame(keyword = names(wordData()), 
                              count = wordData())
      
      
      ggplot(head(wordFrame, input$nwords), aes(x = reorder(keyword, -count), y = count, fill = keyword)) + 
        geom_bar(stat = "identity") + 
        labs(x  = "", y = "Frekvens") +
      #  scale_fill_manual(values = fall.colors) +
        theme(axis.text.x = element_text(size = 14, angle = 90),
              axis.title.y = element_text(size = 16),
              plot.background = element_blank(),
              panel.background = element_blank(),
              legend.position = "none")
      
    }
    
  })
  

  
})





