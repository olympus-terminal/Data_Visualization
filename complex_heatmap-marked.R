library(readr)
library(magick)
library(stats)
library(ComplexHeatmap)
library(circlize)
library(showtext)

df <- read.table("Documents/MacroPfams-e-5-seqtbl-matrix-extMeta.txt", header = TRUE, sep = "\t", row.names = 1)

df_clean <- df[, -(1:4)] ##cols 1 (after taking row names) to 4 are annotations/metadata

mat <- data.matrix(df_clean)  

base_mean = rowMeans(mat)
mat_scaled = t(scale(t(mat)))

require(circlize)
col_fun = colorRamp2(c(-2, -1, 0, 1, 2, 3), c("white", "lightblue", "blue", "darkgreen", "darkblue", "black"))
lgd = Legend(col_fun = col_fun, title = "MacroPFAMs")

#col_fun = colorRamp2(c(min(df[2,], na.rm=T), mean(df, na.rm=T), max(df, na.rm=T)), c("white", "lightblue",  "blue" ))
#lt = lapply(1:11694, function(x) cumprod(1 + runif(10000, -x/100, x/100)) - 1)
#lt = apply(mat, 1, function(x) data.frame(density(x)[c("x", "y")]))

boxplotCol <- HeatmapAnnotation(
  boxplot=anno_boxplot(data.matrix(mat_scaled),
                       border=TRUE,
                       gp=gpar(fill="#CCCCCC"),
                       pch=".",
                       size=unit(2, "mm"),
                       axis=TRUE,
                       axis_param = list(gp = gpar(fontsize=4)),
  annotation_width=unit(c(1, 5.0), "cm"),
  which="col"))

Long <- data.frame(df$Longitude)
Lat <- data.frame(df$Latitude)

row_ha = rowAnnotation(Latitude = anno_lines(Lat), Longitude = anno_lines(Long))

ha_mark = HeatmapAnnotation(foo = anno_mark(at = c(7:12, 100:110, 200:210, 400:410), which = "top", labels = colnames(df_clean), labels_gp = gpar(fontsize=4)))

pdf(file = 'my_plot3.pdf')

ht_list = Heatmap(mat_scaled, name = "Macroalgal PFAMs", clustering_distance_columns = "pearson", row_dend_reorder = TRUE, 
                  col = col_fun, raster_quality = 2, 
                  column_names_gp = gpar(fontsize = 1), row_names_gp = gpar(fontsize = 4), row_split = df$Division,
                  bottom_annotation=boxplotCol,
                  row_labels = df$Genus_Species,
                  right_annotation = row_ha,
                  top_annotation = ha_mark
)

draw(ht_list, auto_adjust = TRUE)

dev.off()
