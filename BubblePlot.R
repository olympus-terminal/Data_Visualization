library(dataRetrieval)
library(dplyr) 
library(tidyr) 
library(ggplot2)
library(ggExtra)
library(readr)
library(magick)
library(stats)

df <- read.table("brown_tip_extracted.txt", header = TRUE, sep = "\t")

options(scipen=999)

p <- ggplot(data = df, aes(x = Domain, y = Assembly)) +
  geom_point(aes(color = NegLogE, size=Score, alpha=.4)) +
  theme_bw()  +
  theme(legend.position="none")

q <- p 

q

ggsave(plot = q, width = 8, height = 12, dpi = 300, filename = "BrownTipPfams.pdf")



