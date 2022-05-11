library(reshape2)
library(dataRetrieval)
library(dplyr) # for `rename` & `select`
library(tidyr) # for `gather`
library(ggplot2)
library(ggExtra)
library(readr)
library(magick)
library(stats)

df <- read.table("Growth_curves_WT_R4.txt", header = TRUE, sep = "\t")

options(scipen=999)

df.melt <- melt(df,
    id.vars = 'Day',
    measure.vars = c('WT.1', 'WT.2', 'WT.3', 'R4.1', 'R4.2', 'R4.3'))

df.melt.mod <- df.melt %>%
    separate(col=variable, into=c('strain', 'replicate'), sep='\\.')

q <- ggplot(df.melt.mod, aes(x=Day, y=value, group=strain)) +
    stat_summary(
        fun = mean,
        geom='line',
        aes(color=strain)) +
    stat_summary(
        fun=mean,
        geom='point') +
    stat_summary(
        fun.data=mean_cl_boot,
        geom='errorbar',
        width=0.5) +
    theme_bw()

ggsave(plot = q, width = 4, height = 3, dpi = 300, filename = "Amnah_growth_curve.pdf")
