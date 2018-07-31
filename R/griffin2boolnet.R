
#' Create a BoolNet net from a string
#' @keywords internal
#' 
string2boolnet <- function (griffin.str.net, bodySeparator = ",", lowercaseGenes = FALSE,symbolic = FALSE) 
{
  if(  !("BoolNet" %in% (.packages()))  ) warning("BoolNet is not attached")
  #func <- readLines(file, -1)
  func <- unlist(strsplit(griffin.str.net, '\n'))
  func <- gsub("#.*", "", BoolNet:::trim(func))
  func <- func[nchar(func) > 0]
  if (length(func) == 0) 
    stop("Header expected!")
  header <- func[1]
  header <- tolower(BoolNet:::trim(strsplit(header, bodySeparator)[[1]]))
  if (length(header) < 2 || header[1] != "targets" || !(header[2] %in% 
                                                        c("functions", "factors")) || (length(header) == 3 && 
                                                                                       header[3] != "probabilities")) 
    stop(paste("Invalid header:", func[1]))
  func <- func[-1]
  if (lowercaseGenes) 
    func <- tolower(func)
  func <- gsub("[^\\[\\]a-zA-Z0-9_\\|\\&!\\(\\) \t\\-+=.,]+", 
               "_", func, perl = TRUE)
  tmp <- unname(lapply(func, function(x) {
    bracketCount <- 0
    lastIdx <- 1
    chars <- strsplit(x, split = "")[[1]]
    res <- c()
    if (length(chars) > 0) {
      for (i in seq_along(chars)) {
        if (chars[i] == "(") 
          bracketCount <- bracketCount + 1
        else if (chars[i] == ")") 
          bracketCount <- bracketCount - 1
        else if (chars[i] == bodySeparator && bracketCount == 
                 0) {
          res <- c(res, BoolNet:::trim(paste(chars[lastIdx:(i - 
                                                    1)], collapse = "")))
          lastIdx <- i + 1
        }
      }
      res <- c(res, BoolNet:::trim(paste(chars[lastIdx:length(chars)], 
                               collapse = "")))
    }
    return(res)
  }))
  targets <- sapply(tmp, function(rule) BoolNet:::trim(rule[1]))
  for (target in targets) {
    if (regexec("^[a-zA-Z_][a-zA-Z0-9_]*$", target)[[1]] == 
        -1) 
      stop(paste("Invalid gene name:", target))
  }
  factors <- sapply(tmp, function(rule) BoolNet:::trim(rule[2]))
  temporal <- length(grep("timeis|timelt|timegt|\\[|\\]", factors, 
                          ignore.case = TRUE) > 0)
  if (temporal && !symbolic) {
    warning("The network contains temporal elements. This requires loading the model with symbolic=TRUE!")
    symbolic <- TRUE
  }
  probabilities <- sapply(tmp, function(rule) {
    if (length(rule) >= 3) 
      as.numeric(BoolNet:::trim(rule[3]))
    else 1
  })
  factors.tmp <- lapply(factors, BoolNet:::matchNames)
  genes <- unique(c(targets, unname(unlist(factors.tmp))))
  isProbabilistic <- (length(unique(targets)) < length(targets))
  if (symbolic) {
    if (isProbabilistic) 
      stop("Probabilistic networks cannot be loaded with symbolic=TRUE!")
    interactions <- lapply(factors, function(rule) parseBooleanFunction(rule, 
                                                                        genes))
    onlyInputs <- setdiff(genes, targets)
    if (length(onlyInputs) > 0) {
      for (gene in onlyInputs) {
        warning(paste("There is no transition function for gene \"", 
                      gene, "\"! Assuming an input!", sep = ""))
        interactions[[gene]] = parseBooleanFunction(gene, 
                                                    genes)
      }
    }
    delays <- apply(sapply(interactions, maxTimeDelay, genes = genes), 
                    1, max)
    names(interactions) <- genes
    fixed <- as.integer(sapply(interactions, function(int) {
      if (int$type == "constant") int$value else -1L
    }))
    names(fixed) <- genes
    res <- list(genes = genes, interactions = interactions, 
                fixed = fixed)
    res$internalStructs <- .Call("constructNetworkTrees_R", 
                                 res)
    res$timeDelays <- delays
    class(res) <- "SymbolicBooleanNetwork"
    return(res)
  }
  else {
    fixed <- rep(-1, length(genes))
    names(fixed) <- genes
    interactions <- list()
    for (i in seq_along(targets)) {
      target <- targets[i]
      interaction <- BoolNet:::generateInteraction(factors[i], genes)
      if (isProbabilistic) {
        interaction$probability <- probabilities[i]
        interactions[[target]][[length(interactions[[target]]) + 
                                  1]] <- interaction
      }
      else {
        if (length(interaction$func) == 1) {
          fixed[target] <- interaction$func
        }
        interactions[[target]] <- interaction
      }
    }
    onlyInputs <- setdiff(genes, targets)
    if (length(onlyInputs) > 0) {
      for (gene in onlyInputs) {
        warning(paste("There is no transition function for gene \"", 
                      gene, "\"! Assuming an input!", sep = ""))
        if (isProbabilistic) 
          interactions[[gene]][[1]] = list(input = length(interactions) + 
                                             1, func = c(0, 1), expression = gene, probability = 1)
        else interactions[[gene]] = list(input = length(interactions) + 
                                           1, func = c(0, 1), expression = gene)
      }
    }
    if (isProbabilistic) {
      wrongProb <- sapply(interactions, function(interaction) {
        abs(1 - sum(sapply(interaction, function(func) func$probability))) > 
          1e-04
      })
      if (any(wrongProb)) 
        stop(paste("The probabilities of gene(s) ", paste(genes[wrongProb], 
                                                          collapse = ", "), " do not sum up to 1!", sep = ""))
    }
    res <- list(interactions = interactions, genes = genes, 
                fixed = fixed)
    if (isProbabilistic) 
      class(res) <- "ProbabilisticBooleanNetwork"
    else class(res) <- "BooleanNetwork"
    return(res)
  }
}





#' Convert a data frame with nodes displayed in Boolean format to a BoolNet attractor.
#' 
#' Convert a data frame with nodes displayed in Boolean format to a BoolNet attractor. First column is the attractor number, second is the number of state inside the attractor, the rest of the columns correspond to each node.
#'
#' @param Dataframe, see\code{\link{attractor2dataframe}} each column corresponds to the number of attractor, state, or node
#' @param fixedGenes fixedGenes of network
#' @return attr BoolNet attractor object
#' @export
#' @examples
#' > data("cellcycle")
#' > attr <- getAttractors(cellcycle)
#' > attr.df <- attractor2dataframe(attr)
#' > print(dataframe2attractor(attr.df))
dataframe2attractor <- function(df, fixedGenes) {
  if(  !("BoolNet" %in% (.packages()))  ) warning("BoolNet is not attached")
  bin2intState <- function(x){ 
    x <- rev(x)
    sum(2^(which(rev(unlist(strsplit(as.character(x), "")) == 1))-1))
  }
  attractors = vector("list", length = max(df$attractor))
  #df <- df[seq(dim(df)[1],1),]
  for(i in 1:nrow(df)) {
    row <- df[i,]
    n <- row[[1]]
    state <- bin2intState(row[c(-1,-2)])
    attractors[[ n ]] <- c(attractors[[ n ]], state)
  }
  for (i in seq(length(attractors))) {
    l = length(attractors[[i]])
    attractors[[i]] <- list(
      involvedStates = array(attractors[[i]], dim=c(1,l)),
      basinSize = NA
    )  
  }
  node.names <- colnames(df)[c(-1,-2)]
  if (missing(fixedGenes)) {
    fixedGenes <- rep(-1, length(attr$stateInfo$genes))
    names(fixedGenes) <- node.names
  }
  stateInfo = list( genes = node.names, fixedGenes = fixedGenes )
  
  result <- list( stateInfo = stateInfo,attractors = attractors )
  class(result) <- "AttractorInfo"
  result
}