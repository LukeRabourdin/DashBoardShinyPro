



library(shiny)
library(shinyjs)
library(bslib)
library(showtext)
library(htmltools)
library(fmsb)
library(openxlsx)
library(sf)
library(ggplot2)
library(arrow)


setwd("C:/Users/lrabourdin/Documents/Dossier Travail/Statut/2026/Dashboard")

data <- iris
data$Key <- names(islands)[sample(1:10, nrow(data), replace = TRUE)]
keys_available <- sort(unique(data$Key))


source_utf8 <- function(file) {
  code <- readLines(file, encoding = "UTF-8", warn = FALSE)
  Encoding(code) <- "UTF-8"
  expr <- parse(text = code)
  eval(expr, envir = .GlobalEnv)
}
source_utf8("C:/Users/lrabourdin/Documents/Dossier Travail/Statut/2026/Dashboard/FonctionsDashboard.R")


addResourcePath("emojis", "Emojis")

#Dummy Data
get_bar_data <- function(key) {
  data.frame(
    year = c("2021", "2022", "2023", "2024"),
    value = c(139.2, 142.4, 144.6, 143.8)
  )
}







df=data.frame(
  year = c("2021","2022","2023","2024"),
  MAL = c(2,2.5,2.25,2),
  LMLD = c(3,3.5,1.5,1.5),
  ATIJ = c(1,1,1,1)
)











content_map <- list(
  
  "Vue générale" = function() {
    ui_dashboard_grid(
      ui_card(title = "Masse salariale",subtitle = "Annuel",size = "normal",span = "span1", barplot_ui("bar1")),
      ui_card(title = "Masse salariale",subtitle = "Annuel",size = "normal",span = "span2", barplot_ui("bar2")),
      ui_card(title = "Masse salariale",subtitle = "Annuel",size = "normal",span = "span1", barplot_ui("bar3")),
      ui_card(title = "Masse salariale",subtitle = "Annuel",size = "normal",span = "span1", barplot_ui("bar4")),
      ui_card(title = "Masse salariale",subtitle = "Annuel",size = "large",span = "span2", groupBar_ui("BarplotGrouped1")),
      ui_card(title = "Masse salariale",subtitle = "Annuel",size = "large",span = "span2", stackedBar_ui ("BarplotStacked1")),

    )
  },
  
  "Financier" = function() {
    tags$h4("Contenu financier à venir")
  },
  
  "Démographie" = function() {
    tags$h4("Contenu démographie à venir")
  }
)



ui <- fluidPage(
  useShinyjs(),
  copyCard(),
  barplot_css(),
  ui_card_css(),
  container_size_js(),
  #stackedBar_css(),
  stackedBar_html_css(),
  groupBar_html_css(),
  theme = bs_theme(version = 5),
  
  ui_header(),
  ui_search_bar("search"),
  
  ui_tabs(
    "tabs",
    tabs = c(
      "Vue générale",
      "Financier",
      "Démographie"
    )
  )
)


server<-function(input, output, session) {
  
  
  tabs_server(
    id = "tabs",
    content_map = content_map
  )
  
  selected_key <- search_server(
    id = "search",
    keys = keys_available
  )
  
  output$debug <- renderText({
    paste("Clé sélectionnée :", selected_key())
  })
  
  bar_data <- reactive({
    data.frame(
      year  = c("2021", "2022", "2023", "2024"),
      value = c(139.2, 142.4, 144.6, 143.8)
    )
  })
  
  barplot_server(
    id = "bar1",
    data_r = bar_data
  )
  barplot_server(
    id = "bar2",
    data_r = bar_data
  )
  barplot_server(
    id = "bar3",
    data_r = bar_data
  )
  barplot_server(
    id = "bar4",
    data_r = bar_data
  )
  barplot_server(
    id = "bar5",
    data_r = bar_data
  )
  
  
  stack_data <- reactive({
    data.frame(
        year = c("2021","2022","2023","2024"),
        MAL = c(2,2.5,2.25,2),
        LMLD = c(3,3.5,1.5,1.5),
        ATIJ = c(1,1,1,1)
    )
  })
  
  
  stackedBar_server("BarplotStacked1",stack_data,unit = "%")
  groupBar_server("BarplotGrouped1",stack_data,unit = "%")

}



shinyApp(ui, server)
#Impact MO 90% et diminiution LMLD avant le 9 mars !!
