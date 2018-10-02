#' Returns the topology with signs of a network
#' 
#' Takes a BoolNet network
#' Returns a DataFrame of the form: Source, Target, Interaction
#' Interactions types can be:
#'     '+'  : Mandatory, positive, unambiguous
#'     '-'  : Mandatory, negatice, unambiguous
#'     'MA' : Mandatory, ambiguous
#'     'NR' : Non-functional regulation
#' 
#' @param net BoolNet function
#' @return df.graph dataframe with source and target nodes and the type of interactions
#' @export
#' 
getNetTopology <- function(net) {
  if(  !("BoolNet" %in% (.packages()))  ) warning("BoolNet is not attached")
  df <- data.frame(matrix(vector(), 0, 3,
                          dimnames=list(c(), c("Source","Target","Interaction"))),
                   stringsAsFactors=F)
  for (i in net$genes) {
    for (j in net$genes) {
      sign = getInteractionSign(j, i, net)
      if (!is.null(sign)) {
        de = data.frame(j,i,sign, stringsAsFactors=F)
        names(de) <- c("Source","Target","Interaction")
        df = rbind(df, de)
      }
    }
  }
  return(df)
}



#' Determine the sign of the interaction between two elements of a network
#' 
#' Returns a dataframe with the following interaction types:
#'     '+'  : Mandatory, positive, unambiguous
#'     '-'  : Mandatory, negatice, unambiguous
#'     'MA' : Mandatory, ambiguous
#'     'NR' : No regulation
#'     NULL : No interaction
#'     
#' @param source source node name
#' @param target target node name
#' @param net BoolNet function  
#' @return interaction str interaction type between source and target
#' @keywords internal
#' 
getInteractionSign <-  function(source, target, net) {
  if (! source %in% net$genes) stop(paste(source, "is not in network"))
  if (! target %in% net$genes) stop(paste(target, "is not in network"))
  # get target interaction
  inter = net$interactions[[target]]
  # check if interaction exists
  index <- match(source, net$genes)
  if (! index %in% inter$input) return(NULL)
  index = match(index, inter$input)
  jump  = 2^(length(inter$input)-index)
  #print(c(source, index, jump))
  #print(inter$func)
  
  check = seq(length(inter$func))
  sign = c()
  #print(check)
  while (length(check)>0) {
    i = check[1]
    #print(c('index',i, i+jump,' ',inter$func[i], inter$func[i+jump]))
    if (inter$func[i] < inter$func[i+jump]) sign = c(sign,'+')
    if (inter$func[i] > inter$func[i+jump]) sign = c(sign,'-')
    check = check[! check %in% c(i, i+jump)]
    #print(check)
  }
  #print(sign)
  if (length(sign)==0)  return('NA')
  if (all(sign=='+'))   return('+')
  if (all(sign=='-'))   return('-')
  return('MA')
}



#' Convert a BoolNet attractor to dataframe.
#'
#' If Booleans converts a BoolNet attractor to data frame with nodes displayed in Boolean format. First column is the attractor number, second is the number of state inside the attractor, the rest of the columns correspond to each node.
#' If not Boolean it converts a BoolNet attractor to dataframe with properties as columns. The rownames correspond to the int value of each attractor, in the case of cycles the state are joined by sep. Each property of attr$attractors corresponds to a dataframe column. If the property has elements with length > 1 it converts them to a string and joins them with sep.
#' 
#' @param attr BoolNet attractor object
#' @param node.names node names, by default taken from attractor object 
#' @param sep string to join elements with length > 1, default "/"
#' @param Boolean return attractor in Boolean or integer format, default FALSE
#' @return If Boolean=TRUE return dataframe, each column corresponds to the numebr of attractor, state, or node. If Boolean=FALSE return dataframe, each column corresponds to a property of the attractor
#'
#' @examples
#' attr <- getAttractors(cellcycle)
#' attractorToDataframe(attr)
#' #              involvedStates basinSize
#' #1                        162       512
#' #2 25/785/849/449/389/141/157       512
#' 
#' attractorToDataframe(attr, Boolean=TRUE)
#' #   attractor state CycD Rb E2F CycE CycA p27 Cdc20 Cdh1 UbcH10 CycB
#' #1         1     1    0  1   0    0    0   1     0    1      0    0
#' #2         2     1    1  0   0    1    1   0     0    0      0    0
#' #3         2     2    1  0   0    0    1   0     0    0      1    1
#' #4         2     3    1  0   0    0    1   0     1    0      1    1
#' #5         2     4    1  0   0    0    0   0     1    1      1    0
#' #6         2     5    1  0   1    0    0   0     0    1      1    0
#' #7         2     6    1  0   1    1    0   0     0    1      0    0
#' #8         2     7    1  0   1    1    1   0     0    1      0    0
attractorToDataframe <- function(attr, sep="/", node.names=NULL, Boolean=FALSE) {
  if (Boolean) {
    if (is(attr, "AttractorInfo")) {
      if (is.null(node.names)) node.names <- attr$stateInfo$genes
      attr <- sapply(attr$attractors, function(a) paste(a$involvedStates, collapse=sep) )
    }
    if (is.null(node.names)) stop("Invalid node.names")
    if (is.list(attr)) { attr <- unlist(attr) }
    
    df <- data.frame(matrix(ncol=length(node.names)+2, nrow=0))
    for (i in seq(length(attr))) {
      s <- attr[i]
      if(is.character(s)) s<-unlist(strsplit(s,sep))
      for (j in seq(length(s))) {
        df <- rbind(df, c(attractor=i,state=j,int2binState(s[j],node.names)))
      }
    }
    colnames(df)<-c('attractor','state',node.names)
    return(df)
  }
  
  else {
    # check if valid attr object
    if (!is(attr, "AttractorInfo")) { stop("Error: non-valid attractor") }
    attr <- attr$attractors
    # create properties list, if labeled we will have more
    attr.properties <- vector("list", length(attr[[(1)]]))
    names(attr.properties) <- names(attr[[(1)]])
    #print(attr.properties)
    
    for (n in names(attr.properties) ) { #create list for each property
      attr.properties[[n]] <- lapply(attr, function(a) a[[n]]) 
      #verify number of elements inside list
      ncol <- max(sapply(attr.properties[[n]], length))
      if ( ncol > 1) { #collapse
        attr.properties[[n]] <- sapply(attr.properties[[n]], function(a) {
          paste(as.character(a), collapse=sep)
        })}
      attr.properties[[n]] <- unlist(attr.properties[[n]])
      #print(attr.properties[[n]])
    }
    return(data.frame(attr.properties, stringsAsFactors=F))
  }
}
















#' Convert a BoolNet attractor to dataframe.
#'
#' If Booleans converts a BoolNet attractor to data frame with nodes displayed in Boolean format. First column is the attractor number, second is the number of state inside the attractor, the rest of the columns correspond to each node.
#' If not Boolean it converts a BoolNet attractor to dataframe with properties as columns. The rownames correspond to the int value of each attractor, in the case of cycles the state are joined by sep. Each property of attr$attractors corresponds to a dataframe column. If the property has elements with length > 1 it converts them to a string and joins them with sep.
#' 
#' @param attr BoolNet attractor object
#' @param node.names node names, by default taken from attractor object 
#' @param sep string to join elements with length > 1, default "/"
#' @param Boolean return attractor in Boolean or integer format, default FALSE
#' @return If Boolean=TRUE return dataframe, each column corresponds to the numebr of attractor, state, or node. If Boolean=FALSE return dataframe, each column corresponds to a property of the attractor
#'
#' @examples
#' attr <- getAttractors(cellcycle)
#' attractorToDataframe(attr)
#' #              involvedStates basinSize
#' #1                        162       512
#' #2 25/785/849/449/389/141/157       512
#' 
#' attractorToDataframe(attr, Boolean=TRUE)
#' #   attractor state CycD Rb E2F CycE CycA p27 Cdc20 Cdh1 UbcH10 CycB
#' #1         1     1    0  1   0    0    0   1     0    1      0    0
#' #2         2     1    1  0   0    1    1   0     0    0      0    0
#' #3         2     2    1  0   0    0    1   0     0    0      1    1
#' #4         2     3    1  0   0    0    1   0     1    0      1    1
#' #5         2     4    1  0   0    0    0   0     1    1      1    0
#' #6         2     5    1  0   1    0    0   0     0    1      1    0
#' #7         2     6    1  0   1    1    0   0     0    1      0    0
#' #8         2     7    1  0   1    1    1   0     0    1      0    0
#' @export
attractorToDataframe <- function(attr, sep="/", node.names=NULL, Boolean=TRUE) {
  if(  !("BoolNet" %in% (.packages()))  ) warning("BoolNet is not attached")
  if (Boolean) {
    if (is(attr, "AttractorInfo")) {
      if (is.null(node.names)) node.names <- attr$stateInfo$genes
      attr <- sapply(attr$attractors, function(a) paste(a$involvedStates, collapse=sep) )
    }
    if (is.null(node.names)) stop("Invalid node.names")
    if (is.list(attr)) { attr <- unlist(attr) }
    
    df <- data.frame(matrix(ncol=length(node.names)+2, nrow=0))
    for (i in seq(length(attr))) {
      s <- attr[i]
      if(is.character(s)) s<-unlist(strsplit(s,sep))
      for (j in seq(length(s))) {
        df <- rbind(df, c(attractor=i,state=j,int2binState(s[j],node.names)))
      }
    }
    colnames(df)<-c('attractor','state',node.names)
    return(df)
  }
  
  else {
    # check if valid attr object
    if (!is(attr, "AttractorInfo")) { stop("Error: non-valid attractor") }
    attr <- attr$attractors
    # create properties list, if labeled we will have more
    attr.properties <- vector("list", length(attr[[(1)]]))
    names(attr.properties) <- names(attr[[(1)]])
    #print(attr.properties)
    
    for (n in names(attr.properties) ) { #create list for each property
      attr.properties[[n]] <- lapply(attr, function(a) a[[n]]) 
      #verify number of elements inside list
      ncol <- max(sapply(attr.properties[[n]], length))
      if ( ncol > 1) { #collapse
        attr.properties[[n]] <- sapply(attr.properties[[n]], function(a) {
          paste(as.character(a), collapse=sep)
        })}
      attr.properties[[n]] <- unlist(attr.properties[[n]])
      #print(attr.properties[[n]])
    }
    return(data.frame(attr.properties, stringsAsFactors=F))
  }
}
