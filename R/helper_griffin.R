#' Check if the states are of the correct size, order, characters and type.
#' @keywords internal
#'
validate.states <- function(df.attr, nodes) {
  # check size and valid nodes
  if (! setequal(colnames(df.attr), nodes)) stop("Unequeal nodes between interaction table and gene list")
  df.attr = df.attr[, nodes] #reorder
  df.attr = data.frame(lapply(df.attr, as.character), stringsAsFactors=FALSE) # to character
  unique = unique(unlist(df.attr)) # only valid characters
  if (! all(unique %in% c('0','1','*'))) stop("Non-valid attractor")
  return(df.attr)
}


