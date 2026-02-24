



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


data <- iris
data$Key <- names(islands)[sample(1:10, nrow(data), replace = TRUE)]
keys_available <- sort(unique(data$Key))


source_utf8 <- function(file) {
  code <- readLines(file, encoding = "UTF-8", warn = FALSE)
  Encoding(code) <- "UTF-8"
  expr <- parse(text = code)
  eval(expr, envir = .GlobalEnv)
}
functions_file <- if (file.exists("Dashboard/FonctionsDashboard.R")) {
  "Dashboard/FonctionsDashboard.R"
} else {
  "FonctionsDashboard.R"
}

source_utf8(functions_file)


emoji_path <- if (file.exists("Dashboard/Emojis")) {
  "Dashboard/Emojis"
} else {
  "Emojis"
}

addResourcePath("emojis", emoji_path)

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
      # Exemples du pipeline factory "R-like" : create_barplot_card(...)
      create_barplot_card(
        id = "bar1",
        data_r = NULL,
        style = "executive",
        scale = 1.05,
        unit = "",
        size = "normal",
        span = "span1"
      ),
      create_barplot_card(
        id = "bar2",
        data_r = NULL,
        style = "executive",
        scale = 1.1,
        unit = "",
        size = "normal",
        span = "span2"
      ),
      create_barplot_card(
        id = "bar3",
        data_r = NULL,
        style = "compact",
        scale = 1,
        unit = "",
        size = "normal",
        span = "span1"
      ),
      create_barplot_card(
        id = "bar4",
        data_r = NULL,
        style = "compact",
        scale = 1,
        unit = "",
        size = "normal",
        span = "span1"
      ),
      create_groupbar_card(
        id = "BarplotGrouped1",
        data_r = NULL,
        style = "executive",
        scale = 1.03,
        unit = "%"
      ),
      create_stackedbar_card(
        id = "BarplotStacked1",
        data_r = NULL,
        style = "executive",
        scale = 1.03,
        unit = "%"
      ),

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
  
  # Serveur associé aux cartes factory
  create_barplot_card_server(
    id = "bar1",
    data_r = bar_data,
    style = "executive",
    unit = ""
  )
  create_barplot_card_server(
    id = "bar2",
    data_r = bar_data,
    style = "executive",
    unit = ""
  )
  create_barplot_card_server(
    id = "bar3",
    data_r = bar_data,
    style = "compact",
    unit = ""
  )
  create_barplot_card_server(
    id = "bar4",
    data_r = bar_data,
    style = "compact",
    unit = ""
  )
  
  
  stack_data <- reactive({
    data.frame(
        year = c("2021","2022","2023","2024"),
        MAL = c(2,2.5,2.25,2),
        LMLD = c(3,3.5,1.5,1.5),
        ATIJ = c(1,1,1,1)
    )
  })
  
  
  create_stackedbar_card_server(
    id = "BarplotStacked1",
    data_r = stack_data,
    style = "executive",
    unit = "%"
  )
  create_groupbar_card_server(
    id = "BarplotGrouped1",
    data_r = stack_data,
    style = "executive",
    unit = "%"
  )

}



shinyApp(ui, server)
#Impact MO 90% et diminiution LMLD avant le 9 mars !!
