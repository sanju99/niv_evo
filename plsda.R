setwd("Desktop/git/niv_evo")

library(mixOmics)
library(ggplot2)

input_mat <- read.csv("plsda_input.csv")
metadata <- read.csv("metadata_all.csv")

X = input_mat[1:dim(input_mat)[1], 2:dim(input_mat)[2]]

# 0 = Malaysia, 1 = India, 2 = Bangladesh
y <- as.factor(read.csv("plsda_output.csv")$Y)

isolates <- input_mat$X

plsda <- splsda(X, y)

plotIndiv(plsda, ind.names = FALSE, legend=TRUE,
          ellipse = TRUE, star = FALSE, title = 'Sparse PLS-DA on P and G proteins',
          X.label = 'LV 1', Y.label = 'LV 2')

plotLoadings(plsda, contrib = 'max', method = 'mean')