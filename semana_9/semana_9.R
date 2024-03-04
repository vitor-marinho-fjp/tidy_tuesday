


# load data ---------------------------------------------------------------


# Option 1: tidytuesdayR package 
## install.packages("tidytuesdayR")

library(tidytuesdayR)
library(tidyverse)
library(plotly)
library(htmlwidgets)
library(webshot)


tuesdata <- tidytuesdayR::tt_load('2024-02-27')


events <- tuesdata$events 


# time line ---------------------------------------------------------------

# Organizando os eventos em ordem cronológica
events <- events %>%
  arrange(year) %>%
  mutate(short_description = sapply(strsplit(event, " "), function(x) paste(head(x, 3), collapse = " ")),
         event_index = seq_along(event),
         hover_text = gsub("(.{1,50})(\\s|$)", "\\1<br>", event, perl = TRUE)) # Adiciona quebras de linha a cada 50 caracteres

# Defina as cores desejadas
point_color <- '#007bff'  # Azul
line_color <- '#cccccc'   # Cinza claro
background_color <- '#fff2cc'  # Cinza claro para o fundo
title_color <- '#333333'  # Cinza escuro para o texto
font <- "Outfit"

# Criando a linha do tempo interativa com eventos organizados
p <- plot_ly(data = events, x = ~year, y = ~event_index,
             hoverinfo = 'text', # Mostrar hover_text no hover
             hovertext = ~hover_text, # Texto formatado para o hover
             marker = list(color = point_color, size = 10)) %>%
  add_segments(x = ~year, xend = min(events$year) - 5, y = ~event_index, yend = ~event_index,
               line = list(color = line_color)) %>%
  layout(title = list(text = "Historical Journey February 29: An Interactive Timeline of Notable Events", x = .2, y = 1.35, xanchor = "left", yanchor = "top", 
                      font = list(color = title_color, family = font, size = 20)), # Ajustes no título
         annotations = list(
           list(
             text = "<b>Leap Day</b> | #TidyTuesday Week 09 | @vit0rmarinh0",
             x = .2,
             y = 0.95,  # Posiciona logo abaixo do título
             xref = "paper",
             yref = "paper",
             showarrow = FALSE,
             font = list(family = font, size = 12),
             xanchor = "left",
             yanchor = "bottom"
           )
         ),
         paper_bgcolor = background_color,  # Cor de fundo do gráfico
         plot_bgcolor = background_color,  # Cor de fundo do gráfico
         xaxis = list(title = "Year"),
         yaxis = list(title = "Events", tickvals = ~event_index, ticktext = ~short_description),
         hovermode = 'closest',
         margin = list(l = 150, b = 40, t = 80, r = 40)) # Ajustando as margens para acomodar título e anotação
p



# Salva o gráfico como HTML
saveWidget(p, "tidytuesday_week_09.html", selfcontained = TRUE)

webshot("tidytuesday_week_09.html", "tidytuesday_week_09.png", vwidth = 920, vheight = 920, delay = 5)
