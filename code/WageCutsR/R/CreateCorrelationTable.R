#' Returns a table showing worker error rates. 
#' 
#' Returns a string of a table showing worker error rates. 
# ' 
#' @return  
#' @export

library(xtable)

CreateCorrelationTable <- function(out.file){
    data("df_no_1")
    X <- subset(df_no_1, select = c(advice.z, trust.z, survey, patient))
    xtable::print.xtable(xtable(corstarsl(X),
                        caption = "Correlation matrix for consummate performance measures",
                        label = "tab:cor"),
                 caption.placement = "top",
                 file = out.file)
}


