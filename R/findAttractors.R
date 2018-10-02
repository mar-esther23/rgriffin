library("BoolNet")
data(cellcycle)

#' Obtain the attractors and basins from a BoolNet network using symbolic methods.
#' 
#' This function takes a valid BoolNet BooleanNetwork
#' and returns the attractors of the network as a BoolNet AttractorInfo object or as a dataframe using Dubrova's method.
#' The function can also return the size of the basin of attractor or the formula that defines the basin using a binary decision tree based method.
#' To avoid problems use fully parantherized formulas. Griffin uses a left-right formula reader. 
#'
#' @param net BoolNet BooleanNetwork
#' @param return 
#'        "AttractorInfo"  returns a BoolNet attractor object. If requiered the 
#'        method will return the basinSize and basinFormula as properties in the 
#'        attr$attractors object.
#'        "DataFrame"  returns a dataframe with the attractor in Boolean format
#'        where cyclic states may use more than one row. If requiered the 
#'        method will return the basinSize and basinFormula as columns in the 
#'        attr$attractors object. For cyclic attractor it will add the properties 
#'        in all rows of the states of the attractor.
#' @param return.basin.size if true return the basin size using BDD methods
#' @param return.basin.formula if true return the basin formula
#'
#' @return 
#' 
#' @seealso 
#' Compare and contrast with \code{\link{BoolNet:getAttractors}} SAT based options. 
#' Also uses \code{\link{rGriffin:::attractor2dataframe}}.
#' 
#' @examples
#' # Define the query
#' data("cellcycle")
#' 
#' attr = find.attractors( cellcycle, return="DataFrame" )
#' print( attr )
#' 
#' @export
find.attractors <- function(net, return=c("AttractorInfo","DataFrame"),
                               return.basin.size=F, return.basin.formula=F) {
  if(  !("BoolNet" %in% (.packages()))  ) warning("BoolNet is not attached")
  if (! is(net,"BooleanNetwork")) stop("Network must be a valid BoolNet BooleanNetwork object")
  return <- match.arg(return)
  
  # Format network for java
  inter <- lapply(net$interactions, function(x) x$expression)
  inter <- paste0(net$genes, ":", inter)
  inter <- paste(inter, collapse=",")
  inter <- gsub("!","~",inter)
  no.valid =  c("maj\\(","sumgt\\(","sumlt\\(","sumis\\(","all\\(","any\\(")
  for (n in no.valid) {
    if (grepl(n,inter)) stop(paste("Non valid function:",n))
  }
  print(inter)
}

find.attractors(cellcycle)
