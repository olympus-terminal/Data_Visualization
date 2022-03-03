library(readr)
library(magick)
library(stats)
library(ComplexHeatmap)
library(circlize)
library(showtext)
library(shiny)
library(InteractiveComplexHeatmap)
library(seriation)

df <- read.table("MACRO-AA-TEMP-HAB.txt", header = TRUE, sep = "\t", row.names = 1)

pKa_NH2.b <- df[1,]
pKa_COOH.b <- df[2,]
Property.b <- (df[3,])

pKa_NH2 <- pKa_NH2.b[,-(1:6)]
pKa_COOH <- pKa_COOH.b[,-(1:6)]
Property <- Property.b[,-(1:6)]

Divi <- df[-(1:7),"Division"]

#df_dirty <- df[-1,]

Temperature <- df[-(1:3),1]
Habitat <- df[-(1:3),2]
Long.b <- df[-(1:3),3]
Lat.b <- df[-(1:3),4]
Genus_Species <- df[-(1:3),5]

df_clean <- df[-(1:3),-(1:6)] ##cols 1 (after taking row names) to 4 are annotations/metadata

mat <- data.matrix(df_clean)  

base_mean = rowMeans(mat)
mat_scaled = t(scale(t(mat)))

require(circlize)
#col_fun = colorRamp2(c(-1, 1, 5, 10, 20), c("lightblue", "blue", "darkblue", "black"))
col_fun = colorRamp2(c(min(mat_scaled[2,], na.rm=T), mean(mat_scaled, na.rm=T), max(mat_scaled, na.rm=T)), c("lightyellow", "lightblue",  "darkblue" ))
#col_fun = colorRamp2(seq(min(mat), max(mat), length = 3), c("blue", "#EEEEEE", "red"), space = "RGB")

boxplotViolin <- HeatmapAnnotation(
  Distribution=anno_density(data.matrix(mat_scaled), type="violin",
                       border=TRUE,
                       gp = gpar(fill = NA),
                     #  pch=".",
                      # size=unit(2, "mm"),
                       axis=TRUE,
                       axis_param = list(gp = gpar(fontsize=6), 
                                         gp = gpar(fill = Temperature)), 
 # annotation_width=unit(c(1, 5.0), "cm"),
  which="col"), annotation_name_gp = gpar(fontsize=6, annotation_names_rot = 90), height = unit(1, "cm"))

row_ha = rowAnnotation(Latitude = anno_points(Lat.b, size = unit(1, "mm")),
                       #
                       #Longitude = anno_lines(Long.b), 
                       annotation_name_gp = gpar(fontsize=6, annotation_names_rot = 270),
  width = unit(0.8, "cm"))

aa_types = HeatmapAnnotation(aa_type = anno_text(Property, location = 1, just = "left", rot = 270, gp = gpar(fontsize = 6)) )

lt = lapply(1:139, function(x) cumprod(1 + runif(1000, -x/100, x/100)) - 1)
#ha_hor = rowAnnotation(foo = anno_horizon(lt))
#ha_mark = HeatmapAnnotation(foo = anno_mark(at = c(7:12, 100:110, 200:210, 400:410), which = "top", labels = colnames(df_clean), labels_gp = gpar(fontsize=6)))

#o1 = seriate(dist(mat_scaled), method = "TSP")
#o2 = seriate(dist(t(mat_scaled)), method = "TSP")

pdf(file = 'Macroalgal_AAs-TEMP-HAB.pdf', paper="a4")

ht_list = Heatmap(mat_scaled, name = "Min_Max", column_title = "Amino Acid", column_title_gp = gpar(fontsize=6, rot=90), 
                  #row_order = get_order(o1), column_order = get_order(o2),
                  row_title = "Species", row_title_gp = gpar(fontsize=6), 
                  clustering_distance_columns = "pearson", clustering_distance_rows = "pearson", clustering_method_rows = "average", clustering_method_columns = "average", row_dend_reorder = TRUE, 
                  col = col_fun, raster_quality = 2, 
                  column_names_gp = gpar(fontsize = 6), row_names_gp = gpar(fontsize = 0), 
                  column_split = factor(Property), row_gap = unit(1.5, "mm"), 
                  #row_split = factor(Temperature),
                  border = TRUE,
                  top_annotation = boxplotViolin, column_names_side = "top",
                  row_labels = Genus_Species,
                  left_annotation = row_ha,
                  bottom_annotation = aa_types,
                  
                  #top_annotation = ha_mark
)

draw(ht_list, auto_adjust = FALSE)

dev.off()

#htShiny(ht_list)  ##can run an interactive graph, need good gpu

##from clicking: Pox_VLTF3, UMPH.1, PSII_Pbs31, DA1.like, N6.adenineMlase

