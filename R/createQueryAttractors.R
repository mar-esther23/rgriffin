#' Add target attractors to a Griffin query.
#' 
#' Add a dataframe with attractors to a Griffin query.
#' The function takes a dataframe with the attractors 
#' where the first column corresponds to the attractor number
#' and the second to the state, so that cyclic attractors can have multiple rows.
#' the rest of the columns corresponds to the nodes of the network
#' The valid values are:
#'    1: active
#'    0: inactive
#'    *: non-determined
#'    
#' @param j.query Griffin query
#' @param df.attr dataframe with attractors
#' @return query java query to run Griffin
#' 
#' @examples
#' data("cellcycle")
#' topology <- getNetTopology(cellcycle)
#' cc.attr <- getAttractors(cellcycle)
#' cc.attr <- attractorToDataframe(cc.attr)
#' 
#' q <- createGqueryGraph(topology, cellcycle$genes)
#' q <- addGqueryAttractors(q, cc.attr)
#' print(q)
#' 
#' @export
addGqueryAttractors <- function(j.query, df.attr) {
  nodes = .jcall(j.query,returnSig = "[Ljava/lang/String;","getGenesAsString")
  #df.attr = validateStates(df.attr, nodes)
  
  for(i_attr in 1:max(df.attr[[1]]) ) { 
      attr = df.attr[ df.attr[1] == i_attr, ]
      attr <- attr[nodes] #remove extra columns
      attr <- validateStates(attr, nodes)
      if (dim(attr)[1]==1) { #it is a steady state
        attr = paste(attr, collapse = '')
      }
      else { #it is a cycle
        attr = apply(attr, 1, function(x) x = paste(x, collapse = ''))
      }
      .jcall(j.query,returnSig = "V","addAttractor", attr)
  }
  return(j.query)
}


#' Add target steady-state attractors to a Griffin query.
#' 
#' Add a set of target steady-state attractors to a Griffin query.
#' The function takes a dataframe with the attractors 
#' where each row corresponds to a steady state and 
#' each column corresponds to a node of the network
#' The valid values are:
#'    1: active
#'    0: inactive
#'    *: non-determined
#'    
#' @param j.query Griffin query
#' @param df.attr dataframe with steady-state attractors
#' @return query java query to run Griffin
#' 
#' @examples
#' attr = data.frame(a=c(0,'*',0,1), 
#'                   b=c(0,1,0,'*'), 
#'                   c=c(0,0,1,0),
#'                   stringsAsFactors = F )
#' q = addGquerySteadyStates(q, attr)
#' @export
#' 
addGquerySteadyStates <- function(j.query, df.attr) {
  nodes = .jcall(j.query,returnSig = "[Ljava/lang/String;","getGenesAsString")
  df.attr = validateStates(df.attr, nodes)
  
  # iterate over attractors and send to query
  apply(df.attr, 1, function(x) {
    x = paste(x, collapse = '')
    .jcall(j.query,returnSig = "V","addAttractor",x)
  })
  return(j.query)
}



#' Add target cycle to a Griffin query.
#' 
#' Add a target cyclic attractor to a Griffin query.
#' The function takes a dataframe with the states of the cycle 
#' where wach row corresponds to a state in order and 
#' each column corresponds to a node of the network
#' The valid values are:
#'    1: active
#'    0: inactive
#'    *: non-determined
#'    
#' @param j.query Griffin query
#' @param df.cycle dataframe with cycle
#' @return query java query to run Griffin
#' 
#' @examples
#' cycle = data.frame(a=c(0,0), b=c(0,1), c=c(1,0),
#'                   stringsAsFactors = F )
#' q = addGqueryCycle(q, cycle)
#' @export
#' 
addGqueryCycle <- function(j.query, df.cycle) {
  #first get valid genes from query
  nodes = .jcall(j.query,returnSig = "[Ljava/lang/String;","getGenesAsString")
  df.cycle = validateStates(df.cycle, nodes)
  df.cycle = apply(df.cycle, 1, function(x) x = paste(x, collapse = ''))
  .jcall(j.query,returnSig = "V","addAttractor", df.cycle)
  return(j.query)
}


