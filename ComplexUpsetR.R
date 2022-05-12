library(ggplot2)
library(ComplexUpset)
library(ggbeeswarm)

#movies <- read.csv(system.file("extdata", "movies.csv", package = "UpSetR"), 
 #                  header = T, sep = ";")


df <- read.table("Macros_ave_per_div-meta.txt", header = TRUE, sep = "\t", row.names = 1)

df[df > 0] <- 1

#df <- for(i in 2:ncol(df)){ df[ , i] <- as.integer(df[ , i]) }

#Division <- df$Division
#mat <- data.matrix(df[,-1])  

pdf(file = 'Macroalgal_UpSetR_multi4.pdf')


sets = c('Brown_ave','Green_ave','Red_ave')
#sets.n <- as.numeric(sets)

upset(
  df,
  sets,  annotations = list(
    'T1'=ggplot(mapping=aes(x=intersection, y=Total)) + geom_boxplot(),
    'T2'=ggplot(mapping=aes(x=intersection, y=Total))
    # if you do not want to install ggbeeswarm, you can use geom_jitter
    + ggbeeswarm::geom_quasirandom(aes(color=log10(Total)))
    + geom_violin(width=1.1, alpha=0.5)
  ),
  queries=list(
    upset_query(
      intersect=c('Brown_ave', 'Green_ave'),
      color='red',
      fill='red',
      only_components=c('intersections_matrix', 'Intersection size')
    ),
    upset_query(
      set='Red_ave',
      fill='blue'
    ),
    upset_query(
      intersect=c('Red_ave', 'Green_ave'),
      fill='yellow',
      only_components=c('Total')
    )
  ),
  min_size=10,
  width_ratio=0.1
)




dev.off()

