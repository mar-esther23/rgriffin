#' Default options for initializing the java virtual machine
#' This options are passed to .jinit() as parameters
#' The first option is the OverheadLinit
#' The second is the RAM that griffin can use

jvm.param = "-XX:-UseGCOverheadLimit -Xmx15000m "