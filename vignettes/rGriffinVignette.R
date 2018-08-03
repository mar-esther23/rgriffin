## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo=TRUE----------------------------------------------------------
genes = c('a','b','c')
inter = data.frame(source=c('a','b','b','c','c'), 
                  target=c('b','b','c','b','c'), 
                  type=c('+','OPU','-','-','OPU'),
                    stringsAsFactors = F )
inter

## ---- echo=TRUE----------------------------------------------------------
q = create.gquery.graph(inter, genes)
q

## ---- echo=TRUE----------------------------------------------------------
print(q)

## ---- echo=TRUE----------------------------------------------------------
attr = data.frame(a=c(0,'*',0), 
                 b=c(0,1,0), 
                 c=c(0,0,1),
                 stringsAsFactors = F )

## ---- echo=TRUE----------------------------------------------------------
q = add.gquery.attractors(q, attr)

## ---- echo=TRUE----------------------------------------------------------
nets = run.gquery(q)
print(nets)

## ---- echo=TRUE----------------------------------------------------------
library(BoolNet)
data("cellcycle")
topology <- get.net.topology(cellcycle)
topology

## ---- echo=TRUE----------------------------------------------------------
cc.attr <- getAttractors(cellcycle)
cycle <- attractor2dataframe(cc.attr)
cycle <- cycle[cellcycle$genes] #remove info columns
cycle

## ---- echo=TRUE----------------------------------------------------------
q <- create.gquery.graph(topology, cellcycle$genes)
q <- add.gquery.cycle(q, cycle)

## ---- include = FALSE----------------------------------------------------
genes = c('a','b','c')
inter = data.frame(source=c('a','b','b','c','c'), 
                  target=c('b','b','c','b','c'), 
                  type=c('+','+','-','-','+'),
                    stringsAsFactors = F )
q = create.gquery.graph(inter, genes)

attr = data.frame(a=c(0,'*',0), 
                 b=c(0,1,0), 
                 c=c(0,0,1),
                 stringsAsFactors = F )
q = add.gquery.attractors(q, attr)

## ---- echo=TRUE----------------------------------------------------------
nets = run.gquery(q,return = "BoolNet")
iterators::nextElem(nets)

## ---- echo=TRUE, results='asis'------------------------------------------
knitr::kable(head(mtcars, 10))

