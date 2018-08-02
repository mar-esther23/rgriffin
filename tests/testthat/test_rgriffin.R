#context("rgriffin")
test_results <- test_dir(".", reporter="summary")

#' We are actually testing almost the whole pipeline here
test_that("run.gquery", {
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
  
  nets = run.gquery(q)
  nets = sort(nets)
  
  expected = c(
    "targets,factors\na,false\nb,((((((!a&b)&!c)|((!a&b)&c))|((a&!b)&!c))|((a&b)&!c))|((a&b)&c))\nc,(!b&c)\n",
    "targets,factors\na,false\nb,((((((!a&b)&!c)|((a&!b)&!c))|((a&!b)&c))|((a&b)&!c))|((a&b)&c))\nc,(!b&c)\n",
    "targets,factors\na,false\nb,(((((!a&b)&!c)|((a&!b)&!c))|((a&b)&!c))|((a&b)&c))\nc,(!b&c)\n",
    "targets,factors\na,false\nb,((((!a&b)&!c)|((a&!b)&!c))|((a&b)&!c))\nc,(!b&c)\n",
    "targets,factors\na,false\nb,((((!a&b)&!c)|((a&b)&!c))|((a&b)&c))\nc,(!b&c)\n"
    ) 
  
  #print(nets)
  
  expect_equal(nets[1],expected[1])
  
})