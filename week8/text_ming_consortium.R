# Carregamento dos Pacotes
# ------------------------------------------------------------------------------
install.packages("tidytuesdayR")  # Instalar o pacote, se necessário
library(tidyverse)
library(tidytuesdayR)
library(wordcloud)
library(RColorBrewer)
library(ggthemes)
library(tm)

# Coleta e Preparação dos Dados
# ------------------------------------------------------------------------------
# Carregando dados do TidyTuesday
tuesdata <- tidytuesdayR::tt_load('2024-02-20')
dados <- tuesdata$isc_grants  # Montar dataframe

# Pré-processamento de Texto para Análise
# ------------------------------------------------------------------------------
# Preparação do Corpus
corpus <- Corpus(VectorSource(dados$summary))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)

# Criação da Matriz de Termos
dtm <- TermDocumentMatrix(corpus)
matrix <- as.matrix(dtm)
words <- sort(rowSums(matrix), decreasing = TRUE)
df <- data.frame(word = names(words), freq = words)

# Criação da Wordcloud
# ------------------------------------------------------------------------------

# Ajuste das margens 
par(mar = c(5, 4, 6, 4))  # margens inferior, esquerda, superior e direita

# Criando a nuvem de palavras
wordcloud(words = df$word, freq = df$freq, min.freq = 1,
          max.words = 100, random.order = FALSE, rot.per = -1.5,
          colors = ggthemes::tableau_color_pal()(10))

# Adicionando títulos
title(main = "Palavras-Chave no Universo das Bolsas ISC:\nMapeando Tendências no Desenvolvimento do R", 
      col.main = "black",  
      cex.main = .7,  # Ajustando o tamanho do título
      sub = "Fonte: TidyTuesday - @vit0rmarinh0",
      col.sub = "black",
      cex.sub = 0.8)  # Ajustando o tamanho do subtítulo




# Salvando a Wordcloud ------------------------------------------------------------------------------
# Abre o dispositivo gráfico com as dimensões 
png("nuvem_de_palavras.png", width = 1620, height = 1620, units = "px", res = 300)

# Fecha o dispositivo gráfico e salva a imagem
dev.off()

 