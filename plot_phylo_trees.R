library(dplyr)
library(ggtree)
library(treeio)
library(magrittr)
library(ggplot2)

setwd("Desktop/git/niv_evo")

metadata <- read.csv("metadata_all.csv")
metadata[metadata == "nan"] <- "unknown"
metadata$Clade %<>% factor

# whitmer_isolates_tree <- function(tree_file, metadata) {
#   
#   tree <- read.tree(tree_file)
#   fName <- strsplit(basename(tree_file), split="\\.")[[1]][1]
#   
#   p = ggtree(tree) %<+% metadata +
#     geom_tippoint() +
#     geom_nodelab(size=4, hjust = 1.5, vjust = -0.5) +
#     geom_tiplab(aes(color = Clade), size=5, show.legend=TRUE) +
#     scale_colour_manual(na.translate = F,
#                         name="Clade",
#                         values=c("blue","red")
#     ) + 
#     guides(color = guide_legend(override.aes = list(label = "\u25CF", size = 6))) + 
#     theme(legend.title = element_text(size=20),
#           legend.text = element_text(size=17),
#           legend.position = c(0.1, 0.9)) +
#     geom_treescale(x=0, y=21, fontsize=5, linesize=1, offset=-0.8)
#   
#   ggsave(paste(dirname(tree_file), "/", fName, ".png", sep=""), width = 55, height = 30, units = "cm", limitsize = FALSE)
#   
# }
# 
# whitmer_isolates_tree("trees/P_whitmer_BGD_FT.nwk", metadata)
# whitmer_isolates_tree("trees/G_whitmer_BGD_FT.nwk", metadata)

create_tree <- function(tree_file) {

  tree <- read.tree(tree_file)
  
  # use branch.length="none" if don't want to use branch lengths
  # p = ggtree(tree, branch.length="none") %<+% metadata +
  
  p = ggtree(tree) %<+% metadata +
            geom_tippoint(aes(shape=Host), size=3) +
            geom_nodelab(size=4, hjust = 1.7, vjust = -0.5) +
            geom_tiplab(aes(color=Country), size=5, show.legend=TRUE) + 
            scale_colour_manual(na.translate = F,
                                name="Country",
                                values=c("royalblue","darkorange", "darkgreen", "purple", "black")
                                ) +
            scale_shape_manual(na.translate = F,
                               values = c(16, 17, 8)) +
            guides(color = guide_legend(override.aes = list(label = "\u25CF", size = 4))) +
            guides(shape = guide_legend(override.aes = list(label = "\u25CF", size = 3))) +
            theme(legend.title = element_text(size=20),
                  legend.text = element_text(size=15),
                  legend.position = c(0.05, 0.85))
  
  png_file = paste("trees/Figures/", tools::file_path_sans_ext(basename(tree_file)), ".png", sep="")
  ggsave(png_file, width = 60, height = 30, units = "cm", limitsize = FALSE)
  
}

# # fasttree trees
# create_tree("trees/P_no_stop_codons_FT.nwk")
# create_tree("trees/G_no_stop_codons_FT.nwk")
# 
# # phyml trees
# create_tree("trees/P_no_stop_codons_ML.nwk")
# create_tree("trees/G_no_stop_codons_ML.nwk")

# iqtrees: model selection and ML tree
create_tree("trees/P_no_stop_codons_iqtree.nwk")
create_tree("trees/G_no_stop_codons_iqtree.nwk")