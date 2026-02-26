



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

departements_geojson <- if (file.exists("Dashboard/departements.geojson")) {
  "Dashboard/departements.geojson"
} else if (file.exists("departements.geojson")) {
  "departements.geojson"
} else if (file.exists("Dashboard/departements.json")) {
  "Dashboard/departements.json"
} else if (file.exists("departements.json")) {
  "departements.json"
} else {
  "https://france-geojson.gregoiredavid.fr/repo/departements.geojson"
}

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
      create_summary_kpi_card(
        id = "summary_kpi_1",
        data_r = NULL,
        style = "executive",
        scale = 1.00,
        title = "Synthèse sélection",
        subtitle = "10 champs + 3 indicateurs",
        size = "large",
        span = "span2"
      ),
      create_global_score_kpi_card(
        id = "global_score_kpi_1",
        data_r = NULL,
        style = "executive",
        scale = 1.00,
        title = "Score global",
        subtitle = "Lecture immédiate de position",
        size = "normal",
        span = "span1"
      ),
      create_france_map_kpi_card(
        id = "france_map_kpi_1",
        data_r = NULL,
        style = "executive",
        scale = 1.05,
        title = "Comparaison géographique",
        subtitle = "Département cible vs limitrophes",
        size = "large",
        span = "span2"
      ),
      create_simple_table_kpi_card(
        id = "simple_table_kpi_1",
        data_r = NULL,
        style = "executive",
        scale = 1.00,
        title = "KPI tableau simple",
        subtitle = "Exemple d'illustration",
        size = "normal",
        span = "span1"
      ),
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
      create_lineplot_card(
        id = "line1",
        data_r = NULL,
        style = "executive",
        scale = 1,
        unit = "",
        title = "Tendance salariale",
        subtitle = "Annuel",
        size = "normal",
        span = "span1"
      ),
      create_multilineplot_card(
        id = "multiline1",
        data_r = NULL,
        style = "executive",
        scale = 1.03,
        unit = "%",
        title = "Comparatif trajectoires",
        subtitle = "Jusqu'à 6 séries",
        size = "large",
        span = "span2"
      ),
      create_special_kpi_card(
        id = "kpi_special_1",
        values_r = NULL,
        compare_r = NULL,
        style = "executive",
        scale = 1.00,
        title = "LM/LD - En cours",
        subtitle = "KPI spécial"
      ),
      create_binary_kpi_card(
        id = "binary_kpi_1",
        data_r = NULL,
        style = "executive",
        scale = 1.00,
        title = "Couverture des risques",
        subtitle = "Phénomène binaire (0/1)",
        size = "large",
        span = "span2"
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
  lineplot_css(),
  multilineplot_css(),
  special_kpi_css(),
  binary_kpi_css(),
  summary_kpi_css(),
  simple_table_kpi_css(),
  global_score_kpi_css(),
  france_map_kpi_css(),
  ui_card_css(),
  container_size_js(),
  #stackedBar_css(),
  stackedBar_html_css(),
  groupBar_html_css(),
  tags$style(HTML(" 
    html, body {
      height: 100%;
      overflow: hidden;
    }

    .top-toolbar {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 1100;
      height: 90px;
      display: grid;
      grid-template-columns: 1fr auto 1fr;
      align-items: center;
      gap: 14px;
      padding: 14px 24px;
      background:
        radial-gradient(circle at 8% 20%, rgba(19,163,232,0.16), transparent 34%),
        radial-gradient(circle at 92% 20%, rgba(90,70,184,0.14), transparent 34%),
        linear-gradient(120deg, rgba(255,255,255,0.94), rgba(237,246,255,0.86));
      border-bottom: 1px solid rgba(185, 198, 214, 0.50);
      box-shadow: 0 10px 26px rgba(14, 42, 84, 0.12);
      backdrop-filter: blur(8px) saturate(125%);
    }

    .top-toolbar-title {
      justify-self: start;
      font-size: 22px;
      font-weight: 650;
      color: #1f334d;
      white-space: nowrap;
      padding-left: 4px;
    }

    .top-toolbar-center {
      justify-self: center;
      width: min(980px, 70vw);
    }

    .top-toolbar-center .search-container {
      margin: 0;
      justify-content: center;
      width: 100%;
    }

    .top-toolbar-center .search-box {
      width: 100%;
    }

    .top-toolbar-spacer {
      justify-self: end;
      width: 160px;
      height: 1px;
    }

    .tabs-bar {
      position: sticky;
      top: 86px;
      z-index: 1050;
      margin: 98px 24px 10px 24px;
    }

    .tabs-content {
      height: calc(100vh - 160px) !important;
      padding-top: 12px;
    }
  ")),
  theme = bs_theme(version = 5),
  tags$div(
    class = "top-toolbar",
    tags$div(class = "top-toolbar-title", "Dashboard générique"),
    tags$div(class = "top-toolbar-center", ui_search_bar("search")),
    tags$div(class = "top-toolbar-spacer")
  ),
  
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

  summary_kpi_data <- reactive({
    key <- selected_key()
    key_value <- if (length(key) >= 1 && !is.na(key[[1]]) && nzchar(key[[1]])) key[[1]] else "Sélection non renseignée"

    fields <- data.frame(
      champ = c(
        "Clé", "Population", "Établissements", "Région", "Segment",
        "Sinistralité", "Budget", "Ancienneté", "Exposition", "Niveau de risque"
      ),
      valeur = c(
        key_value,
        "12 480 agents",
        "38",
        "Île-de-France",
        "Santé / Médico-social",
        "Modérée",
        "27.4 M€",
        "8.2 ans",
        "74 %",
        "2.6 / 5"
      ),
      stringsAsFactors = FALSE
    )

    indicators <- data.frame(
      indicateur = c("Coût moyen", "Fréquence", "Gravité"),
      `2022` = c(11.2, 3.7, 1.9),
      `2023` = c(11.8, 3.5, 2.1),
      `2024` = c(12.1, 3.2, 2.4),
      check.names = FALSE
    )

    list(fields = fields, indicators = indicators)
  })

  create_summary_kpi_card_server(
    id = "summary_kpi_1",
    data_r = summary_kpi_data,
    unit = ""
  )

  global_score_data <- reactive({
    data.frame(
      annee = c("2021", "2022", "2023", "2024"),
      score = c(4.9, 3.5, 4.4, 4.3),
      stringsAsFactors = FALSE
    )
  })

  create_global_score_kpi_card_server(
    id = "global_score_kpi_1",
    data_r = global_score_data,
    unit = "/10"
  )

  france_map_values <- reactive({
    set.seed(42)
    data.frame(
      code = c("67", "68", "57", "54", "88", "90", "70", "52", "55", "08", "10", "21", "25", "39"),
      value = round(runif(14, min = 2.7, max = 4.6), 2),
      stringsAsFactors = FALSE
    )
  })

  france_map_data <- reactive({
    list(
      geojson_path = departements_geojson,
      dept_code = "67",
      values = france_map_values()
    )
  })

  create_france_map_kpi_card_server(
    id = "france_map_kpi_1",
    data_r = france_map_data
  )

  simple_table_kpi_data <- reactive({
    data.frame(
      KPI = c("Fréquence", "Coût moyen", "Gravité", "Taux d'exposition"),
      `2023` = c("3.5", "11.8", "2.1", "74%"),
      `2024` = c("3.2", "12.1", "2.4", "77%"),
      `Δ` = c("-8.6%", "+2.5%", "+14.3%", "+4.1%"),
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  })

  create_simple_table_kpi_card_server(
    id = "simple_table_kpi_1",
    data_r = simple_table_kpi_data
  )
  
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
  create_lineplot_card_server(
    id = "line1",
    data_r = bar_data,
    style = "executive",
    unit = ""
  )

  multiline_data <- reactive({
    data.frame(
      year = c("2021", "2022", "2023", "2024"),
      Masse = c(100, 108, 116, 121),
      Sinistres = c(82, 88, 91, 97),
      Taux = c(64, 67, 70, 73),
      AT = c(42, 46, 49, 54),
      LT = c(53, 52, 56, 59)
    )
  })

  create_multilineplot_card_server(
    id = "multiline1",
    data_r = multiline_data,
    style = "executive",
    unit = "%"
  )

  kpi_values_data <- reactive({
    data.frame(
      metric = c("Coût total", "Durée Totale", "Coût / sinistre", "Durée / sinistre"),
      `2021` = c(1747204, 33962, 12847, 250),
      `2022` = c(2166413, 48633, 11463, 257),
      `2023` = c(2763360, 60736, 11759, 258),
      `2024` = c(2772580, 64442, 12660, 294),
      check.names = FALSE
    )
  })

  kpi_compare_data <- reactive({
    data.frame(
      metric = c("Coût total", "Durée Totale", "Coût / sinistre", "Durée / sinistre"),
      collectivite = c(36461.3, 801.9, 12182.2, 264.9),
      groupe = c(33762.4, 1030.9, 9612.5, 243.3)
    )
  })

  create_special_kpi_card_server(
    id = "kpi_special_1",
    values_r = kpi_values_data,
    compare_r = kpi_compare_data,
    unit = " €"
  )

  binary_kpi_data <- reactive({
    data.frame(
      metric = c("MAL", "MAT/PAT", "LM/LD", "AT(IJ)", "AT(FM)", "DC"),
      `2021` = c(0, 0, 1, 1, 1, 0),
      `2022` = c(0, 0, 1, 1, 1, 0),
      `2023` = c(0, 0, 1, 1, 1, 0),
      `2024` = c(0, 0, 1, 1, 1, 0),
      check.names = FALSE
    )
  })

  create_binary_kpi_card_server(
    id = "binary_kpi_1",
    data_r = binary_kpi_data
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
