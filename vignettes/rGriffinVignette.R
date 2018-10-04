## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library("rGriffin")

## ---- echo=TRUE----------------------------------------------------------
genes = c('a','b','c')
inter = data.frame(source=c('a','b','b','c','c'), 
                  target=c('b','b','c','b','c'), 
                  type=c('+','OPU','-','-','OPU'),
                    stringsAsFactors = F )
inter

## ---- echo=TRUE----------------------------------------------------------
q = createGqueryGraph(inter, genes)
q

## ---- echo=TRUE----------------------------------------------------------
print(q)

## ---- echo=TRUE----------------------------------------------------------
attr = data.frame(a=c(0,'*',0), 
                 b=c(0,1,0), 
                 c=c(0,0,1),
                 stringsAsFactors = F )
attr

## ---- echo=TRUE----------------------------------------------------------
q = addGquerySteadyStates(q, attr)

## ---- echo=TRUE----------------------------------------------------------
nets = runGquery(q)
print(nets)

## ---- echo=TRUE----------------------------------------------------------
data(cellcycle)
attr = findAttractors(cellcycle)
attr

## ---- echo=TRUE----------------------------------------------------------
data("cellcycle")
topology <- getNetTopology(cellcycle)
topology

## ---- echo=TRUE----------------------------------------------------------
cc.attr <- getAttractors(cellcycle)
cc.attr <- attractorToDataframe(cc.attr)
cc.attr

## ---- echo=TRUE----------------------------------------------------------
q <- createGqueryGraph(topology, cellcycle$genes)
q <- addGqueryAttractors(q, cc.attr)
print(q)

## ---- echo=TRUE----------------------------------------------------------
library(iterators)
net <- runGquery(q, return="BoolNet", return.network.limit=1)
nextElem(net)

