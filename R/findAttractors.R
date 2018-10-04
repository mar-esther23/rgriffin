#' Obtain the attractors and basins from a BoolNet network using symbolic methods.
#' 
#' This function takes a valid BoolNet BooleanNetwork.
#' and returns the attractors, basin size and basin formula of the network using a binary decision tree based method.
#' To avoid problems use fully parantherized formulas. Griffin uses a left-right formula reader that may cause problems. 
#'
#' @param net BoolNet BooleanNetwork
#' @param return 
#'        "DataFrame"  returns a dataframe with the attractor in Boolean format
#'        "AttractorInfo"  returns a BoolNet attractor object. 
#'        where cyclic states may use more than one row. If requiered the 
#'        method will return the basinSize and basinFormula as columns in the 
#'        attr$attractors object. For cyclic attractor it will add the properties 
#'        in all rows of the states of the attractor.
#'
#' @return 
#'       If "DataFrame" it will return a dataframe wherethe first column corresponds to the number of the atrractor and the second to the state in the case of cyclic atractors the attractor will take multiple states. The rest of the columns correspond to the value if he nodes, tha basinSize and basiFormula
#'       If "AtractorInfo" return a BoolNet attractor object where basinSize and basinFormula are in attactor$attractors
#' 
#' @seealso 
#' Compare and contrast with \code{\link{BoolNet:getAttractors}} SAT based options.
#' 
#' @examples
#' data("cellcycle")
#' attr = find.attractors( cellcycle )
#' print( attr )
#' 
#' @export
find.attractors <- function(net, return=c("DataFrame","AttractorInfo")) {
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
#df <-  find.attractors(cellcycle)
#node.names <- cellcycle$genes
#fixed.genes <- NULL
#df
#find.attractors(cellcycle, return="AttractorInfo")
