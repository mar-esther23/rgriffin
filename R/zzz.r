# TODO:
# [ ] In documentation definition of r-graph
# [ ] Automathicaly detect griffin path
# 
# Future:
# [ ] add.gquery.mutant.cycle <- function(nodes, values, df){future}
# [ ] add.gquery.functions <- function(df) {future}
# [ ] add.gquery.labels  <- function(df) {future} 



#' Initialize jvm 
#' @keywords internal
#' 
.onLoad <- function(lib, pkg, ...) {
  griffin.path = paste0(system.file(package = "rGriffin"),"/java/")
  griffin.dirs = c("bin","lib")
  files = list.files(paste(griffin.path,griffin.dirs,sep=""),pattern="\\.jar$",full.names=TRUE)
  params = c(strsplit(Sys.getenv("GRIFFIN_JVM_OPTIONS"),"\\s+")[[1]],
             paste("-Dlog4j.configuration=file:",griffin.path,"conf/log4j.properties",sep=""))
  #JVM initialization
  .jinit(parameters=params)
  .jaddClassPath(".")
  .jaddClassPath(paste(griffin.path,"conf",sep=""))
  for(f in files){ .jaddClassPath(f) }
  
}

#' 
#' griffin.path = Sys.getenv("GRIFFIN_HOME")
#' if (all.equal(griffin.path, "")) griffin.path = "/home/esther/griffin-0.1.6/"
#' 
#' #' Init java and griffin
#' init.rjava.griffin <- function(griffin.path) {
#'   griffin.dirs = c("bin","lib")
#'   print(griffin.path)
#'   files = list.files(paste(griffin.path,griffin.dirs,sep=""),pattern="\\.jar$",full.names=TRUE)
#'   params = c(strsplit(Sys.getenv("GRIFFIN_JVM_OPTIONS"),"\\s+")[[1]],
#'              paste("-Dlog4j.configuration=file:",griffin.path,"conf/log4j.properties",sep=""))
#'   
#'   #JVM initialization
#'   library(rJava)
#'   .jinit(parameters=params)
#'   .jaddClassPath(".")
#'   .jaddClassPath(paste(griffin.path,"conf",sep=""))
#'   for(f in files){ .jaddClassPath(f) }
#' }
#' 
#' 
#' 
