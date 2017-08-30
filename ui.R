library(shiny)
library(ggplot2)
library(stringr)
library(plotly)


shinyUI(fluidPage(
  
  theme = "w3.css",
  
  titlePanel("Nyhetsanalys"),

         sidebarLayout(
           
           sidebarPanel(
             
             helpText("Denna applikation läser igenom alla
                      nyheter som för tillfället finns publiserade på
                      Dagens Industri (", a("www.di.se", href = "http://www.di.se"), 
                      "). Därefter sker en städning av texten där bl.a. skiljetecken 
                      och stopord avlägsnas. Slutligen summeras nyckelorden för att 
                      du ska få en uppfattning av de mest aktuella ämnena för
                      tillfället."),
           
             hr(),
             
             radioButtons("plotType", "Välj typ av plot:",
                          c("WordCloud" = "wc",
                            "Bar Chart" = "bar")),
             hr(),
             
             sliderInput("nwords", "Välj antalet ord att visa:",
                         min = 0, max = 30,
                         value = 10),
             hr(),
             
             actionButton("update", "Uppdatera")
             
             ),
           
           mainPanel(
             
             plotOutput("plot1", height = "700px")
           )
         )
        )
      )
  
  








