#' Create a Griffin query.
#' 
#' This function takes an interaction regulatory graph and creates a griffin query.
#' 
#' The graph must include: source, target and type of interaction
#' Valid types of interctions are:
#'    false:  Contradiction
#'    MA: Mandatory, ambiguous
#'    MPU (or +): Mandatory, positive, unambiguous
#'    MPPA: Mandatory, positive, possibly ambiguous
#'    MNU (or -): Mandatory, negative, unambiguous
#'    MNPA: Mandatory, negative, possibly ambiguous
#'    MUSU: Mandatory, unknown sign, unambiguous
#'    MUSPA:  Mandatory, unknown sign, possibly ambiguous
#'    NR: No regulation
#'    OA: Optional, ambiguous
#'    OPU:  Optional, positive, unambiguous
#'    OPPA: Optional, positive, possibly ambiguous
#'    ONU:  Optional, negative, unambiguous
#'    ONPA: Optional, negative, possibly ambiguous
#'    OUSU: Optional, unknown sign, unambiguous
#'    true: Tautology 
#' 
#' @param df.graph dataframe with source nodes, target nodes and the type of interactions
#' @param nodes vector with all node names
#' @return query java query to run Griffin
#' 
#' @examples
#' > genes = c('a','b','c')
#' > inter = data.frame(source=c('a','b','b','c','c'), 
#'                      target=c('b','b','c','b','c'), 
#'                      type=c('+','+','+','-','+'),
#'                      stringsAsFactors = F )
#' > createGqueryGraph(inter, genes)
#' @export
#' 
createGqueryGraph <- function(df.graph, nodes) {
  #check headers
  colnames(df.graph) = c('source', 'target', 'type')
  n_source = 'source'
  n_target = 'target'
  n_reg = 'type'
  # validate all nodes in gene list
  df.nodes = unique(c(df.graph[[n_source]], df.graph[[n_target]]))
  if (! setequal(df.nodes, nodes)) stop("Unequal nodes between interaction table and gene list")

  # translate interactions + -
  df.graph[n_reg][df.graph[n_reg]=='+']<-'MPU'
  df.graph[n_reg][df.graph[n_reg]=='-']<-'MNU'
  df.graph[n_reg][df.graph[n_reg]=='True']<-'true'
  df.graph[n_reg][df.graph[n_reg]=='False']<-'false'
  df.graph[n_reg][df.graph[n_reg]=='T']<-'true'
  df.graph[n_reg][df.graph[n_reg]=='F']<-'false'
  # validate all interactions in interaction list
  valid.inter = c('false','MA','MPU','MPPA','MNU','MNPA','MUSU','MUSPA',
                  'NR','OA','OPU','OPPA','ONU','ONPA','OUSU','true')
  if (! all(df.graph[[n_reg]] %in% valid.inter)) stop("Unvalid interactions")
  # send to griffin and generate query
  j.query = .jnew("mx/unam/iimas/griffin/r/RGriffinQuery")
  j.nodes = .jarray(unlist(nodes))
  .jcall(j.query,returnSig = "V","setGenes",nodes)
  apply(df.graph, 1, function(x) {
    .jcall(j.query,returnSig = "V","addRRegulation",x[[1]],x[[2]],x[[3]])
    })
  #class(j.query) = "gquery"
  return(j.query)
}



#' Add prohibited attractors to a Griffin query.
#' 
#' Add a set of prohibited steady-state attractors to a Griffin query.
#' The function takes a dataframe with the prohibited attractors 
#' where wach row corresponds to a prohibited steady state and 
#' each column corresponds to a node of the network
#' The valid values are:
#'    1: active
#'    0: inactive
#'    *: non-determined
#'    
#' @param j.query Griffin query
#' @param df.prohibited.attr dataframe with valid prohibited attractors
#' @return query java query to run Griffin
#' 
#' @examples
#' attr.prohibited = data.frame(a=c('*'), b=c(1), c=c(1),
#'                   stringsAsFactors = F )
#' q = addGqueryProhibitedAttractors(q, attr.prohibited)
#' @export
#' 
addGqueryProhibitedAttractors <- function(j.query, df.prohibited.attr) {
  #first get valid genes from query
  nodes = .jcall(j.query,returnSig = "[Ljava/lang/String;","getGenesAsString")
  df.prohibited.attr = validateStates(df.prohibited.attr, nodes)
  
  # iterate over attractors and send to query
  apply(df.prohibited.attr, 1, function(x) {
    x = paste(x, collapse = '')
    .jcall(j.query,returnSig = "V","addFixedPointProhibition",x)
  })
  return(j.query)
}


#' Add mutant with attractors to a Griffin query.
#' 
#' Add a mutant and a set of target steady-state attractors to a Griffin query.
#' The function takes a vector of mutant nodes, a vector of its values
#' and a dataframe with the target attractors for the mutant
#' where wach row corresponds to a prohibited steady state and 
#' each column corresponds to a node of the network
#' The valid values are:
#'    1: active
#'    0: inactive
#'    *: non-determined
#'    
#' @param j.query Griffin query
#' @param mutant.nodes nodes whose value is fixed in the mutant
#' @param mutant.values values of the nodes in the mutant
#' @param df.mutant.attr dataframe with valid attractors
#' @return query java query to run Griffin
#' 
#' @examples
#' # one node mutant
#' mutant.node = c('c')
#' mutant.value = c(1) 
#' mutant.attr = data.frame(a=c(0,1), b=c(0,0), c=c(1,1),
#'                          stringsAsFactors = F )
#' q = addGqueryMutant(q, mutant.node, mutant.value, mutant.attr)
#' 
#' # multiple node mutant
#' mutant.nodes = c('a','b')
#' mutant.values = c(0,0) 
#' mutant.attrs = data.frame(a=c(0), b=c(0), c=c('*'),
#'                          stringsAsFactors = F )
#' q = addGqueryMutant(q, mutant.nodes, mutant.values, mutant.attrs)
#' @export
#' 
addGqueryMutant <- function(j.query, mutant.nodes, mutant.values, df.mutant.attr) {
  #first get valid genes from query
  nodes = .jcall(j.query,returnSig = "[Ljava/lang/String;","getGenesAsString")
  if (! all(mutant.nodes %in% nodes)) stop("Non-valid mutant.nodes")
  mutant.values = as.character(mutant.values)
  if (! all(mutant.values %in% c('0','1'))) stop("Non-valid mutant.values")
  df.mutant.attr = validateStates(df.mutant.attr, nodes)
  
  df.mutant.attr = apply(attr, 1, function(x) { paste(x, collapse = '') })
  .jcall(j.query,returnSig = "V","addMutantFixedPoints",
         mutant.nodes, mutant.values, df.mutant.attr )
  return(j.query)
}


#' Add a transition between two states to a Griffin query.
#' 
#' Add a transition between two states to a Griffin query.
#' The function takes a dataframe with the steady states
#' where wach row corresponds to a steady state and 
#' each column corresponds to a node of the network
#' The valid values are:
#'    1: active
#'    0: inactive
#'    *: non-determined
#'    
#' @param j.query Griffin query
#' @param df.transition dataframe with valid states in order
#' @return query java query to run Griffin
#' 
#' @examples
#' transition = data.frame(a=c(1,1), b=c(0,1), c=c(0,0),
#'                   stringsAsFactors = F )
#' q = addGqueryTransition(q, transition)
#' @export
#' 
addGqueryTransition <- function(j.query, df.transition) {
  nodes = .jcall(j.query,returnSig = "[Ljava/lang/String;","getGenesAsString")
  df.transition = validateStates(df.transition, nodes)
  df.transition = apply(df.transition, 1, function(x) { paste(x, collapse = '')  })
  df.transition = data.frame(source = df.transition[-length(df.transition)], 
                   target = df.transition[-1],
                   stringsAsFactors = F )
  apply(df.transition, 1, function(x) {
    .jcall(j.query,returnSig="V", "addStateTransition",x[[1]],x[[2]])
  })
  return(j.query)
}



#' Add a trapspace to a Griffin query.
#' 
#' Add a trapspace to a Griffin query.
#' The function takes a dataframe with the trapspace where the row corresponds to it 
#' each column corresponds to a node of the network
#' The valid values are:
#'    1: active
#'    0: inactive
#'    *: non-determined
#'    
#' @param j.query Griffin query
#' @param df.trapspace dataframe with valid trapspace
#' @return query java query to run Griffin
#' 
#' @examples
#' trap = data.frame(a=c(1), b=c('*'), c=c('*'),
#'                   stringsAsFactors = F )
#' q = addGqueryTrapspace(q, trap)
#' @export
#' 
addGqueryTrapspace <- function(j.query, df.trapspace) {
  nodes = .jcall(j.query,returnSig = "[Ljava/lang/String;","getGenesAsString")
  df.trapspace = validateStates(df.trapspace, nodes)
  df.trapspace = apply(df.trapspace, 1, function(x) { paste(x, collapse = '')  })
  .jcall(j.query,returnSig = "V","addSubspace",df.trapspace)
  return(j.query)
}




