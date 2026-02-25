relyens_chart_colors <- function(k) {
  base_colors <- c(
    "#0057B8", "#13A3E8", "#5A46B8",
    "#00B894", "#FF8A3D", "#E94E77"
  )
  rep(base_colors, length.out = k)
}

design_tokens_css <- function() {
  tags$style(HTML("
    :root {
      --brand-primary: #0057B8;
      --brand-secondary: #13A3E8;
      --brand-tertiary: #5A46B8;
      --brand-accent: #00B894;
      --text-primary: #16263A;
      --text-secondary: #5D7088;
      --surface-glass: rgba(255, 255, 255, 0.72);
      --surface-strong: rgba(255, 255, 255, 0.9);
      --surface-card: rgba(255, 255, 255, 0.78);
      --stroke-soft: rgba(255, 255, 255, 0.42);
      --stroke-strong: rgba(18, 55, 97, 0.12);
      --shadow-soft: 0 10px 32px rgba(14, 42, 84, 0.10);
      --shadow-strong: 0 20px 44px rgba(14, 42, 84, 0.16);
      --shadow-focus: 0 14px 30px rgba(0, 87, 184, 0.18);
      --radius-md: 12px;
      --radius-lg: 16px;
      --motion-fast: 160ms;
    }

    body {
      background:
        radial-gradient(circle at 8% 0%, rgba(19,163,232,0.14), transparent 36%),
        radial-gradient(circle at 90% 6%, rgba(90,70,184,0.12), transparent 32%),
        linear-gradient(180deg, #F7FAFF 0%, #EEF3FB 100%);
      color: var(--text-primary);
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      letter-spacing: 0.01em;
    }
  "))
}




#########################
#   Header
#########################
header_css <- function() {
  tags$style(HTML("
    .app-header {
      position: relative;
      height: 90px;
      padding: 0 32px;

      display: block;
      align-items: center;

      font-size: 22px;
      font-weight: 600;
      color: var(--text-primary);

      background: linear-gradient(120deg, rgba(255,255,255,0.92), rgba(237,246,255,0.78));
      border-bottom: 1px solid var(--stroke-soft);
      backdrop-filter: blur(10px) saturate(130%);
      box-shadow: var(--shadow-soft);

      overflow: hidden;
    }

    /* ==============================
       GRANDE DIAGONALE COLORÉE
       ============================== */
    .app-header::before {
      content: '';
      position: absolute;
      inset: -40% -20% -40% 40%;

      background: linear-gradient(
        135deg,
        rgba(0, 180, 216, 0.45),
        rgba(72, 202, 228, 0.35),
        rgba(173, 232, 244, 0.25),
        rgba(255, 200, 221, 0.20),
        rgba(255, 255, 255, 0.0)
      );

      transform: rotate(-8deg);
      filter: blur(40px);
    }

    /* ==============================
       VOILE COURBE HAUT
       ============================== */
    .app-header::after {
      content: '';
      position: absolute;
      top: -120px;
      left: -20%;
      width: 140%;
      height: 200px;

      background: radial-gradient(
        ellipse at center,
        rgba(255,255,255,0.85),
        rgba(255,255,255,0.0) 70%
      );
    }

    /* ==============================
       LIGNES DIAGONALES SUBTILES
       ============================== */
    .app-header-lines {
      position: absolute;
      inset: 0;
      background:
        repeating-linear-gradient(
          -12deg,
          rgba(0,0,0,0.02) 0px,
          rgba(0,0,0,0.02) 1px,
          transparent 1px,
          transparent 60px
        );
      pointer-events: none;
    }

  "))
}

container_size_js <- function() {
  tags$script(HTML("
Shiny.addCustomMessageHandler('measure_container', function(message) {

  const el = document.getElementById(message.id);
  if (!el) return;

  const rect = el.getBoundingClientRect();

  Shiny.setInputValue(message.id + '_size', {
    width: rect.width,
    height: rect.height
  }, {priority: 'event'});

});
"))


}




ui_header <- function(title = "Dashboard générique") {
  tagList(
    design_tokens_css(),
    header_css(),
    tags$div(
      class = "app-header",
      tags$div(class = "app-header-lines"),
      title
    )
  )
}


copyCard <- function() {
  tagList(
    tags$div(
      id = "global-toast",
      "Image copiée dans le presse-papier",
      style = "
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: #ffffff;
        color: #000000;
        padding: 10px 14px;
        border-radius: 8px;
        font-size: 14px;
        box-shadow: 0 4px 12px rgba(0,0,0,.15);
        display: none;
        z-index: 9999;
      "
    ),
    
    tags$script(src = "html2canvas.min.js"),
    
    tags$script(HTML("
      async function copyImageFromButton(btn) {
        try {
          const container = btn.closest('.copy-target');
          if (!container) return;

          const canvas = await html2canvas(container, {
            backgroundColor: '#ffffff',
            scale: 2,
            useCORS: true
          });

          canvas.toBlob(async function(blob) {
            await navigator.clipboard.write([
              new ClipboardItem({ 'image/png': blob })
            ]);
            showGlobalToast();
          });

        } catch (e) {
          console.error('Snapshot copy failed', e);
        }
      }

      function showGlobalToast() {
        const toast = document.getElementById('global-toast');
        if (!toast) return;

        toast.style.display = 'block';
        setTimeout(() => {
          toast.style.display = 'none';
        }, 1500);
      }
    "))
  )
}



#########################
#   Tabs
#########################
tabs_css <- function() {
  tags$style(HTML("
    .tabs-bar {
      display: flex;
      gap: 12px;
      padding: 10px 24px;
      background: var(--surface-card);
      border: 1px solid var(--stroke-soft);
      border-radius: 14px;
      backdrop-filter: blur(10px);
      box-shadow: var(--shadow-soft);
      margin-bottom: 12px;
    }

    .tab-btn {
      padding: 8px 14px;
      border-radius: 10px;
      border: none;
      background: transparent;
      font-size: 13px;
      cursor: pointer;
      color: var(--text-secondary);
      position: relative;
      transition:
        background-color 0.15s ease,
        color 0.15s ease,
        transform 0.1s ease;
    }
    
    .tab-btn:hover {
      background: rgba(0, 87, 184, 0.12);
      color: var(--brand-primary);
      transform: translateY(-1px);
    }

    .tab-btn.active {
      background: linear-gradient(180deg, rgba(0,87,184,0.16), rgba(0,87,184,0.08));
      color: var(--brand-primary);
      font-weight: 700;
      box-shadow: inset 0 0 0 1px rgba(0,87,184,0.16);
    }
    .tab-btn:focus {
      outline: none;
      box-shadow: none;
    }

    
    .tab-btn.active::after {
      content: '';
      position: absolute;
      left: 20%;
      right: 20%;
      bottom: -3px;
      height: 2px;
      background: var(--brand-primary);
      border-radius: 4px;
    }

    
    .tabs-content {
      height: calc(100vh - 140px); /* header + tabs */
      overflow-y: auto;
      padding: 24px;
      background: transparent;
    }
  "))
}

ui_tabs <- function(id, tabs) {
  ns <- NS(id)
  tagList(
    tabs_css(),
    
    tags$div(
      class = "tabs-bar",
      lapply(seq_along(tabs), function(i) {
        tab <- tabs[[i]]
        
        tags$button(
          tab,
          class = paste("tab-btn", if (i == 1) "active"),
          onclick = sprintf(
            "
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            Shiny.setInputValue('%s', '%s', {priority: 'event'});
            ",
            ns("active_tab"), tab
          )
        )
      })
    ),
    
    tags$div(
      class = "tabs-content",
      uiOutput(ns("content"))
    )
  )
}


tabs_server <- function(id, content_map) {
  moduleServer(id, function(input, output, session) {
    
    active_tab <- reactiveVal(names(content_map)[1])
    
    observeEvent(input$active_tab, {
      active_tab(input$active_tab)
    })
    
    output$content <- renderUI({
      content_map[[active_tab()]]()
    })
    
    return(active_tab)
  })
}




###################
#  Grid
###################
dashboard_grid_css <- function() {
  tags$style(HTML("
    .dashboard-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
      gap: 24px;
      align-items: start;
      grid-auto-flow: dense;
    }
    
    
    .grid-span-1 { grid-column: span 1; }
    .grid-span-2 { grid-column: span 2; }
    .grid-span-3 { grid-column: span 3; }
    .grid-span-full { grid-column: 1 / -1; }
    
  "))
}

ui_dashboard_grid <- function(...) {
  tagList(
    dashboard_grid_css(),
    tags$div(
      class = "dashboard-grid",
      ...
    )
  )
}


##############################
#         Search Bar
##############################
search_bar_css <- function() {
  tags$style(HTML("
    /* ==============================
       CONTAINER GLOBAL
       ============================== */

    .search-container {
      display: flex;
      justify-content: center;
      margin: 30px 0;
    }

    .search-box {
      width: min(620px, 92vw);
      position: relative; /* reference pour le bouton */
    }

    /* ==============================
       INPUT DE RECHERCHE
       ============================== */

    .search-input {
      width: 100%;
      padding: 14px 56px 14px 20px; /* espace pour la loupe */
      font-size: 16px;
      font-weight: 500;
      color: #1f2d3d;

      border-radius: 14px;
      border: 1px solid var(--stroke-strong);
      background-color: var(--surface-strong);
      backdrop-filter: blur(10px);
      outline: none;

      box-shadow: 0 1px 3px rgba(0,0,0,0.06);

      transition:
        box-shadow 0.2s ease,
        border-color 0.2s ease,
        transform 0.15s ease;
    }

    .search-input::placeholder {
      color: #8fa1b8;
      font-weight: 400;
    }

    .search-input:focus {
      border-color: var(--brand-primary);
      box-shadow: 0 4px 12px rgba(0,94,184,0.18);
      transform: translateY(-1px);
    }

    /* ==============================
       BOUTON LOUPE
       ============================== */

    .search-btn {
      position: absolute;
      top: 50%;
      right: 8px;
      transform: translateY(-50%);

      width: 40px;
      height: 40px;
      border-radius: 50%;

      border: none;
      background: transparent;
      cursor: pointer;

      display: flex;
      align-items: center;
      justify-content: center;
    }

    .search-btn:hover {
      background-color: rgba(0,94,184,0.08);
    }

    .search-btn img {
      width: 18px;
      height: 18px;
      opacity: 0.6;
      transition: opacity 0.15s ease;
    }

    .search-input:focus + .search-btn img {
      opacity: 1;
    }

    /* ==============================
       SUGGESTIONS
       ============================== */

    .suggestions {
      position: absolute;
      top: calc(100% + 8px);
      width: 100%;
      background: white;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      z-index: 10;
      overflow: hidden;
    }

    .suggestion-item {
      padding: 10px 20px;
      font-size: 10px;
      cursor: pointer;
      transition:
        background-color 0.15s ease,
        border-left-color 0.15s ease;
      border-left: 3px solid transparent;
    }

    .suggestion-item:hover {
      background-color: #f5f8fd;
      border-left-color: var(--brand-primary);
    }
  "))
}


ui_search_bar <- function(id) {
  ns <- NS(id)
  
  tagList(
    search_bar_css(),
    
    tags$div(
      class = "search-container",
      tags$div(
        class = "search-box",
        
        tags$input(
          id = ns("query"),
          class = "search-input",
          type = "text",
          placeholder = "Rechercher une collectivité...",
          onblur = sprintf(
            "Shiny.setInputValue('%s', Math.random())",
            ns("blur")
          )
        ),
        
        tags$button(
          id = ns("go"),
          type = "button",
          class = "search-btn",
          tags$img(src = "emojis/search.svg")
        ),
        
        uiOutput(ns("suggestions"))
      )
    )
  )
}


search_server <- function(id, keys) {
  moduleServer(id, function(input, output, session) {
    
    # Etat interne
    show_suggestions <- reactiveVal(FALSE)
    selected <- reactiveVal(NULL)
    
    # -------------------------
    # Suggestions visibles
    # -------------------------
    observeEvent(input$query, {
      show_suggestions(TRUE)
    }, ignoreInit = TRUE)
    
    observeEvent(input$blur, {
      show_suggestions(FALSE)
    })
    
    # -------------------------
    # Filtrage
    # -------------------------
    filtered_keys <- reactive({
      req(input$query)
      keys[grepl(input$query, keys, ignore.case = TRUE)]
    })
    
    # -------------------------
    # Clic sur suggestion
    # -------------------------
    output$suggestions <- renderUI({
      req(show_suggestions())
      req(input$query)
      
      suggestions <- head(filtered_keys(), 6)
      if (length(suggestions) == 0) return(NULL)
      
      tags$div(
        class = "suggestions",
        lapply(suggestions, function(k) {
          tags$div(
            class = "suggestion-item",
            k,
            
            # IMPORTANT: mousedown se déclenche AVANT blur
            onmousedown = sprintf(
              "
          Shiny.setInputValue('%s', '%s', {priority: 'event'});
          document.getElementById('%s').value = '%s';
          document.getElementById('%s').blur();
          ",
              session$ns("validated"), k,
              session$ns("query"), k,
              session$ns("query")
            )
          )
        })
      )
    })
    
    
    # -------------------------
    # Validation par clic bouton
    # -------------------------
    observeEvent(input$go, {
      if (input$query %in% keys)
        selected(input$query)
    })
    
    # -------------------------
    # Validation par suggestion
    # -------------------------
    observeEvent(input$validated, {
      selected(input$validated)
    })
    
    return(selected)
  })
}



search_bar_js <- function(id) {
  ns <- NS(id)
  
  tags$script(HTML(sprintf("
    document.addEventListener('click', function(e) {
      const input = document.getElementById('%s');
      const suggestions = document.getElementById('%s-suggestions-wrapper');

      if (!input || !suggestions) return;

      if (!input.contains(e.target) && !suggestions.contains(e.target)) {
        Shiny.setInputValue('%s-clear', Math.random());
      }
    });
  ",
                           ns("query"),
                           ns("suggestions"),
                           ns("clear")
  )))
}

##############################
#         UI CARD
##############################

card_size_tokens <- function(size = c("small", "normal", "large"), scale = 1) {
  size <- match.arg(size)

  if (is.list(scale)) {
    scale <- unlist(scale, recursive = TRUE, use.names = FALSE)
  }

  scale_num <- suppressWarnings(as.numeric(scale)[1])
  if (is.na(scale_num) || !is.finite(scale_num)) {
    scale_num <- 1
  }
  scale_num <- max(0.7, scale_num)

  base_height <- switch(
    size,
    small = 260,
    normal = 340,
    large = 440
  )

  base_pad <- switch(
    size,
    small = 16,
    normal = 20,
    large = 22
  )

  list(
    card_h = round(base_height * scale_num),
    card_pad = round(base_pad * min(scale_num, 1.15))
  )
}

ui_card <- function(
    title = NULL,
    subtitle = NULL,
    size = c("small", "normal", "large"),
    span = c("span1", "span2", "span3", "spanfull"),
    ...,
    scale = 1
) {
  # `scale` is kept after `...` so unnamed plot UI args still map to `...`
  size <- match.arg(size)
  span <- match.arg(span)
  
  span_class <- switch(
    span,
    span1 = "grid-span-1",
    span2 = "grid-span-2",
    span3 = "grid-span-3",
    spanfull = "grid-span-full"
  )

  tokens <- card_size_tokens(size = size, scale = scale)
  card_style <- paste0(
    "--card-h:", tokens$card_h, "px;",
    "--card-pad:", tokens$card_pad, "px;"
  )
  
  tags$div(
    class = paste("ui-card", paste0("size-", size), span_class, "copy-target"),
    style = card_style,
    
    tags$button(
      type = "button",
      class = "card-copy-btn",
      onclick = "copyImageFromButton(this)",
      icon("copy")
    ),
    
    if (!is.null(title) || !is.null(subtitle))
      tags$div(
        class = "ui-card-header",
        if (!is.null(title)) tags$div(class = "ui-card-title", title),
        if (!is.null(subtitle)) tags$div(class = "ui-card-subtitle", subtitle)
      ),
    
    tags$div(class = "ui-card-body", ...)
  )
}


create_barplot_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.1,
    unit = "%",
    title = "Masse salariale",
    subtitle = "Annuel",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "normal", span = "span1"),
    compact   = list(size = "small",  span = "span1"),
    minimal   = list(size = "normal", span = "span2")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    barplot_ui(id),
    scale = scale
  )
}

create_barplot_card_server <- function(id, data_r, style = c("executive", "compact", "minimal"), unit = "%") {
  style <- match.arg(style)
  barplot_server(id = id, data_r = data_r, style = style, unit = unit)
}


create_lineplot_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.05,
    unit = "%",
    title = "Tendance annuelle",
    subtitle = "Annuel",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "normal", span = "span1"),
    compact   = list(size = "small",  span = "span1"),
    minimal   = list(size = "normal", span = "span2")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    lineplot_ui(id),
    scale = scale
  )
}

create_lineplot_card_server <- function(id, data_r, style = c("executive", "compact", "minimal"), unit = "%") {
  style <- match.arg(style)
  lineplot_server(id = id, data_r = data_r, style = style, unit = unit)
}

create_multilineplot_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.05,
    unit = "%",
    title = "Tendances multi-séries",
    subtitle = "Comparaison annuelle",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "large", span = "span2"),
    compact   = list(size = "normal", span = "span2"),
    minimal   = list(size = "normal", span = "span1")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    multilineplot_ui(id),
    scale = scale
  )
}

create_multilineplot_card_server <- function(id, data_r, style = c("executive", "compact", "minimal"), unit = "%") {
  style <- match.arg(style)
  multilineplot_server(id = id, data_r = data_r, style = style, unit = unit)
}

create_special_kpi_card <- function(
    id,
    values_r,
    compare_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.02,
    title = "LM/LD - En cours",
    subtitle = "KPI avancé",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "large", span = "span2"),
    compact   = list(size = "normal", span = "span2"),
    minimal   = list(size = "normal", span = "span1")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    special_kpi_ui(id),
    scale = scale
  )
}

create_special_kpi_card_server <- function(id, values_r, compare_r, unit = "€") {
  special_kpi_server(id = id, values_r = values_r, compare_r = compare_r, unit = unit)
}

create_summary_kpi_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.00,
    title = "Synthèse sélection",
    subtitle = "Informations descriptives",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "large", span = "span2"),
    compact   = list(size = "normal", span = "span2"),
    minimal   = list(size = "normal", span = "span1")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    summary_kpi_ui(id),
    scale = scale
  )
}

create_summary_kpi_card_server <- function(id, data_r, unit = "") {
  summary_kpi_server(id = id, data_r = data_r, unit = unit)
}

create_global_score_kpi_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.00,
    title = "Score global",
    subtitle = "Lecture rapide du niveau de sinistralité",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "normal", span = "span1"),
    compact   = list(size = "normal", span = "span1"),
    minimal   = list(size = "normal", span = "span1")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    global_score_kpi_ui(id),
    scale = scale
  )
}

create_global_score_kpi_card_server <- function(id, data_r, unit = "/10") {
  global_score_kpi_server(id = id, data_r = data_r, unit = unit)
}

create_france_map_kpi_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.00,
    title = "Comparaison territoriale",
    subtitle = "Département vs limitrophes",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "large", span = "span2"),
    compact   = list(size = "normal", span = "span2"),
    minimal   = list(size = "normal", span = "span1")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    france_map_kpi_ui(id),
    scale = scale
  )
}

create_france_map_kpi_card_server <- function(id, data_r) {
  france_map_kpi_server(id = id, data_r = data_r)
}

create_binary_kpi_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.00,
    title = "Couverture des risques",
    subtitle = "Binaire (0/1)",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "large", span = "span2"),
    compact   = list(size = "normal", span = "span2"),
    minimal   = list(size = "normal", span = "span1")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    binary_kpi_ui(id),
    scale = scale
  )
}

create_binary_kpi_card_server <- function(id, data_r) {
  binary_kpi_server(id = id, data_r = data_r)
}

create_groupbar_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.05,
    unit = "%",
    title = "Masse salariale",
    subtitle = "Annuel",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "large", span = "span2"),
    compact   = list(size = "normal", span = "span2"),
    minimal   = list(size = "normal", span = "span1")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    groupBar_ui(id),
    scale = scale
  )
}

create_groupbar_card_server <- function(id, data_r, style = c("executive", "compact", "minimal"), unit = "%") {
  style <- match.arg(style)
  groupBar_server(id = id, data_r = data_r, unit = unit)
}

create_stackedbar_card <- function(
    id,
    data_r,
    style = c("executive", "compact", "minimal"),
    scale = 1.05,
    unit = "%",
    title = "Masse salariale",
    subtitle = "Annuel",
    size = NULL,
    span = NULL
) {
  style <- match.arg(style)

  defaults <- switch(
    style,
    executive = list(size = "large", span = "span2"),
    compact   = list(size = "normal", span = "span2"),
    minimal   = list(size = "normal", span = "span1")
  )

  if (is.null(size)) size <- defaults$size
  if (is.null(span)) span <- defaults$span

  ui_card(
    title = title,
    subtitle = subtitle,
    size = size,
    span = span,
    stackedBar_ui(id),
    scale = scale
  )
}

create_stackedbar_card_server <- function(id, data_r, style = c("executive", "compact", "minimal"), unit = "%") {
  style <- match.arg(style)
  stackedBar_server(id = id, data_r = data_r, unit = unit)
}




ui_card_css <- function() {
  tags$style(HTML("
    .ui-card{
      /* base */
      background: var(--surface-card);
      border: 1px solid var(--stroke-strong);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-soft);
      backdrop-filter: blur(12px) saturate(125%);
      position:relative;
      overflow: hidden;
      box-sizing:border-box;

      /* layout */
      display:flex;
      flex-direction:column;

      /* tokens */
      --card-pad: 20px;
      --header-gap: 12px;          /* margin-bottom header */
      --header-min: 42px;          /* hauteur typique titre+sous-titre */
      --svg-h: 0px;                /* calculé plus bas */
      --card-h: 340px;

      height: var(--card-h);
      padding: var(--card-pad);
    }

    .ui-card.size-small  { --card-h: 260px; }
    .ui-card.size-normal { --card-h: 340px; }
    .ui-card.size-large  { --card-h: 440px; }

    .ui-card::before{
      content:'';
      position:absolute;
      top:0;
      left:0;
      right:0;
      height:3px;
      background: linear-gradient(90deg, rgba(0,87,184,0.78), rgba(19,163,232,0.65), rgba(90,70,184,0.66));
      opacity:0.75;
    }

    /* header */
    .ui-card-header{
      flex:0 0 auto;
      margin-bottom: var(--header-gap);
      min-height: var(--header-min);
    }
    .ui-card-title{
      font-weight:600;
      font-size:15px;
      color:#1f2d3d;
      line-height:1.2;
    }
    .ui-card-subtitle{
      font-size:12px;
      color:#7a8ca3;
      line-height:1.2;
      margin-top:4px;
    }

    /* body: prend l'espace restant, et IMPORTANT pour flex shrink */
    .ui-card-body{
      flex:1 1 auto;
      min-height:0;
      overflow:visible;
      display:flex;
      /* calc hauteur dispo pour le svg:
         card - padding*2 - header - gap */
      --svg-h: calc(var(--card-h) - (var(--card-pad) * 2) - var(--header-min) - var(--header-gap));
    }

    /* svg = 100% de la zone body, pas de ratio */
    .ui-card-body svg{
      width:100%;
      /*height: var(--svg-h);*/
    }




    /* copy button */
    .card-copy-btn{
      position:absolute;
      top:12px;
      right:12px;
      background:#fff;
      border:none;
      padding:6px 8px;
      border-radius:8px;
      cursor:pointer;
      box-shadow:0 2px 6px rgba(0,0,0,.15);
      display:none;
      z-index:5;
    }
    .ui-card:hover { box-shadow: var(--shadow-focus); transform: translateY(-4px); transition: transform var(--motion-fast) ease, box-shadow var(--motion-fast) ease; }
    .ui-card:hover .card-copy-btn{ display:block; }
    
    
    
  "))
}










##############################
#         Barplot
##############################

barplot_ui <- function(id) {
  ns <- NS(id)

  tags$div(
    id = ns("container"),
    class = "barplot-container",
    uiOutput(ns("barplot"))
  )
}

barplot_css <- function(){
  tags$style(HTML("
  

    .barplot-container{
      width: 100%;
      height: var(--svg-h);   /* <-- clé : hauteur réelle */
      min-height: 80px;       /* garde-fou */
    }
    
    

    .dribble-bar {
      fill: url(#barGradient);
      transition: transform 0.2s ease, filter 0.2s ease;
      transform-box: fill-box;
      transform-origin: center bottom;
      animation: barGrow 520ms cubic-bezier(.2,.8,.2,1);
    }
    .dribble-bar:hover {
      filter: brightness(1.05) saturate(1.1);
      transform: translateY(-2px);
    }

    .barplot-baseline {
      stroke: rgba(18,55,97,0.22);
      stroke-width: 1;
    }

    .dribble-label {
      font-size: 13px;
      font-weight: 500;
      letter-spacing: 0.02em;
      fill: #1f2d3d;
      text-anchor: middle;
      dominant-baseline: middle;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    }
    
    .dribble-year {
      font-size: 11px;
      fill: #7a8ca3;
      text-anchor: middle;
      dominant-baseline: middle;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      animation: fadeUp 480ms ease;
    }

    .dribble-label {
      animation: fadeUp 480ms ease;
    }

    @keyframes barGrow {
      from { transform: scaleY(0.05); opacity: 0.2; }
      to   { transform: scaleY(1); opacity: 1; }
    }

    @keyframes fadeUp {
      from { transform: translateY(5px); opacity: 0; }
      to   { transform: translateY(0); opacity: 1; }
    }
  "))
}

barplot_server <- function(id, data_r, style = c("executive", "compact", "minimal"), unit = "") {
  style <- match.arg(style)

  moduleServer(id, function(input, output, session) {

    # envoyer le ns correct au JS
    session$onFlushed(function() {
      session$sendCustomMessage(
        "measure_container",
        list(id = session$ns("container"))
      )
    }, once = TRUE)


    observeEvent(input$container_size, {

      width  <- input$container_size$width
      height <- input$container_size$height

      if (is.null(width) || width < 20) return()

      df <- data_r()
      values <- df$value
      labels <- df$year

      n <- length(values)
      max_val <- max(values)

      margin_top    <- height * 0.12
      margin_bottom <- height * 0.18
      margin_side   <- width  * 0.08

      usable_height <- height - margin_top - margin_bottom
      usable_width  <- width  - (margin_side * 2)

      bar_width <- usable_width / (n * 1.6)
      spacing   <- (usable_width - (n * bar_width)) / (n + 1)

      bars <- list()

      for(i in seq_along(values)) {
        bar_height <- (values[i] / max_val) * usable_height

        x <- margin_side + spacing * i + bar_width * (i - 1)
        y <- height - margin_bottom - bar_height

        bars[[length(bars)+1]] <- tagList(
          tags$rect(
            x = x, y = y,
            width = bar_width, height = bar_height,
            rx = if (style == "executive") min(bar_width * 0.18, 6) else min(bar_width/2, 12),
            class = "dribble-bar"
          ),
          tags$text(
            x = x + bar_width/2,
            y = y - height*0.04,
            class = "dribble-label",
            paste0(round(values[i],1), unit)
          ),
          tags$text(
            x = x + bar_width/2,
            y = height - height*0.04,
            class = "dribble-year",
            labels[i]
          )
        )
      }

      output$barplot <- renderUI({
        tags$svg(
          width = width,
          height = height,
          style = "overflow: visible;",
          viewBox = paste0("0 0 ", width, " ", height),
          preserveAspectRatio = "none",
          tags$defs(
            tags$linearGradient(
              id = "barGradient",
              x1 = "0%", y1 = "0%", x2 = "0%", y2 = "100%",
              tags$stop(offset = "0%", `stop-color` = "#2EB7F3"),
              tags$stop(offset = "100%", `stop-color` = "#0C74D1")
            )
          ),
          tags$line(
            x1 = margin_side,
            y1 = height - margin_bottom,
            x2 = width - margin_side,
            y2 = height - margin_bottom,
            class = "barplot-baseline"
          ),
          bars
        )
      })
    })
  })
}


















lineplot_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    id = ns("container"),
    class = "lineplot-container",
    uiOutput(ns("lineplot"))
  )
}

lineplot_css <- function(){
  tags$style(HTML("
    .lineplot-container{
      width: 100%;
      height: var(--svg-h);
      min-height: 120px;
    }

    .line-axis {
      stroke: rgba(18,55,97,0.18);
      stroke-width: 1;
    }

    .line-grid {
      stroke: rgba(18,55,97,0.10);
      stroke-width: 1;
      stroke-dasharray: 3 5;
    }

    .line-area {
      fill: url(#lineAreaGradient);
      opacity: 0.9;
      animation: areaReveal 680ms ease-out;
    }

    .line-trend {
      fill: none;
      stroke: #116AC4;
      stroke-width: 3;
      stroke-linecap: round;
      stroke-linejoin: round;
      stroke-dasharray: 1200;
      stroke-dashoffset: 1200;
      animation: lineDraw 900ms cubic-bezier(.2,.8,.2,1) forwards;
    }

    .line-point {
      fill: #ffffff;
      stroke: #116AC4;
      stroke-width: 2;
      transition: fill 0.12s ease, stroke-width 0.12s ease;
      animation: pointPop 560ms cubic-bezier(.2,.8,.2,1);
    }

    .line-point:hover {
      fill: #116AC4;
      stroke-width: 2.5;
    }

    .line-value {
      font-size: 12px;
      font-weight: 600;
      fill: #1f2d3d;
      text-anchor: middle;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      paint-order: stroke;
      stroke: rgba(255,255,255,0.85);
      stroke-width: 2px;
      stroke-linejoin: round;
    }

    .line-year {
      font-size: 11px;
      fill: #7a8ca3;
      text-anchor: middle;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      animation: fadeUp 480ms ease;
    }

    @media (prefers-reduced-motion: reduce) {
      .dribble-bar, .dribble-label, .dribble-year,
      .line-area, .line-trend, .line-point, .line-value, .line-year,
      .stack-bar, .stack-seg, .stack-total,
      .group-bar, .group-year {
        animation: none !important;
        transition: none !important;
      }
    }

    .line-value {
      animation: fadeUp 480ms ease;
    }

    @keyframes lineDraw {
      to { stroke-dashoffset: 0; }
    }

    @keyframes pointPop {
      from { opacity: 0; transform: scale(0.75); }
      to { opacity: 1; transform: scale(1); }
    }

    @keyframes areaReveal {
      from { opacity: 0; }
      to { opacity: 0.9; }
    }
  "))
}

lineplot_server <- function(id, data_r, style = c("executive", "compact", "minimal"), unit = "") {
  style <- match.arg(style)

  moduleServer(id, function(input, output, session) {
    session$onFlushed(function() {
      session$sendCustomMessage(
        "measure_container",
        list(id = session$ns("container"))
      )
    }, once = TRUE)

    observeEvent(input$container_size, {
      width  <- input$container_size$width
      height <- input$container_size$height

      if (is.null(width) || width < 20) return()

      df <- data_r()
      values <- df$value
      labels <- df$year
      n <- length(values)

      max_val <- max(values, na.rm = TRUE)
      min_val <- min(values, na.rm = TRUE)
      range_val <- max(max_val - min_val, 1e-9)

      margin_top <- height * 0.18
      margin_bottom <- height * 0.20
      margin_side <- width * 0.08

      usable_h <- height - margin_top - margin_bottom
      usable_w <- width - (margin_side * 2)

      x_seq <- seq(margin_side, margin_side + usable_w, length.out = n)
      y_seq <- height - margin_bottom - ((values - min_val) / range_val) * usable_h

      line_points <- paste(sprintf('%.2f,%.2f', x_seq, y_seq), collapse = ' ')
      area_points <- paste0(
        sprintf('%.2f,%.2f', x_seq[1], height - margin_bottom), ' ',
        line_points, ' ',
        sprintf('%.2f,%.2f', x_seq[n], height - margin_bottom)
      )

      output$lineplot <- renderUI({
        tags$svg(
          width = width,
          height = height,
          viewBox = paste0("0 0 ", width, " ", height),
          preserveAspectRatio = "none",
          tags$defs(
            tags$linearGradient(
              id = "lineAreaGradient",
              x1 = "0%", y1 = "0%", x2 = "0%", y2 = "100%",
              tags$stop(offset = "0%", `stop-color` = "rgba(46,183,243,0.36)"),
              tags$stop(offset = "100%", `stop-color` = "rgba(46,183,243,0.00)")
            )
          ),
          tags$line(
            x1 = margin_side,
            y1 = height - margin_bottom,
            x2 = width - margin_side,
            y2 = height - margin_bottom,
            class = "line-axis"
          ),
          tags$line(
            x1 = margin_side,
            y1 = height - margin_bottom - (usable_h * 0.5),
            x2 = width - margin_side,
            y2 = height - margin_bottom - (usable_h * 0.5),
            class = "line-grid"
          ),
          tags$line(
            x1 = margin_side,
            y1 = height - margin_bottom - usable_h,
            x2 = width - margin_side,
            y2 = height - margin_bottom - usable_h,
            class = "line-grid"
          ),
          tags$polygon(points = area_points, class = "line-area"),
          tags$polyline(points = line_points, class = "line-trend"),
          lapply(seq_len(n), function(i) {
            tagList(
              tags$circle(
                cx = x_seq[i],
                cy = y_seq[i],
                r = if (style == "compact") 4 else 5,
                class = "line-point",
                tags$title(paste0(labels[i], " : ", round(values[i], 1), unit))
              ),
              tags$text(
                x = x_seq[i],
                y = y_seq[i] - height * 0.04,
                class = "line-value",
                paste0(round(values[i], 1), unit)
              ),
              tags$text(
                x = x_seq[i],
                y = height - height * 0.04,
                class = "line-year",
                labels[i]
              )
            )
          })
        )
      })
    })
  })
}

special_kpi_ui <- function(id) {
  ns <- NS(id)

  tags$div(
    class = "special-kpi-wrap",
    uiOutput(ns("kpi_top")),
    uiOutput(ns("kpi_bottom"))
  )
}

special_kpi_css <- function() {
  tags$style(HTML("
    .special-kpi-wrap {
      width: 100%;
      height: 100%;
      min-height: 0;
      display: flex;
      flex-direction: column;
      gap: 10px;
      justify-content: flex-start;
      overflow: hidden;
      box-sizing: border-box;
    }

    .special-kpi-wrap > .shiny-html-output {
      flex: 1 1 auto;
      min-height: 0;
      display: block;
    }

    .special-kpi-panel {
      width: 100%;
      max-width: 100%;
      height: auto;
      border: 1px solid rgba(185, 198, 214, 0.55);
      border-radius: 12px;
      background: linear-gradient(180deg, rgba(255,255,255,0.55), rgba(255,255,255,0.38));
      overflow: hidden;
      box-sizing: border-box;
      min-height: 0;
      display: flex;
      flex-direction: column;
    }

    .special-kpi-panel table {
      width: 100%;
      max-width: 100%;
      table-layout: fixed;
      border-collapse: collapse;
      font-size: 10px;
      color: #263c56;
      margin: 0 auto;
    }

    .special-kpi-panel th,
    .special-kpi-panel td {
      padding: 5px 7px;
      border-bottom: 1px solid rgba(185, 198, 214, 0.35);
      vertical-align: middle;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .special-kpi-panel tr:last-child td { border-bottom: none; }

    .special-kpi-panel thead th {
      background: rgba(255,255,255,0.55);
      color: #223b57;
      font-weight: 600;
      text-align: right;
      font-size: 10px;
    }

    .special-kpi-panel thead th:first-child,
    .special-kpi-panel tbody td:first-child {
      text-align: left;
      font-weight: 500;
      color: #1f334d;
      width: 22%;
      min-width: 0;
    }

    .special-kpi-panel tbody td { text-align: right; }

    .special-kpi-variation {
      color: #0d47cf;
      font-weight: 700;
      white-space: nowrap;
    }

    .special-kpi-subtitle {
      padding: 7px 10px 0;
      color: #233c59;
      font-weight: 600;
      font-size: 11px;
    }

    .special-kpi-spark svg {
      display: block;
      margin: 0 auto;
    }

    .special-kpi-spark polyline {
      fill: none;
      stroke: #2f62f3;
      stroke-width: 1.7;
      stroke-linecap: round;
      stroke-linejoin: round;
    }

    .special-kpi-spark line {
      stroke: rgba(47,98,243,0.22);
      stroke-width: 1;
    }
  "))
}

special_kpi_server <- function(id, values_r, compare_r, unit = "€") {
  moduleServer(id, function(input, output, session) {

    format_num <- function(x, suffix = "") {
      ifelse(
        is.na(x),
        "-",
        paste0(format(round(x, 0), big.mark = " ", trim = TRUE), suffix)
      )
    }

    annual_variation <- function(v) {
      v <- as.numeric(v)
      v <- v[is.finite(v)]
      if (length(v) < 2 || v[1] <= 0) return(NA_real_)
      ( (v[length(v)] / v[1])^(1/(length(v)-1)) - 1 ) * 100
    }

    sparkline_svg <- function(v) {
      v <- as.numeric(v)
      if (length(v) < 2 || all(!is.finite(v))) return(tags$span("-"))

      xs <- seq(3, 47, length.out = length(v))
      mn <- min(v, na.rm = TRUE)
      mx <- max(v, na.rm = TRUE)
      rg <- ifelse(abs(mx - mn) < 1e-9, 1, (mx - mn))
      ys <- 17 - ((v - mn) / rg) * 14
      pts <- paste(sprintf('%.2f,%.2f', xs, ys), collapse = ' ')

      tags$svg(
        width = 54, height = 20, viewBox = "0 0 54 20",
        tags$line(x1 = 3, y1 = 17, x2 = 51, y2 = 17),
        tags$polyline(points = pts)
      )
    }

    output$kpi_top <- renderUI({
      df <- values_r()
      req(is.data.frame(df), ncol(df) >= 3)

      labels <- as.character(df[[1]])
      year_cols <- names(df)[2:ncol(df)]

      rows <- lapply(seq_len(nrow(df)), function(i) {
        vals <- as.numeric(df[i, year_cols, drop = TRUE])
        var <- annual_variation(vals)

        tagList(
          tags$tr(
            tags$td(labels[i]),
            lapply(vals, function(v) tags$td(format_num(v, unit))),
            tags$td(class = "special-kpi-spark", sparkline_svg(vals)),
            tags$td(class = "special-kpi-variation", ifelse(is.na(var), "-", paste0(sprintf('%.1f', var), " % / an")))
          )
        )
      })

      tags$div(
        class = "special-kpi-panel",
        tags$table(
          tags$thead(
            tags$tr(
              tags$th(""),
              lapply(year_cols, tags$th),
              tags$th(""),
              tags$th("Variation")
            )
          ),
          tags$tbody(rows)
        )
      )
    })

    output$kpi_bottom <- renderUI({
      df <- compare_r()
      req(is.data.frame(df), ncol(df) >= 3)

      labels <- as.character(df[[1]])
      c1 <- as.numeric(df[[2]])
      c2 <- as.numeric(df[[3]])
      diff <- ifelse(is.na(c2) | abs(c2) < 1e-9, NA_real_, ((c1 - c2) / c2) * 100)

      rows <- lapply(seq_len(nrow(df)), function(i) {
        tags$tr(
          tags$td(labels[i]),
          tags$td(format(round(c1[i], 1), nsmall = 1, trim = TRUE)),
          tags$td(format(round(c2[i], 1), nsmall = 1, trim = TRUE)),
          tags$td(class = "special-kpi-variation", ifelse(is.na(diff[i]), "-", paste0(sprintf('%.1f', diff[i]), " %")))
        )
      })

      tags$div(
        class = "special-kpi-panel",
        tags$div(class = "special-kpi-subtitle", "Comparaison au groupe"),
        tags$table(
          tags$thead(
            tags$tr(
              tags$th(""),
              tags$th("Moyenne collectivité"),
              tags$th("Moyenne groupe"),
              tags$th("Différence")
            )
          ),
          tags$tbody(rows)
        )
      )
    })
  })
}

summary_kpi_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    class = "summary-kpi-wrap",
    uiOutput(ns("fields")),
    uiOutput(ns("indicators"))
  )
}

summary_kpi_css <- function() {
  tags$style(HTML("
    .summary-kpi-wrap {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      gap: 12px;
      min-height: 0;
    }

    .summary-kpi-fields {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 8px 12px;
      padding: 10px 12px;
      border: 1px solid rgba(185, 198, 214, 0.50);
      border-radius: 12px;
      background: linear-gradient(180deg, rgba(255,255,255,0.60), rgba(255,255,255,0.42));
    }

    .summary-kpi-field {
      min-width: 0;
      display: flex;
      flex-direction: column;
      gap: 2px;
    }

    .summary-kpi-label {
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: .04em;
      color: #627890;
      font-weight: 600;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .summary-kpi-value {
      font-size: 12px;
      color: #1f334d;
      font-weight: 600;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .summary-kpi-indicators {
      border: 1px solid rgba(185, 198, 214, 0.50);
      border-radius: 12px;
      background: linear-gradient(180deg, rgba(255,255,255,0.55), rgba(255,255,255,0.38));
      overflow: hidden;
    }

    .summary-kpi-indicators table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
      font-size: 10px;
      color: #263c56;
    }

    .summary-kpi-indicators th,
    .summary-kpi-indicators td {
      padding: 6px 7px;
      border-bottom: 1px solid rgba(185, 198, 214, 0.35);
      text-align: right;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .summary-kpi-indicators tr:last-child td { border-bottom: none; }

    .summary-kpi-indicators thead th {
      background: rgba(255,255,255,0.55);
      color: #223b57;
      font-weight: 600;
      font-size: 10px;
    }

    .summary-kpi-indicators thead th:first-child,
    .summary-kpi-indicators tbody td:first-child {
      text-align: left;
      width: 22%;
      color: #1f334d;
      font-weight: 500;
    }

    .summary-kpi-var {
      color: #0d47cf;
      font-weight: 700;
    }

    .summary-kpi-spark svg { display: block; margin: 0 auto; }
    .summary-kpi-spark line { stroke: rgba(47,98,243,0.22); stroke-width: 1; }
    .summary-kpi-spark polyline {
      fill: none;
      stroke: #2f62f3;
      stroke-width: 1.7;
      stroke-linecap: round;
      stroke-linejoin: round;
    }
  "))
}

summary_kpi_server <- function(id, data_r, unit = "") {
  moduleServer(id, function(input, output, session) {

    sparkline_svg <- function(v) {
      v <- as.numeric(v)
      if (length(v) < 2 || all(!is.finite(v))) return(tags$span("-"))
      xs <- seq(3, 47, length.out = length(v))
      mn <- min(v, na.rm = TRUE)
      mx <- max(v, na.rm = TRUE)
      rg <- ifelse(abs(mx - mn) < 1e-9, 1, (mx - mn))
      ys <- 17 - ((v - mn) / rg) * 14
      pts <- paste(sprintf('%.2f,%.2f', xs, ys), collapse = ' ')
      tags$svg(width = 54, height = 20, viewBox = "0 0 54 20",
               tags$line(x1 = 3, y1 = 17, x2 = 51, y2 = 17),
               tags$polyline(points = pts))
    }

    output$fields <- renderUI({
      d <- data_r()
      fields <- d$fields
      req(is.data.frame(fields), ncol(fields) >= 2)

      items <- lapply(seq_len(min(nrow(fields), 10)), function(i) {
        tags$div(
          class = "summary-kpi-field",
          tags$div(class = "summary-kpi-label", as.character(fields[i, 1])),
          tags$div(class = "summary-kpi-value", as.character(fields[i, 2]))
        )
      })

      tags$div(class = "summary-kpi-fields", tagList(items))
    })

    output$indicators <- renderUI({
      d <- data_r()
      ind <- d$indicators
      req(is.data.frame(ind), ncol(ind) >= 3)

      labels <- as.character(ind[[1]])
      year_cols <- names(ind)[2:ncol(ind)]

      rows <- lapply(seq_len(min(3, nrow(ind))), function(i) {
        vals <- as.numeric(ind[i, year_cols, drop = TRUE])
        var <- if (length(vals) < 2 || is.na(vals[1]) || vals[1] == 0) {
          NA_real_
        } else {
          ((vals[length(vals)] / vals[1]) - 1) * 100
        }

        tags$tr(
          tags$td(labels[i]),
          lapply(vals, function(v) tags$td(ifelse(is.na(v), "-", paste0(format(round(v, 1), nsmall = 1, trim = TRUE), unit)))),
          tags$td(class = "summary-kpi-spark", sparkline_svg(vals)),
          tags$td(class = "summary-kpi-var", ifelse(is.na(var), "-", paste0(sprintf('%.1f', var), " %")))
        )
      })

      tags$div(
        class = "summary-kpi-indicators",
        tags$table(
          tags$thead(tags$tr(tags$th(""), lapply(year_cols, tags$th), tags$th(""), tags$th("Var."))),
          tags$tbody(rows)
        )
      )
    })
  })
}

global_score_kpi_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    class = "global-score-kpi",
    uiOutput(ns("score"))
  )
}

global_score_kpi_css <- function() {
  tags$style(HTML("
    .global-score-kpi {
      width: 100%;
      height: 100%;
      min-height: 0;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .global-score-kpi-panel {
      padding: 4px 2px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .global-score-kpi-years {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 10px;
    }

    .global-score-kpi-year {
      border-radius: 10px;
      border: 1px solid rgba(185, 198, 214, 0.38);
      background: rgba(255,255,255,0.38);
      padding: 8px 6px;
      text-align: center;
      min-width: 0;
      transition: transform .2s ease, border-color .2s ease, box-shadow .2s ease;
    }

    .global-score-kpi-year:hover {
      transform: translateY(-1px);
      border-color: rgba(107, 130, 158, 0.55);
    }

    .global-score-kpi-year .val {
      color: #1f334d;
      font-weight: 650;
      font-size: 15px;
      line-height: 1.1;
    }

    .global-score-kpi-year .lab {
      margin-top: 3px;
      color: #6d8096;
      font-size: 10px;
      font-weight: 600;
      letter-spacing: .02em;
    }

    .global-score-kpi-year.is-latest {
      border: 2px solid rgba(47, 98, 243, 0.82);
      background: linear-gradient(180deg, rgba(239, 246, 255, 0.82), rgba(232, 241, 255, 0.64));
      box-shadow: 0 6px 16px rgba(47, 98, 243, 0.16);
    }

    .global-score-kpi-axis-wrap {
      margin-top: 3px;
      padding: 2px 2px 0;
    }

    .global-score-kpi-axis-head {
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: #60758d;
      font-size: 9px;
      font-weight: 700;
      margin-bottom: 2px;
    }

    .global-score-kpi-axis {
      position: relative;
      height: 26px;
      display: flex;
      align-items: center;
    }

    .global-score-kpi-axis-line {
      width: 100%;
      height: 2px;
      background: #7d90a6;
      border-radius: 2px;
      opacity: 0.75;
    }


    .global-score-kpi-axis-scale {
      position: absolute;
      left: 0;
      right: 0;
      top: 1px;
      display: grid;
      grid-template-columns: repeat(10, minmax(0, 1fr));
      font-size: 8px;
      font-weight: 600;
      color: #7086a0;
      pointer-events: none;
    }

    .global-score-kpi-axis-scale span {
      text-align: center;
      line-height: 1;
    }

    .global-score-kpi-axis-marker {
      position: absolute;
      top: 50%;
      width: 10px;
      height: 10px;
      border-radius: 2px;
      border: 2px solid #ffffff;
      background: #2f62f3;
      transform: translate(-50%, -50%) rotate(45deg);
      box-shadow: 0 2px 8px rgba(47,98,243,0.3);
    }

    .global-score-kpi-axis-labels {
      margin-top: 4px;
      display: flex;
      justify-content: space-between;
      gap: 10px;
      font-size: 9px;
      color: #4a617d;
      font-weight: 600;
    }

    @media (max-width: 1000px) {
      .global-score-kpi-years { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    }
  "))
}

global_score_kpi_server <- function(id, data_r, unit = "/10") {
  moduleServer(id, function(input, output, session) {
    output$score <- renderUI({
      df <- data_r()
      req(is.data.frame(df), ncol(df) >= 2, nrow(df) >= 1)

      labels <- as.character(df[[1]])
      values <- as.numeric(df[[2]])
      keep <- is.finite(values)
      labels <- labels[keep]
      values <- values[keep]
      req(length(values) >= 1)

      n <- min(4, length(values))
      labels <- tail(labels, n)
      values <- tail(values, n)
      latest_idx <- length(values)

      latest <- values[latest_idx]
      marker_left <- max(0, min(100, (latest / 10) * 100))

      year_items <- lapply(seq_along(values), function(i) {
        cls <- if (i == latest_idx) "global-score-kpi-year is-latest" else "global-score-kpi-year"
        tags$div(
          class = cls,
          tags$div(class = "val", paste0(sprintf("%.1f", values[i]), unit)),
          tags$div(class = "lab", labels[i])
        )
      })

      tags$div(
        class = "global-score-kpi-panel",
        tags$div(class = "global-score-kpi-years", tagList(year_items)),
        tags$div(
          class = "global-score-kpi-axis-wrap",
          tags$div(class = "global-score-kpi-axis-head", tags$span("1"), tags$span("10")),
          tags$div(
            class = "global-score-kpi-axis",
            tags$div(class = "global-score-kpi-axis-scale", lapply(1:10, function(i) tags$span(i))),
            tags$div(class = "global-score-kpi-axis-line"),
            tags$div(class = "global-score-kpi-axis-marker", style = paste0("left:", sprintf("%.1f", marker_left), "%;"))
          ),
          tags$div(
            class = "global-score-kpi-axis-labels",
            tags$span("Moins sinistré du groupe"),
            tags$span("Plus sinistré du groupe")
          )
        )
      )
    })
  })
}

france_map_kpi_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    class = "fr-map-kpi-wrap",
    plotOutput(ns("map"), height = "100%"),
    uiOutput(ns("legend"))
  )
}

france_map_kpi_css <- function() {
  tags$style(HTML("
    .fr-map-kpi-wrap {
      position: relative;
      width: 100%;
      height: 100%;
      min-height: 0;
      border-radius: 12px;
      overflow: hidden;
      background: linear-gradient(180deg, rgba(255,255,255,0.55), rgba(244,248,255,0.42));
      border: 1px solid rgba(185, 198, 214, 0.42);
    }

    .fr-map-kpi-legend {
      position: absolute;
      right: 12px;
      top: 12px;
      padding: 7px 9px;
      border-radius: 8px;
      background: rgba(255,255,255,0.86);
      border: 1px solid rgba(185, 198, 214, 0.5);
      font-size: 10px;
      color: #314965;
      pointer-events: none;
      line-height: 1.35;
      box-shadow: 0 4px 14px rgba(24, 60, 108, 0.08);
    }

    .fr-map-kpi-legend .v {
      display: inline-block;
      min-width: 44px;
      font-weight: 700;
      color: #12345a;
    }
  "))
}

france_map_kpi_server <- function(id, data_r) {
  moduleServer(id, function(input, output, session) {
    shp_cache <- reactiveVal(NULL)

    normalize_geometries <- function(sf_obj) {
      if (!inherits(sf_obj, "sf")) return(sf_obj)

      sf_obj <- sf::st_make_valid(sf_obj)
      if (any(!sf::st_is_valid(sf_obj))) {
        sf_obj <- sf::st_buffer(sf_obj, 0)
      }

      sf_obj
    }

    get_shape <- function(path) {
      cached <- shp_cache()
      if (!is.null(cached)) return(cached)

      shp <- tryCatch({
        sf::st_read(path, quiet = TRUE)
      }, error = function(e) NULL)
      validate(need(!is.null(shp), "Impossible de charger le fichier départements (GeoJSON)."))

      if (!"code" %in% names(shp)) {
        code_col <- names(shp)[grep("^code$|code_dep|insee|dep", names(shp), ignore.case = TRUE)][1]
        validate(need(!is.na(code_col), "Colonne code département introuvable dans le GeoJSON."))
        names(shp)[names(shp) == code_col] <- "code"
      }
      shp$code <- as.character(shp$code)
      shp <- normalize_geometries(shp)
      shp_cache(shp)
      shp
    }

    plot_width <- reactive({
      w <- session$clientData[[paste0("output_", session$ns("map"), "_width")]]
      if (!is.numeric(w) || is.na(w) || w < 80) 400 else w
    })

    plot_height <- reactive({
      h <- session$clientData[[paste0("output_", session$ns("map"), "_height")]]
      if (!is.numeric(h) || is.na(h) || h < 80) 300 else h
    })

    output$map <- renderPlot(
      {
        d <- data_r()
        req(is.list(d), !is.null(d$geojson_path), !is.null(d$values), !is.null(d$dept_code))

        shp <- get_shape(d$geojson_path)
        vals <- d$values
        validate(need(is.data.frame(vals), ncol(vals) >= 2, "Table de valeurs invalide"))
        names(vals)[1:2] <- c("code", "value")
        vals$code <- as.character(vals$code)
        vals$value <- as.numeric(vals$value)

        map_df <- merge(shp, vals, by = "code", all.x = TRUE)
        map_df <- normalize_geometries(map_df)
        target <- as.character(d$dept_code)[1]

        target_sf <- map_df[map_df$code == target, ]
        validate(need(nrow(target_sf) == 1, paste0("Département cible introuvable: ", target)))

        map_ops <- map_df
        if (isTRUE(sf::st_is_longlat(map_ops))) {
          map_ops <- sf::st_transform(map_ops, 2154)
        }

        target_ops <- map_ops[map_ops$code == target, ]
        nb_mask <- lengths(sf::st_touches(map_ops, target_ops, sparse = TRUE)) > 0

        map_ops$zone <- "Autres"
        map_ops$zone[nb_mask] <- "Limitrophes"
        map_ops$zone[map_ops$code == target] <- "Cible"

        base_col <- rep("#E2E8F0", nrow(map_ops))
        base_col[map_ops$zone == "Limitrophes"] <- "#D1D9E8"
        base_col[map_ops$zone == "Cible"] <- "#CFE2FF"

        val_range <- range(vals$value, na.rm = TRUE)
        has_vals <- all(is.finite(val_range))
        pal <- grDevices::colorRampPalette(c("#CFE2FF", "#13A3E8", "#0057B8"))(100)
        idx <- if (has_vals) {
          pmax(1, pmin(100, round((map_ops$value - val_range[1]) / max(1e-9, diff(val_range)) * 99) + 1))
        } else {
          rep(1, nrow(map_ops))
        }

        fill_col <- base_col
        mask <- map_ops$zone %in% c("Cible", "Limitrophes") & !is.na(map_ops$value)
        fill_col[mask] <- pal[idx[mask]]

        par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
        plot(sf::st_geometry(map_ops), col = fill_col, border = "#FFFFFF", lwd = 0.6)
        plot(sf::st_geometry(target_ops), add = TRUE, border = "#FF3B30", lwd = 1.8)

        target_cent <- sf::st_coordinates(sf::st_point_on_surface(sf::st_geometry(target_ops)))[1, ]
        target_val <- map_ops$value[map_ops$code == target][1]
        lbl <- if (is.finite(target_val)) paste0(target, "\n", sprintf("%.2f%%", target_val)) else paste0(target, "\nNA")
        text(target_cent[1], target_cent[2], labels = lbl, cex = 0.85, font = 2, col = "#102A43")
      },
      width = function() plot_width(),
      height = function() plot_height(),
      res = 96
    )

    output$legend <- renderUI({
      d <- data_r()
      vals <- d$values
      req(is.data.frame(vals), ncol(vals) >= 2)
      v <- as.numeric(vals[[2]])
      v <- v[is.finite(v)]
      if (!length(v)) {
        return(tags$div(class = "fr-map-kpi-legend", "Aucune valeur disponible"))
      }
      tags$div(
        class = "fr-map-kpi-legend",
        tags$div(tags$span(class = "v", sprintf("%.2f%%", min(v))), "Min"),
        tags$div(tags$span(class = "v", sprintf("%.2f%%", mean(v))), "Moyenne"),
        tags$div(tags$span(class = "v", sprintf("%.2f%%", max(v))), "Max")
      )
    })
  })
}

binary_kpi_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    class = "binary-kpi-wrap",
    uiOutput(ns("table"))
  )
}

binary_kpi_css <- function() {
  tags$style(HTML("
    .binary-kpi-wrap {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
    }

    .binary-kpi-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0 10px;
      table-layout: fixed;
      color: #2a3f58;
      font-size: 11px;
    }

    .binary-kpi-table th,
    .binary-kpi-table td {
      text-align: center;
      padding: 3px 4px;
      vertical-align: middle;
    }

    .binary-kpi-table thead th {
      font-size: 11px;
      font-weight: 600;
      color: #607891;
      letter-spacing: 0.02em;
      padding-bottom: 6px;
    }

    .binary-kpi-label {
      text-align: left !important;
      width: 100px;
      font-weight: 600;
      color: #30465f;
      padding-right: 8px;
      white-space: nowrap;
    }

    .binary-kpi-cell {
      position: relative;
      height: 22px;
      border-radius: 8px;
      border: 1px solid rgba(149, 168, 190, 0.45);
      background: rgba(246, 250, 255, 0.65);
      overflow: hidden;
      box-shadow: inset 0 1px 0 rgba(255,255,255,0.7);
      transition: transform .16s ease, filter .16s ease, box-shadow .16s ease;
      animation: binaryCellPop 420ms cubic-bezier(.2,.8,.2,1);
      animation-delay: var(--cell-delay, 0ms);
      animation-fill-mode: both;
    }

    .binary-kpi-cell::after {
      content: '';
      position: absolute;
      inset: 0;
      border-radius: inherit;
      opacity: 0.16;
      pointer-events: none;
      background: linear-gradient(180deg, rgba(255,255,255,0.55), rgba(255,255,255,0));
    }

    .binary-kpi-cell.value-1 {
      background: linear-gradient(135deg, #13A3E8, #49BDF0);
      border-color: rgba(11, 122, 180, 0.76);
      box-shadow: 0 6px 16px rgba(19, 163, 232, 0.24);
    }

    .binary-kpi-cell.value-0 {
      background: linear-gradient(135deg, rgba(126, 129, 158, 0.62), rgba(166, 170, 196, 0.62));
      border-color: rgba(112, 115, 144, 0.52);
      box-shadow: 0 4px 12px rgba(101, 104, 132, 0.16);
      opacity: 0.68;
    }

    .binary-kpi-cell:hover {
      transform: translateY(-1px);
      filter: saturate(1.03);
    }

    @keyframes binaryCellPop {
      from { opacity: 0; transform: translateY(4px) scale(0.98); }
      to { opacity: 1; transform: translateY(0) scale(1); }
    }

    @media (prefers-reduced-motion: reduce) {
      .binary-kpi-cell { animation: none !important; transition: none !important; }
    }
  "))
}

binary_kpi_server <- function(id, data_r) {
  moduleServer(id, function(input, output, session) {
    output$table <- renderUI({
      df <- data_r()
      req(is.data.frame(df), ncol(df) >= 2)

      row_labels <- as.character(df[[1]])
      year_cols <- names(df)[2:ncol(df)]
      mat <- as.data.frame(df[, year_cols, drop = FALSE])

      rows <- lapply(seq_len(nrow(mat)), function(i) {
        vals <- as.numeric(mat[i, , drop = TRUE])
        tags$tr(
          tags$td(class = "binary-kpi-label", row_labels[i]),
          lapply(seq_along(vals), function(j) {
            v <- ifelse(is.na(vals[j]), 0, ifelse(vals[j] >= 0.5, 1, 0))
            tags$td(
              tags$div(
                class = paste("binary-kpi-cell", paste0("value-", v)),
                style = paste0("--cell-delay:", (i * 40 + j * 30), "ms;")
              )
            )
          })
        )
      })

      tags$table(
        class = "binary-kpi-table",
        tags$thead(
          tags$tr(
            tags$th(""),
            lapply(year_cols, tags$th)
          )
        ),
        tags$tbody(rows)
      )
    })
  })
}

multilineplot_ui <- function(id) {
  ns <- NS(id)

  tags$div(
    class = "multilineplot-shell",
    tags$div(
      class = "multilineplot-row",
      tags$div(
        class = "multilineplot-legend-side",
        uiOutput(ns("legend"))
      ),
      tags$div(
        id = ns("container"),
        class = "multilineplot-container",
        uiOutput(ns("multilineplot")),
        tags$div(id = ns("tooltip"), class = "multiline-tooltip")
      )
    )
  )
}

multilineplot_css <- function(){
  tags$style(HTML("
    .multilineplot-shell {
      width: 100%;
      height: var(--svg-h);
      min-height: 140px;
    }

    .multilineplot-row {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: row;
      align-items: stretch;
      gap: 18px;
    }

    .multilineplot-container{
      width: 100%;
      flex: 1 1 auto;
      min-height: 120px;
      border-radius: 12px;
      background: linear-gradient(180deg, rgba(255,255,255,0.28), rgba(255,255,255,0.10));
      position: relative;
    }

    .multilineplot-legend-side {
      flex: 0 0 110px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: flex-start;
      color: #5c6f85;
      font-size: 11px;
    }

    .multilineplot-legend-side .shiny-html-output {
      width: 100%;
    }

    .multiline-legend {
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      gap: 10px;
      min-height: 24px;
    }

    .multiline-legend-item {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 11px;
      color: #5c6f85;
      font-weight: 400;
      line-height: 1.2;
    }

    .multiline-legend-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      display: inline-block;
      flex-shrink: 0;
      margin-right: 6px;
      box-shadow: 0 0 0 1px rgba(255,255,255,0.70);
    }

    .multiline-tooltip {
      position: absolute;
      pointer-events: none;
      background: rgba(255,255,255,0.96);
      border: 1px solid var(--stroke-strong);
      padding: 10px 12px;
      border-radius: 10px;
      box-shadow: var(--shadow-soft);
      backdrop-filter: blur(8px);
      display: none;
      z-index: 999;
      min-width: 150px;
      transform: translate(-50%, calc(-100% - 12px));
      font-size: 12px;
      color: #1f2d3d;
    }

    .multiline-tooltip-title {
      display: flex;
      align-items: center;
      gap: 7px;
      font-weight: 600;
      margin-bottom: 4px;
    }

    .multiline-tooltip-dot {
      width: 9px;
      height: 9px;
      border-radius: 50%;
      display: inline-block;
      flex-shrink: 0;
    }

    .multiline-tooltip-value {
      color: #4f647d;
      font-weight: 500;
    }

    .multiline-axis {
      stroke: rgba(18,55,97,0.20);
      stroke-width: 1;
    }

    .multiline-grid {
      stroke: rgba(18,55,97,0.10);
      stroke-width: 1;
      stroke-dasharray: 3 6;
    }

    .multiline-track {
      fill: none;
      stroke-width: 9;
      stroke-linecap: round;
      stroke-linejoin: round;
      opacity: 0.16;
      filter: blur(3px);
      animation: multiLineDraw 950ms cubic-bezier(.2,.8,.2,1) forwards;
      stroke-dasharray: 1400;
      stroke-dashoffset: 1400;
    }

    .multiline-line {
      fill: none;
      stroke-width: 3.2;
      stroke-linecap: round;
      stroke-linejoin: round;
      animation: multiLineDraw 950ms cubic-bezier(.2,.8,.2,1) forwards;
      stroke-dasharray: 1400;
      stroke-dashoffset: 1400;
    }

    .multiline-line-hit {
      fill: none;
      stroke: transparent;
      stroke-width: 14;
      stroke-linecap: round;
      stroke-linejoin: round;
      cursor: pointer;
    }

    .multiline-point {
      stroke: #ffffff;
      stroke-width: 1.8;
      transition: r 0.14s ease, stroke-width 0.14s ease, filter 0.14s ease;
      animation: pointPopMulti 520ms cubic-bezier(.2,.8,.2,1);
    }

    .multiline-point:hover {
      r: 6.5;
      stroke-width: 2.5;
      filter: brightness(1.04);
    }

    .multiline-year {
      font-size: 11px;
      fill: #7a8ca3;
      text-anchor: middle;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      animation: fadeUpMulti 420ms ease;
    }

    .multiline-yhint {
      font-size: 10px;
      fill: #8fa0b5;
      text-anchor: end;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      animation: fadeUpMulti 420ms ease;
    }

    @keyframes multiLineDraw {
      to { stroke-dashoffset: 0; }
    }

    @keyframes pointPopMulti {
      from { opacity: 0; transform: scale(0.7); }
      to { opacity: 1; transform: scale(1); }
    }

    @keyframes fadeUpMulti {
      from { opacity: 0; transform: translateY(5px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @media (prefers-reduced-motion: reduce) {
      .multiline-track,
      .multiline-line,
      .multiline-point,
      .multiline-year,
      .multiline-yhint {
        animation: none !important;
        transition: none !important;
      }
    }
  "))
}

multilineplot_server <- function(id, data_r, style = c("executive", "compact", "minimal"), unit = "") {
  style <- match.arg(style)

  moduleServer(id, function(input, output, session) {
    session$onFlushed(function() {
      session$sendCustomMessage(
        "measure_container",
        list(id = session$ns("container"))
      )
    }, once = TRUE)

    observeEvent(input$container_size, {
      width  <- input$container_size$width
      height <- input$container_size$height

      if (is.null(width) || width < 20) return()

      df <- data_r()
      req(ncol(df) >= 2)

      years <- as.character(df[[1]])
      series_names <- names(df)[2:ncol(df)]
      max_series <- min(6, length(series_names))
      series_names <- series_names[seq_len(max_series)]

      mat <- as.matrix(df[, series_names, drop = FALSE])
      suppressWarnings(storage.mode(mat) <- "numeric")
      if (all(is.na(mat))) return()

      min_val <- min(mat, na.rm = TRUE)
      max_val <- max(mat, na.rm = TRUE)

      n <- nrow(mat)
      if (n < 2) return()

      # Axe Y : 5 lignes avec arrondis (multiples de 10) selon la plage observée
      raw_min <- min_val
      raw_max <- max_val
      if (!is.finite(raw_min) || !is.finite(raw_max)) return()
      if (raw_min == raw_max) raw_max <- raw_min + 10

      approx_step <- (raw_max - raw_min) / 4
      step <- max(10, ceiling(approx_step / 10) * 10)

      axis_max <- ceiling(raw_max / step) * step
      axis_min <- axis_max - (step * 4)
      while (axis_min > raw_min) {
        axis_min <- axis_min - step
        axis_max <- axis_max - step
      }

      axis_ticks <- seq(axis_min, axis_max, by = step)
      axis_range <- max(axis_max - axis_min, 1e-9)

      margin_top <- height * 0.14
      margin_bottom <- height * 0.20
      margin_side <- width * 0.08

      usable_h <- height - margin_top - margin_bottom
      usable_w <- width - (margin_side * 2)

      x_seq <- seq(margin_side, margin_side + usable_w, length.out = n)

      colors <- relyens_chart_colors(max_series)

      legend_tags <- lapply(seq_along(series_names), function(i) {
        tags$span(
          class = "multiline-legend-item",
          tags$span(class = "multiline-legend-dot", style = paste0("background:", colors[i], ";")),
          tags$span(class = "multiline-legend-name", series_names[i])
        )
      })
      output$legend <- renderUI(tags$div(class = "multiline-legend", tagList(legend_tags)))

      output$multilineplot <- renderUI({
        tooltip_js <- sprintf("(function(){
  var container = document.getElementById('%s');
  var tooltip = document.getElementById('%s');
  if (!container || !tooltip) return;

  function setTooltipContent(color, title, valueText){
    var valueHtml = valueText ? ('<div class=\"multiline-tooltip-value\">' + valueText + '</div>') : '';
    tooltip.innerHTML = '<div class=\"multiline-tooltip-title\"><span class=\"multiline-tooltip-dot\" style=\"background:' + color + ';\"></span>' + title + '</div>' + valueHtml;
  }

  function moveTooltip(ev){
    var r = container.getBoundingClientRect();
    tooltip.style.left = (ev.clientX - r.left) + 'px';
    tooltip.style.top = (ev.clientY - r.top) + 'px';
  }

  function bindHover(nodes, build){
    nodes.forEach(function(node){
      node.addEventListener('mouseenter', function(ev){
        var info = build(node);
        setTooltipContent(info.color, info.title, info.valueText);
        tooltip.style.display = 'block';
        moveTooltip(ev);
      });
      node.addEventListener('mousemove', moveTooltip);
      node.addEventListener('mouseleave', function(){
        tooltip.style.display = 'none';
      });
    });
  }

  bindHover(container.querySelectorAll('.multiline-point'), function(pt){
    var color = pt.getAttribute('data-color') || '#116AC4';
    var series = pt.getAttribute('data-series') || '';
    var year = pt.getAttribute('data-year') || '';
    var value = pt.getAttribute('data-value') || '';
    return {
      color: color,
      title: series + ' · ' + year,
      valueText: 'Valeur : ' + value
    };
  });

  bindHover(container.querySelectorAll('.multiline-line-hit'), function(line){
    var color = line.getAttribute('data-color') || '#116AC4';
    var series = line.getAttribute('data-series') || '';
    return {
      color: color,
      title: series,
      valueText: 'Série'
    };
  });
})();", session$ns("container"), session$ns("tooltip"))

        tagList(
          tags$svg(
            width = width,
            height = height,
            viewBox = paste0("0 0 ", width, " ", height),
            preserveAspectRatio = "none",

            lapply(seq_along(axis_ticks), function(i) {
              tick <- axis_ticks[i]
              y <- height - margin_bottom - ((tick - axis_min) / axis_range) * usable_h
              tick_label <- if (abs(tick - round(tick)) < 1e-9) {
                paste0(sprintf("%.0f", tick), unit)
              } else {
                paste0(sprintf("%.1f", tick), unit)
              }

              tagList(
                tags$line(
                  x1 = margin_side,
                  y1 = y,
                  x2 = width - margin_side,
                  y2 = y,
                  class = if (i == 1) "multiline-axis" else "multiline-grid"
                ),
                tags$text(
                  x = margin_side - 6,
                  y = y + 3,
                  class = "multiline-yhint",
                  tick_label
                )
              )
            }),

            lapply(seq_along(series_names), function(i) {
              values <- mat[, i]
              y_seq <- height - margin_bottom - ((values - axis_min) / axis_range) * usable_h
              points <- paste(sprintf('%.2f,%.2f', x_seq, y_seq), collapse = ' ')

              tagList(
                tags$polyline(points = points, class = "multiline-track", style = paste0("stroke:", colors[i], ";")),
                tags$polyline(points = points, class = "multiline-line", style = paste0("stroke:", colors[i], ";")),
                tags$polyline(
                  points = points,
                  class = "multiline-line-hit",
                  `data-series` = series_names[i],
                  `data-color` = colors[i]
                ),
                lapply(seq_len(n), function(j) {
                  tags$circle(
                    cx = x_seq[j],
                    cy = y_seq[j],
                    r = if (style == "compact") 3.5 else 4.2,
                    class = "multiline-point",
                    fill = colors[i],
                    `data-series` = series_names[i],
                    `data-year` = years[j],
                    `data-value` = paste0(round(values[j], 1), unit),
                    `data-color` = colors[i]
                  )
                })
              )
            }),

            lapply(seq_len(n), function(j) {
              tags$text(
                x = x_seq[j],
                y = height - height * 0.04,
                class = "multiline-year",
                years[j]
              )
            })
          ),
          tags$script(HTML(tooltip_js))
        )
      })
    })
  })
}

#######################
#Stacked Barplot
######################


stackedBar_ui <- function(id) {
  ns <- NS(id)
  
  tags$div(
    class="stacked-wrapper",
    
    tags$div(
      class="stack-legend-vertical",
      uiOutput(ns("legend"))
    ),
    
    tags$div(
      class="stacked-graph",
      uiOutput(ns("bars")),
      tags$div(id = ns("tooltip"), class = "stack-tooltip")
    )
  )
}



stackedBar_html_css <- function() {
  tags$style(HTML("

/* ============================= */
/* LAYOUT GLOBAL                 */
/* ============================= */

.stacked-wrapper{
  display: flex;
  flex-direction: row;
  width: 100%;
  height: 100%;
  gap: 32px;
}

/* ============================= */
/* LEGEND                        */
/* ============================= */

.stack-legend-vertical{
  flex: 0 0 110px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 10px;
  font-size: 11px;
  color: #5c6f85;
}

.legend-item{
  display: flex;
  align-items: center;
  gap: 8px;
}

.legend-color{
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
  margin-right:6px;
}

/* ============================= */
/* GRAPH CONTAINER               */
/* ============================= */
/*
.stacked-graph{
  flex: 1 1 auto;
  position: relative;
  display: flex;
  height: 220px;   
}
  */
.stacked-graph{
  flex: 1 1 auto;
  position: relative;
  display: flex;
  border-radius: 12px;
  background: linear-gradient(180deg, rgba(255,255,255,0.34), rgba(255,255,255,0.10));
  height: calc(
    var(--card-h)
    - (var(--card-pad) * 2)
    - var(--header-min)
    - var(--header-gap)
  );
}


/* IMPORTANT : wrapper shiny */
.stacked-graph > .shiny-html-output{
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  justify-content: space-evenly;
  gap: 32px;
  width: 100%;
  height: 100%;
}


/* ============================= */
/* COLUMN                        */
/* ============================= */

/*.stack-col{
  position: relative;

  display: flex;
  flex-direction: column;
  align-items: center;
  height: 100%;
  flex: 1 1 0;
  max-width: 90px;
}*/


.stack-col{
  display:flex;
  flex-direction:column;
  align-items:center;
  height:100%;
  flex:1 1 0;
  max-width:90px;
}



/* ============================= */
/* BAR                           */
/* ============================= */

.stack-plot{
  position:relative;
  width:100%;
  height:100%;          /* AJOUT IMPORTANT */
  display:flex;
  align-items:flex-end;
}

.stack-bar{
  display:flex;
  position:relative;
  flex-direction:column-reverse;
  width:100%;
  transform-origin: center bottom;
  animation: stackGrow 620ms cubic-bezier(.2,.8,.2,1);
}


/* segments */
.stack-seg{
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 700;
  color: white;
  transition: transform .2s ease;
  animation: fadeInSeg 420ms ease;
}


.stack-seg:first-child{
  border-bottom-left-radius:3px;
  border-bottom-right-radius:3px;
}

.stack-seg:last-child{
  border-top-left-radius:6px;
  border-top-right-radius:6px;
}

.stack-seg:hover{
  filter: brightness(1.05);
  transform:translateY(-1px);
  box-shadow:0 8px 20px rgba(0,0,0,0.15);
}

/* year label */
.stack-year{
  margin-top: 8px;
  font-size: 11px;
  color: #7a8ca3;
  text-align: center;
}


.stack-total{
  position: absolute;
  bottom: 100%;         /* au sommet réel de la barre */
  left: 0;
  width: 100%;
  margin-bottom: 6px;
  text-align: center;
  font-size: 12px;
  font-weight: 700;
  color: #1f2d3d;
  animation: fadeUp 520ms ease;
}

@keyframes stackGrow {
  from { transform: scaleY(0.05); opacity: 0.25; }
  to { transform: scaleY(1); opacity: 1; }
}

@keyframes fadeInSeg {
  from { opacity: 0.1; }
  to { opacity: 1; }
}

/* ============================= */
/* TOOLTIP                       */
/* ============================= */

.stack-tooltip{
  position: absolute;
  pointer-events: none;
  background: rgba(255,255,255,0.96);
  border: 1px solid var(--stroke-strong);
  padding: 12px 14px;
  border-radius: 10px;
  font-size: 12px;
  box-shadow: var(--shadow-soft);
  backdrop-filter: blur(8px);
  display: none;
  z-index: 999;
  min-width: 170px;
}

.tooltip-title{
  font-weight: 600;
  margin-bottom: 6px;
}

.tooltip-line{
  display: flex;
  justify-content: space-between;
  margin-bottom: 4px;
}

.tooltip-dot{
  width: 8px;
  height: 8px;
  border-radius: 50%;
  display: inline-block;
  margin-right: 6px;
}

"))
}


stackedBar_server <- function(id, data_r, unit = "") {
  
  moduleServer(id, function(input, output, session) {
    
    # -----------------------------
    # LEGEND
    # -----------------------------
    
    output$legend <- renderUI({
      
      df <- data_r()
      values <- df[, -1, drop = FALSE]
      vars <- colnames(values)
      k <- ncol(values)
      
      colors <- relyens_chart_colors(k)
      
      lapply(seq_len(k), function(i) {
        tags$div(
          class = "legend-item",
          tags$span(
            class = "legend-color",
            style = paste0("background:", colors[i])
          ),
          vars[i]
        )
      })
    })
    
    
    # -----------------------------
    # STACKED BARS
    # -----------------------------
    
    output$bars <- renderUI({
      
      df <- data_r()
      
      years  <- df$year
      values <- df[, -1, drop = FALSE]
      vars   <- colnames(values)
      
      totals    <- rowSums(values, na.rm = TRUE)
      max_total <- max(totals, na.rm = TRUE)
      
      n <- nrow(df)
      k <- ncol(values)
      
      colors <- relyens_chart_colors(k)
      
      tagList(
        
        lapply(seq_len(n), function(i) {
          
          total_val <- totals[i]
          
          # Hauteur globale de la barre vs max global
          total_height_pct <- if (max_total > 0) {
            (total_val / max_total) * 100
          } else {
            0
          }
          
          tags$div(
            class = "stack-col",
            
            tags$div(
              class = "stack-plot",
              
            
              
              # BAR CONTAINER (hauteur proportionnelle au total)
              tags$div(
                class = "stack-bar",
                style = paste0(
                  "height:", round(total_height_pct, 2), "%;"
                ),
                # TOTAL (au-dessus de la barre)
                tags$div(
                  class = "stack-total",
                  paste0(round(total_val, 1), unit)
                ),
                
                # SEGMENTS
                lapply(seq_len(k), function(j) {
                  
                  val <- values[i, j]
                  
                  segment_pct <- if (total_val > 0) {
                    (val / total_val) * 100
                  } else {
                    0
                  }
                  
                  tags$div(
                    class = "stack-seg",
                    style = paste0(
                      "height:", round(segment_pct, 2), "%;",
                      "background:", colors[j], ";"
                    ),
                    `data-index` = i,
                    `data-col`   = vars[j],
                    paste0(round(val, 1), unit)
                  )
                })
              )
            ),
            
            tags$div(class = "stack-year", years[i])
          )
        }),
        
        stackedBar_js(session$ns("tooltip"), df, unit)
      )
    })
    
  })
}




stackedBar_js <- function(id, df, unit){
  
  json <- jsonlite::toJSON(df, auto_unbox = TRUE, dataframe = "rows")
  
  tags$script(HTML(
    paste0("
    (function(){

      const tooltip = document.getElementById('", id, "');
      if(!tooltip) return;

      const graph = tooltip.closest('.stacked-graph');
      if(!graph) return;

      const data = ", json, ";
      const unit = '", unit, "';

      graph.querySelectorAll('.stack-seg').forEach(seg => {

        seg.addEventListener('mouseenter', function(e){

          const index = Number(this.dataset.index) - 1;
          const row = data[index];

          let total = 0;
          let html = `<div class='tooltip-title'>${row.year}</div>`;

          Object.keys(row).forEach(k => {

            if(k === 'year') return;

            const v = Number(row[k] || 0);
            total += v;

            html += `
              <div class='tooltip-line'>
                <span style='display:flex;align-items:center;gap:6px;'>
                  <span style='
                    width:8px;
                    height:8px;
                    border-radius:50%;
                    background:${getColor(index, k)};
                    display:inline-block;
                  '></span>
                  ${k}
                </span>
                <span>${v}${unit}</span>
              </div>
            `;
          });

          html += `
            <div class='tooltip-line'>
              <strong>Total</strong>
              <strong>${total}${unit}</strong>
            </div>
          `;

          tooltip.innerHTML = html;
          tooltip.style.display = 'block';
        });

        seg.addEventListener('mousemove', function(e){
          const rect = graph.getBoundingClientRect();
          tooltip.style.left = (e.clientX - rect.left + 15) + 'px';
          tooltip.style.top  = (e.clientY - rect.top - 10) + 'px';
        });

        seg.addEventListener('mouseleave', function(){
          tooltip.style.display = 'none';
        });

      });

      function getColor(rowIndex, colName){
        const seg = graph.querySelector(
          `.stack-seg[data-index='${rowIndex+1}'][data-col='${colName}']`
        );
        return seg ? getComputedStyle(seg).backgroundColor : '#999';
      }

    })();
    "
    )))
}


#######################
# Grouped Barplot UI
#######################

groupBar_ui <- function(id) {
  ns <- NS(id)
  
  tags$div(
    class="group-wrapper",
    
    tags$div(
      class="group-legend-vertical",
      uiOutput(ns("legend"))
    ),
    
    tags$div(
      class="group-graph",
      uiOutput(ns("bars")),
      tags$div(id = ns("tooltip"), class = "group-tooltip")
    )
  )
}


groupBar_html_css <- function() {
  tags$style(HTML("

/* ============================= */
/* LAYOUT GLOBAL                 */
/* ============================= */

.group-wrapper{
  display:flex;
  flex-direction:row;
  width:100%;
  height:100%;
  gap:32px;
}

/* ============================= */
/* LEGEND                        */
/* ============================= */

.group-legend-vertical{
  flex:0 0 110px;
  display:flex;
  flex-direction:column;
  justify-content:center;
  gap:10px;
  font-size:11px;
  color:#5c6f85;
}

.legend-item{
  display:flex;
  align-items:center;
  gap:6px;
}

.legend-color{
  width:8px;
  height:8px;
  border-radius:50%;
  flex-shrink:0;
  margin-right:6px;
}

/* ============================= */
/* GRAPH                         */
/* ============================= */

.group-graph{
  flex:1 1 auto;
  position:relative;
  display:flex;
  border-radius: 12px;
  background: linear-gradient(180deg, rgba(255,255,255,0.34), rgba(255,255,255,0.10));
  height:calc(
    var(--card-h)
    - (var(--card-pad) * 2)
    - var(--header-min)
    - var(--header-gap)
  );
}

.group-graph > .shiny-html-output{
  display:flex;
  align-items:flex-end;
  justify-content:space-evenly;
  gap:32px;
  width:100%;
  height:100%;
}

/* ============================= */
/* COLUMN (YEAR)                 */
/* ============================= */

.group-col{
  display:flex;
  flex-direction:column;
  align-items:center;
  height:100%;
  flex:1 1 0;
  max-width:120px;
}

/* ============================= */
/* BAR ZONE                      */
/* ============================= */

.group-plot{
  position:relative;
  width:100%;
  height:100%;
  display:flex;
  align-items:flex-end;
  justify-content:center;
}

.group-bars{
  display:flex;
  align-items:flex-end;
  gap:7px;
  width:100%;
  height:100%;
  justify-content:center;
}

/* ============================= */
/* BAR                           */
/* ============================= */

.group-bar{
  position:relative;
  width:20px;
  border-radius:5px 5px 1px 1px;
  border: 1px solid rgba(255,255,255,0.18);
  display:flex;
  align-items:flex-start;
  justify-content:center;
  font-size:10px;
  font-weight:600;
  color:white;
  transition:transform .2s ease;
  transform-origin: center bottom;
  animation: groupGrow 560ms cubic-bezier(.2,.8,.2,1);
}

.group-bar:hover{
  transform:translateY(-2px);
  box-shadow:0 10px 20px rgba(0,0,0,0.15);
}

/* year label */
.group-year{
  margin-top:8px;
  font-size:11px;
  color:#7a8ca3;
  text-align:center;
  animation: fadeUp 500ms ease;
}

@keyframes groupGrow {
  from { transform: scaleY(0.08); opacity: 0.25; }
  to { transform: scaleY(1); opacity: 1; }
}

/* ============================= */
/* TOOLTIP                       */
/* ============================= */

.group-tooltip{
  position:absolute;
  pointer-events:none;
  background:rgba(255,255,255,0.96);
  border: 1px solid var(--stroke-strong);
  padding:12px 14px;
  border-radius:10px;
  font-size:12px;
  box-shadow: var(--shadow-soft);
  backdrop-filter: blur(8px);
  display:none;
  z-index:999;
  min-width:170px;
}

.tooltip-title{
  font-weight:600;
  margin-bottom:6px;
}

.tooltip-line{
  display:flex;
  justify-content:space-between;
  margin-bottom:4px;
}

.tooltip-dot{
  width:8px;
  height:8px;
  border-radius:50%;
  display:inline-block;
  margin-right:6px;
}

"))
}



groupBar_server <- function(id, data_r, unit = "") {
  
  moduleServer(id, function(input, output, session) {
    
    output$legend <- renderUI({
      
      df <- data_r()
      values <- df[, -1, drop = FALSE]
      vars <- colnames(values)
      k <- ncol(values)
      
      colors <- relyens_chart_colors(k)
      
      lapply(seq_len(k), function(i) {
        tags$div(
          class="legend-item",
          tags$span(
            class="legend-color",
            style=paste0("background:", colors[i])
          ),
          vars[i]
        )
      })
    })
    
    
    output$bars <- renderUI({
      
      df <- data_r()
      
      years  <- df$year
      values <- df[, -1, drop = FALSE]
      vars   <- colnames(values)
      
      max_val <- max(values, na.rm = TRUE)
      
      n <- nrow(df)
      k <- ncol(values)
      
      colors <- relyens_chart_colors(k)
      
      tagList(
        
        lapply(seq_len(n), function(i) {
          
          tags$div(
            class="group-col",
            
            tags$div(
              class="group-plot",
              
              tags$div(
                class="group-bars",
                
                lapply(seq_len(k), function(j) {
                  
                  val <- values[i, j]
                  
                  height_pct <- if(max_val > 0){
                    (val / max_val) * 100
                  } else 0
                  
                  tags$div(
                    class="group-bar",
                    style=paste0(
                      "height:", round(height_pct,2), "%;",
                      "background:", colors[j], ";"
                    ),
                    `data-index` = i,
                    `data-col`   = vars[j],
                    paste0(round(val,1), unit)
                  )
                })
              )
            ),
            
            tags$div(class="group-year", years[i])
          )
        }),
        
        groupBar_js(session$ns("tooltip"), df, unit)
      )
    })
    
  })
}



groupBar_js <- function(id, df, unit){
  
  json <- jsonlite::toJSON(df, auto_unbox = TRUE, dataframe = "rows")
  
  tags$script(HTML(
    paste0("
    (function(){

      const tooltip = document.getElementById('", id, "');
      if(!tooltip) return;

      const graph = tooltip.closest('.group-graph');
      if(!graph) return;

      const data = ", json, ";
      const unit = '", unit, "';

      graph.querySelectorAll('.group-bar').forEach(bar => {

        bar.addEventListener('mouseenter', function(){

          const index = Number(this.dataset.index) - 1;
          const row = data[index];

          let html = `<div class='tooltip-title'>${row.year}</div>`;

          Object.keys(row).forEach(k => {

            if(k === 'year') return;

            const v = Number(row[k] || 0);

            html += `
              <div class='tooltip-line'>
                <span style='display:flex;align-items:center;gap:6px;'>
                  <span style='
                    width:8px;
                    height:8px;
                    border-radius:50%;
                    background:${getColor(index, k)};
                    display:inline-block;
                  '></span>
                  ${k}
                </span>
                <span>${v}${unit}</span>
              </div>
            `;
          });

          tooltip.innerHTML = html;
          tooltip.style.display = 'block';
        });

        bar.addEventListener('mousemove', function(e){
          const rect = graph.getBoundingClientRect();
          tooltip.style.left = (e.clientX - rect.left + 15) + 'px';
          tooltip.style.top  = (e.clientY - rect.top - 10) + 'px';
        });

        bar.addEventListener('mouseleave', function(){
          tooltip.style.display = 'none';
        });

      });

      function getColor(rowIndex, colName){
        const bar = graph.querySelector(
          `.group-bar[data-index='${rowIndex+1}'][data-col='${colName}']`
        );
        return bar ? getComputedStyle(bar).backgroundColor : '#999';
      }

    })();
    "
    )))
}
