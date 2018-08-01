#' Run a Griffin query from an interaction graph.
#' 
#' This function takes a valid gquery created with create.gquery and add.gquery methods
#' and returns the set of boolean networks that satisfy the query.
#' 
#' @param query Griffin query
#' @param return 
#'        "all" return all networks as strings
#'        "files" save all networks as files in "folder.name/network.name-index.csv"
#'        "iterator" returns rjava controller     
#'        "BoolNet"  returns a BoolNet iterator
#' @param network.name network name to save networks as files, default "net"
#' @param folder.name folder name to save networks, default date+time
#' @param allow.hypothesis activate or deactivate hypothetical regulations
#' @param allow.additional.states allows networks with additional fixed-point attractors to those specified in the query
#' @param allow.additional.cycles allows networks with additional cyclic attractors to those specified in the query
#' @param allow.ambiguity allow ambiguous networks, if true ambiguous regulations may appear in the solutions
#' @param block.steady.a.posteriori use model checking and clause learning instead of enforceing fixed-point attractors in the query
#' @param divide.query.by.topology divide the query into multiple queries by query splitting methods
#' @param divide.method 
#'        "radial": computes centres as regulation graphs with no hypotheses and explores adding combinations of 
#'                the hypothetical regulations, the number of simultaneous regulations equals the radius
#'        "sequential": sets an interval for the exploration, regulation graphs are ennumerated in a lexicographic order
#' @param value.divide.radius (radial only) max number of simultaneous hypotheses used
#' @param value.divide.range (sequential only) constrain in the exploration of the graphs
#' @param return.network.limit maximum number of Boolean networks to return, if NULL there will be no limit
#' 
#' @return 
#' 
#' @examples
#' # Define the query
#' genes = c('a','b','c')
#' inter = data.frame(source=c('a','b','b','c','c'), 
#'                    target=c('b','b','c','b','c'), 
#'                    type=c('+','+','-','-','+'),
#'                    stringsAsFactors = F )
#' q = create.gquery.graph(inter, genes)
#' attr = data.frame(a=c(0,'*',0), 
#'                   b=c(0,1,0), 
#'                   c=c(0,0,1),
#'                   stringsAsFactors = F )
#' q = add.gquery.attractors(q, attr)
#' print( q )
#' 
#' # Run the query
#' nets = run.gquery(q)
#' print( nets )
#' 
#' # Get BoolNet iterator
#' nets = run.gquery(q, return="BoolNet")
#' nets
#' nextElem(nets)
#' 
#' 
#' @export

run.gquery <- function(query, 
                       return=c("strings","files","iterator","BoolNet"),
                       folder.name=NULL,
                       network.name=NULL,
                       allow.hypothesis=F,
                       allow.additional.states=F,
                       allow.additional.cycles=F,
                       allow.ambiguity=F,
                       block.steady.a.posteriori=T,
                       divide.query.by.topology=F,
                       divide.method=c("radial","sequential"),
                       value.divide.radius=3,
                       value.divide.range="1,3",
                       return.network.limit=NULL
) {
  #setting Griffin query options
  if (allow.hypothesis) { #activate or deactivate hypothetical regulations
    .jcall(query,returnSig = "V","addOption","allow.hypotheses","true")}
  if (allow.additional.states) { #allows networks with additional fixed-point attractors to those specified in the query
    .jcall(query,returnSig = "V","addOption", "allow.additional.states","true") }
  if (allow.additional.cycles) { #allows networks with additional cyclic attractors to those specified in the query
    .jcall(query,returnSig = "V","addOption","allow.additional.cycles","true") }
  if (allow.ambiguity) { #allow ambiguous networks, if true ambiguous regulations may appear in the solutions
    .jcall(query,returnSig = "V", "addOption","allow.ambiguity","true") }
  if (block.steady.a.posteriori) {#use model checking and clause learning instead of enforceing fixed-point attractors in the query
    .jcall(query,returnSig = "V","addOption","block.steady.a.posteriori","true") }
  if (divide.query.by.topology) { #divide the query into multiple queries by query splitting methods
    .jcall(query,returnSig = "V","addOption","divide.query.by.topology","true")
    divide.method <- match.arg(divide.method)
    if (divide.method=="radial") { # radial: computes centres as regulation graphs with no hypotheses and explores adding combinations of 
      # the hypothetical regulations, the number of simultaneous regulations equals the radius
      .jcall(query,returnSig = "V","addOption","topology.iterator.type","radial")
      # (radial only) max number of simultaneous hypotheses used
      value.divide.radius = toString(value.divide.radius)
      .jcall(query,returnSig = "V","addOption","topological.distance.radius",value.divide.radius)
    }
    if (divide.method=="sequential") { # sequential: sets an interval for the exploration, 
      #regulation graphs are ennumerated in a lexicographic order
      .jcall(query,returnSig = "V","addOption","topology.iterator.type","sequential")
      # (sequential only) constrain in the exploration of the graphs
      .jcall(query,returnSig = "V","addOption","topology.range",value.divide.range)
    }
  }
  if (!is.null(return.network.limit)) {# maximum number of Boolean networks to return
    return.network.limit = toString(return.network.limit)
    .jcall(query,returnSig = "V","addOption","limit.boolean.networks",return.network.limit)
  }
  
  # Create controller to ask griffin for networks
  controller = .jnew("mx/unam/iimas/griffin/r/GriffinController",query)
  #print(controller)
  
  # return=c("all","files","iterator")
  return <- match.arg(return)
  if (return=="strings") {
    #iterate until empty
    res = c()
    n = .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(1))
    while (length(n)!=0) {
      res = c(res,n)
      n = .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(1))
    }
    return(res)
  }
  if (return=="files") {
    # save all networks to folder
    if (is.null(network.name)) network.name='net'
    if (is.null(folder.name)) folder.name=format(Sys.time(), '%y%m%d%H%M%S')
    dir.create(folder.name, showWarnings = FALSE)
    i = 1
    n = .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(1))
    while (length(n)!=0) {
      file = paste(folder.name,'/',network.name,'-',i,'.csv',sep = '')
      write(n, file)
      i = i+1
      n = .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(1))
    }
    return(c(folder.name,network.name))
  }
  if (return=="iterator") {
    library("iterators")
    return( griffin.model.iterator(controller) )
  }
  if (return=="BoolNet") {
    library("iterators")
    return( boolnet.model.iterator(controller) )
  }
}



###############
#  ITERATORS  #
###############

#' Iterates over griffin controller to return string networks
#' 
#' @param controller griffin controller created by run.query
#' @param n number of networks to return
#' @keywords internal
#' 
griffin.model.iterator <- function(controller,n=1) {
  nextEl <- function() {
    n <- .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(n))
    if (length(n)==0) stop('StopIteration')
    else return(n)
  }
  obj <- list(nextElem=nextEl)
  class(obj) <- c('griffin.model.iterator', 'abstractiter', 'iter')
  obj
}

#' Iterates over griffin controller to return string networks
#' 
#' @param controller griffin controller created by run.query
#' @param n number of networks to return
#' @keywords internal
#' 
boolnet.model.iterator <- function(controller,n=1) {
  nextEl <- function() {
    n <- .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(n))
    if (length(n)==0) stop('StopIteration')
    else {
      n <- gsub("false", "0", n)
      n <- gsub("true", "1", n)
      return( string2boolnet(n) )
    }
  }
  obj <- list(nextElem=nextEl)
  class(obj) <- c('griffin.model.iterator', 'abstractiter', 'iter')
  obj
}