library(umap)
library(ggplot2)

#dat <- iris

df <- read.table("Greens-Macros_full_meta_grepped.txt", header = TRUE, sep = "\t", row.names = 1)



umap <- umap(df[!duplicated(df),])
Divi <- df$Division
Lab = df$Labeling_figures

# <bytecode: 0x55bca5af9d58>

df2 <- data.frame(x = umap$layout[,1],
                 y = umap$layout[,2],
                 La = df[!duplicated(df), "Labeling_figures"])

q <- ggplot(df2, aes(x, y, colour = La)) +
  geom_point() + theme(legend.position = "none") #+ geom_text( aes(label=Lab, size=2))

ggsave(plot = q, width = 6, height = 6, dpi = 300, filename = "test_umap_ggplot_greens.pdf")
