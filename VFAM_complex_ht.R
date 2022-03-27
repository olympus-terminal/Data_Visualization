library(readr)
library(magick)
library(stats)
library(ComplexHeatmap)
library(circlize)
library(showtext)
library(shiny)
library(InteractiveComplexHeatmap)
library(seriation)

df <- read.table("vfams-matrix-meta.txt", header = TRUE, sep = "\t", row.names = 1)

#pKa_NH2.b <- df[1,]
#pKa_COOH.b <- df[2,]
#Property.b <- (df[3,])

#pKa_NH2 <- pKa_NH2.b[,-(1:7)]
#pKa_COOH <- pKa_COOH.b[,-(1:7)]
#Property <- Property.b[,-(1:7)]

Divi <- df[,"Division"]
#Env <- df[,"Environment"]

#df_dirty <- df[-1,]

#WordSize40_N50 <- as.numeric(df[-(1:3),1], na.rm=T) 
#Habitat <- df[,"Environment"]
Lat.c <- df[,"Latitude"]
Lat.b <- abs(Lat.c)
Species <- df[,"Labeling_figures"]
#Focus <- df[,"Focus"]
#Climate <- df[,"Climate"]


df_clean <- df[,-(1:3)] ##cols 1 (after taking row names) to 4 are annotations/metadata

mat <- data.matrix(df_clean)  

#base_mean = rowMeans(mat)
#mat_scaled = t(scale(t(mat)))
#mat_scaled = scale(mat)
mat_scaled = mat

require(circlize)
#col_fun = colorRamp2(c(0, 1, 5, 10, 20), c("white", "lightblue", "blue", "darkblue", "black"))
#col_fun = colorRamp2(c(min(mat_scaled[,], na.rm=T), mean(mat_scaled, na.rm=T), max(mat_scaled, na.rm=T)), c("white", "blue", "black" ))
#col_fun = colorRamp2(seq(min(mat), max(mat), length = 3), c("blue", "#EEEEEE", "red"), space = "RGB")
col_fun = colorRamp2(c(0, 1, 2, 4, 12), c("white", "cornflowerblue", "palegoldenrod",  "yellow", "red"))

#boxplotViolin <- HeatmapAnnotation(
 # Distribution=anno_density(data.matrix(mat_scaled), joyplot_scale = 100, 
  #                     border=TRUE,
   #                    gp = gpar(fill = NA),
                     #  pch=".",
    #                   size=unit(2, "mm"),
     #                  axis=TRUE,
      #                 axis_param = list(gp = gpar(fontsize=4)),
                                         #axis_param = list(at = c(0, 250, 750, 1000) 
                                        # gp = gpar(fill = Temperature),
       #                    ), 
                     
 # annotation_width=unit(c(1, 5.0), "cm"),
 # which="col"), annotation_name_gp = gpar(fontsize=0, annotation_names_rot = 90), height = unit(1.2, "cm"))

#marks <-  HeatmapAnnotation(selected_pfams = anno_mark(at = c(7:12, 100:110, 200:210, 400:410), which = "top", labels = colnames(df_clean), labels_gp = gpar(fontsize=6)))

row_ha = rowAnnotation(Latitude = anno_points(Lat.b, size = unit(1, "mm")),
                       #N50 = anno_points(WordSize40_N50), 
                       annotation_name_gp = gpar(fontsize=6, annotation_names_rot = 270),
                      width = unit(1.2, "cm")
                       )
row_ha2 = rowAnnotation(Division = factor(Divi),  simple_anno_size = unit(.3, "cm"))

#aa_types <- HeatmapAnnotation(Property = factor(Property), simple_anno_size = unit(.2, "cm"))

#lt = lapply(1:139, function(x) cumprod(1 + runif(1000, -x/100, x/100)) - 1)
#ha_hor = rowAnnotation(foo = anno_horizon(lt))
#ha_mark = HeatmapAnnotation(foo = anno_mark(at = c(7:12, 100:110, 200:210, 400:410), which = "top", labels = colnames(df_clean), labels_gp = gpar(fontsize=6)))

#o1 = seriate(dist(mat_scaled), method = "TSP")
#o2 = seriate(dist(t(mat_scaled)), method = "TSP")

pdf(file = 'Macroalgal_PFAMs_3L2x_vFAMs.pdf', paper="a4")

ht_list = Heatmap(mat_scaled, name = "Z-score", column_title = "PFAMs", column_title_gp = gpar(fontsize=6, rot=90), 
                  #row_order = get_order(o1), column_order = get_order(o2),
                  row_title = "Species", row_title_gp = gpar(fontsize=6), 
                  #clustering_distance_columns = "spearman", clustering_distance_rows = "pearson", clustering_method_rows = "average", clustering_method_columns = "complete", row_dend_reorder = TRUE, 
                  clustering_distance_columns = "euclidean",
                  col = col_fun, raster_quality = 8, 
                  column_names_gp = gpar(fontsize = 4), row_names_gp = gpar(fontsize = 0), 
                  #column_split = factor(Property), 
                  row_gap = unit(1.5, "mm"), 
                  #row_km=3,
                  row_split = factor(Divi),
                  #cluster_rows = F,
                  border = TRUE,
                  #bottom_annotation = boxplotViolin, 
                  #top_annotation = marks,
                  #row_labels = Env,
                  left_annotation = row_ha,
                  right_annotation = row_ha2,
                  row_dend_side = "right", column_dend_side = "bottom"
                  #bottom_annotation = aa_types,
                  
                  #top_annotation = ha_mark
)

draw(ht_list, auto_adjust = FALSE)

dev.off()

htShiny(ht_list)  ##can run an interactive graph, need good gpu

##from clicking: Pox_VLTF3, UMPH.1, PSII_Pbs31, DA1.like, N6.adenineMlase


