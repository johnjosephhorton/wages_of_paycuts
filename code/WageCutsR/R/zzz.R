#' Loads parameters 
#' 
#' Loads parameters used by other functions, such as the number of stars to use. 
#' 
#' @return None
   
.onLoad <- function(libname = find.package("WageCutsR"), pkgname = "WageCutsR"){
    star.cutoffs <<- c(0.1, 0.05, 0.01)
}
