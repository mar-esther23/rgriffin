#' Obtain the attractors and basins from a BoolNet network using symbolic methods.
#' 
#' This function takes a valid BoolNet BooleanNetwork.
#' and returns the attractors and, if requiered basin size and basin formula of the network using a binary decision tree based method.
#' The process may be memory intensive for large networks. To avoid 
#' edge cases use fully parantherized formulas.
#'
#' @param net BoolNet BooleanNetwork
#' @param return 
#'        "DataFrame"  returns a dataframe with the attractor in Boolean
#'        format where cyclic states may use more than one row. The 
#'        basinSize and basinFormula are added as columns
#'        "AttractorInfo"  returns a BoolNet attractor object. The 
#'        basinSize and basinFormula are added to attractor$attractor.
#'
#' @return 
#'       If "DataFrame" it will return a dataframe wherethe first column corresponds to the number of the atrractor and the second to the state in the case of cyclic atractors the attractor will take multiple states. The rest of the columns correspond to the value if he nodes, tha basinSize and basiFormula.
#'       If "AtractorInfo" return a BoolNet attractor object where basinSize and basinFormula are in attactor$attractors
#' 
#' @seealso 
#' Compare and contrast with \code{\link{BoolNet:getAttractors}} SAT based options.
#' 
#' @examples
#' data("cellcycle")
#' attr = getBasins( cellcycle )
#' print( attr )
#' 
#' @export
getBasins <- function(net, return=c("DataFrame","AttractorInfo") ) {
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
  
  # make query
  controller = .jnew("mx/unam/iimas/griffin/r/GriffinController")
  m = .jcall(controller,returnSig = "S","computeLimitSetInducedPartition",inter,evalString = TRUE)
  # query to df
  m <- gsub(",","\\\n",m)
  df <- read.table(text=m, sep=":", 
                   col.names=c("attractor","state", net$genes,"basinSize","basinFormula"),
                   stringsAsFactors = F)
  if (return=="DataFrame") return(df)
  dataframeToAttractor(df, net$genes)
}


#library(BoolNet)
#data(cellcycle)
#df <-  findAttractors(cellcycle)
#node.names <- cellcycle$genes
#fixed.genes <- NULL
#df
#findAttractors(cellcycle, return="AttractorInfo")
