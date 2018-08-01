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
  init.griffin(force.init=FALSE)
}

#' Initialize the Java Virtual Machine (JVM) and create a connection with griffin
#' 
#' Initialize the Java Virtual Machine (JVM) and create a connection with griffin.
#' By default it takes the parameters from the "java/jvm-param.R" file. To change the defaults modify this file in your rgriffin folder
#'  
#' @param jvm.param string with parameters to initialize the jvm. 
#' @param force.init If set to TRUE JVM is re-initialized even if it is already running.
#' 
#' @example 
#' #initialize griffin with only 2GB of RAM
#' init.griffin("-XX:-UseGCOverheadLimit -Xmx2000m ")
#' 
#' @export
init.griffin <- function(jvm.param="", force.init=TRUE) {
  #Load all variables
  griffin.path = paste0(system.file(package = "rGriffin"),"/java/")
  griffin.dirs = c("bin","lib")
  files = list.files(paste(griffin.path,griffin.dirs,sep=""),pattern="\\.jar$",full.names=TRUE)
  if (all.equal(jvm.param,"")) source(paste0(griffin.path,"jvm-param.R")) #load jvm.param from conf file
  params = paste0(jvm.param, "-Dlog4j.configuration=file:",
                  griffin.path,"conf/log4j.properties")
  
  #JVM initialization
  .jinit(parameters=params)
  .jaddClassPath(".")
  .jaddClassPath(paste(griffin.path,"conf",sep=""))
  for(f in files){ .jaddClassPath(f) }
}

