## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo=TRUE----------------------------------------------------------
library(BoolNet)
data("cellcycle")
topology <- get.net.topology(cellcycle)
topology

