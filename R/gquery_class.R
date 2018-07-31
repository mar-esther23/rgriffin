#' print query
#' @keywords internal
#' @export
print.jobjRef <- function(j.query) {
  text = .jcall(j.query,returnSig = "S","asString",evalString = TRUE)
  text = gsub('^.|.$', '', text)
  text = gsub("Gene Regulation Specification. ", "Gene Regulation Specification; ", text)
  text = gsub(" = true", "=1", text)
  text = gsub(" = false", "=0", text)
  text = gsub(";", "\n", text)
  cat(text)
}

#' setClass("gquery",contains = "jobjRef")
#' 
#' #' print query
#' #' @export
#' print.gquery <- function(j.query) {
#'   text = .jcall(j.query,returnSig = "S","asString",evalString = TRUE)
#'   text = gsub('^.|.$', '', text)
#'   text = gsub("Gene Regulation Specification. ", "Gene Regulation Specification; ", text)
#'   text = gsub(" = true", "=1", text)
#'   text = gsub(" = false", "=0", text)
#'   text = gsub(";", "\n", text)
#'   cat(text)
#' }