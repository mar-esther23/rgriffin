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

## ---- echo=TRUE----------------------------------------------------------
q = addGqueryAttractors(q, attr)

## ---- echo=TRUE----------------------------------------------------------
nets = runGquery(q)
print(nets)

## ---- echo=TRUE----------------------------------------------------------
library(BoolNet)
data("cellcycle")
topology <- getNetTopology(cellcycle)
topology

## ---- echo=TRUE----------------------------------------------------------
cc.attr <- getAttractors(cellcycle)
cycle <- attractorToDataframe(cc.attr)
cycle <- cycle[cellcycle$genes] #remove info columns
cycle

## ---- echo=TRUE----------------------------------------------------------
q <- createGqueryGraph(topology, cellcycle$genes)
q <- addGqueryCycle(q, cycle)

## ---- include = FALSE----------------------------------------------------
genes = c('a','b','c')
inter = data.frame(source=c('a','b','b','c','c'), 
                  target=c('b','b','c','b','c'), 
                  type=c('+','+','-','-','+'),
                    stringsAsFactors = F )
q = createGqueryGraph(inter, genes)

attr = data.frame(a=c(0,'*',0), 
                 b=c(0,1,0), 
                 c=c(0,0,1),
                 stringsAsFactors = F )
q = addGqueryAttractors(q, attr)

## ---- echo=TRUE----------------------------------------------------------
nets = runGquery(q,return = "BoolNet")
iterators::nextElem(nets)

