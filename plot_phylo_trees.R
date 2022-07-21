library(dplyr)
library(ggtree)
library(treeio)
library(magrittr)
library(ggplot2)
library(tidytree)

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

create_tree <- function(tree_file, root=FALSE) {

  tree <- read.tree(tree_file)
  
  if (root) {
    hev_rooted <- root(tree, outgroup = "JN255817", edgelabel = FALSE)
    p = ggtree(hev_rooted, branch.length="none") %<+% metadata +
        geom_treescale() +
        # geom_tippoint(aes(shape=Host), size=2) +
        geom_nodelab(size=5, hjust=-.1) +
        geom_tiplab(aes(color=Country), size=5, show.legend=TRUE) + 
        scale_colour_manual(na.translate = F,
                            name="Country",
                            values=c("royalblue","darkorange", "darkgreen", "purple", "black", "darkred")
        ) +
        scale_shape_manual(na.translate = F,
                           values = c(16, 17, 8)) +
        guides(color = guide_legend(override.aes = list(label = "\u25CF", size = 4))) +
        guides(shape = guide_legend(override.aes = list(label = "\u25CF", size = 3))) +
        theme(legend.title = element_text(size=25),
              legend.text = element_text(size=20),
              legend.position = c(0.1, 0.9)
        )
  }
  else {
    drop_hev <- drop.tip(tree, "JN255817")
    p = ggtree(drop_hev) %<+% metadata +
        geom_treescale() +
        # geom_tippoint(aes(shape=Host), size=2) +
        geom_nodelab(size=5, hjust=-.1) +
        # geom_tiplab(aes(color=Country), size=5, show.legend=TRUE) + 
        geom_tippoint(aes(color=Country)) +
        scale_colour_manual(na.translate = F,
                            name="Country",
                            values=c("royalblue","darkorange", "darkgreen", "purple", "black", "darkred")
        ) +
        scale_shape_manual(na.translate = F,
                           values = c(16, 17, 8)) +
        guides(color = guide_legend(override.aes = list(label = "\u25CF", size = 4))) +
        guides(shape = guide_legend(override.aes = list(label = "\u25CF", size = 3))) +
        theme(legend.title = element_text(size=25),
              legend.text = element_text(size=20),
              legend.position = c(0.1, 0.9)
        )
  }
  
  png_file = paste("trees/Figures/", tools::file_path_sans_ext(basename(tree_file)), ".png", sep="")
  ggsave(png_file, width = 50, height = 40, units = "cm", limitsize = FALSE)
}

# create_tree("trees/P_no_stop_codons_iqtree.nwk")
create_tree("trees/P_no_stop_codons_HeV_iqtree.nwk", FALSE)

# 

# # fasttree trees
# create_tree("trees/P_no_stop_codons_FT.nwk")
# create_tree("trees/G_no_stop_codons_FT.nwk")
# 
# # phyml trees
# create_tree("trees/P_no_stop_codons_ML.nwk")
# create_tree("trees/G_no_stop_codons_ML.nwk")

# iqtrees: model selection and ML tree
# create_tree("trees/P_no_stop_codons_iqtree.nwk")
# create_tree("trees/G_no_stop_codons_iqtree.nwk")