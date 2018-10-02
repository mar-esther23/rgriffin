#' Check if the states are of the correct size, order, characters and type.
#' @keywords internal
#' @export
#' 
validateStates <- function(df.attr, nodes) {
  # check size and valid nodes
  if (! setequal(colnames(df.attr), nodes)) stop("Unequeal nodes between interaction table and gene list")
  df.attr = df.attr[, nodes] #reorder
  df.attr = data.frame(lapply(df.attr, as.character), stringsAsFactors=FALSE) # to character
  unique = unique(unlist(df.attr)) # only valid characters
  if (! all(unique %in% c('0','1','*'))) stop("Non-valid attractor")
  return(df.attr)
}

#' Convert integer to binary state vector with node names.
#' '
#' @param x input integer representing the state
#' @param node.names network node names
#' @return Numeric binary vector of the same length as the number of nodes. Each 
#'     position corresponds to a node of the network. The values of each element 
#'     are 0 or 1. The name of each element corresponds to the name of the node in
#'     that position in the network.
#' @seealso \code{\link{intToBits}} which this function wraps
#' 
#' @examples
#' data(cellcycle)
#' int2binState(162,cellcycle$genes)
#' 
#' @keywords internal
#' @export
#' 
int2binState <- function(x, node.names){ 
  state <- as.integer( intToBits(x)[1:length(node.names)] )  
  names(state) <- node.names
  state
}



