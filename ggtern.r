library(readr)
library(magick)
library(stats)
library(circlize)
library(showtext)
library(dataRetrieval)
library(dplyr) # for `rename` & `select`
library(tidyr) # for `gather`
library(ggplot2)
library(ggExtra)
library(ggtern)
library(shiny)
library(plyr)


# Get the data by giving site numbers and parameter codes
# 00060 = stream flow, 00530 = total suspended solids, 00631 = concentration of inorganic nitrogen
df <- read.table("Macros_ave_per_div-meta_capped.txt", header = TRUE, sep = "\t", row.names = 1)

options(scipen=999)

Brown=df$Brown_ave
Red=df$Red_ave
Green=df$Green_ave
PF=df$PFAM
tot=df$Total_capped
CL=df$clan_acc
De=df$description

require(circlize)
col_fun = colorRamp2(c(0, 1, 2, 4, 12), c("white", "cornflowerblue", "palegoldenrod",  "yellow", "red"))

#pdf(file = 'ExMult3.pdf', paper="a4")
q <- ggtern(df, aes(x=Brown,y=Green, z=Red )) + #geom_density_tern(aes(color=tot)) +   #stat_density_tern(aes(tot, alpha=.1), geom='polygon') +
  scale_fill_gradient2(low= "yellow", high = "blue") +  
  geom_point( size=((tot)*.1+ .3), alpha=.5, aes(fill=tot), 
              colour="black",pch=21) + 
  #geom_mark(aes(x, y, r = r, p.value = p.value, angle = angle), size = 3) +
  theme_light() +
  ggtitle("Average PFAMs per division") +
  xlab("Brown") + 
  ylab("Green") +
  zlab("Red") +
  guides(color = "none", fill = "none", alpha = "none")  + geom_text(aes(label = ifelse(..tot.. > 60, ..De.., ""), size=.02, hjust=.02, vjust=.03)) + theme_nomask()


#+ geom_text(data=subset(df, tot > 70), aes(label=De), size=.5)

ggsave(plot = q, width = 8, height = 8, dpi = 300, filename = "Macrotern-capped_lab4.pdf")

#ui <- fluidPage(
 # mainPanel(
  #  plotOutput("ggtern")
  #)geom_text(data=subset(my.data, count>10), aes(y=pos, label=count), size=4)

#)
#server <- function(input, output) {
 # output$ggtern <- renderPlot({
    
  #  print (
   #   ggtern(df, aes(x=Brown, y=Green, z=Red)) + stat_density_tern(aes(fill=Green, alpha=.1), geom='polygon') +
    #  scale_fill_gradient2(high = "yellow") +  
     # geom_point(size = .05) +
      #theme_showarrows() +
      #ggtitle("Average PFAMs per division") +
      #xlab("Brown") + 
      #ylab("Green") +
      #zlab("Red") +
      #guides(color = "none", fill = "none", alpha = "none")
    #)
    
    
  #})
#}
# shinyApp(ui = ui, server = server)
