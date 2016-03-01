#' Returns a plot showing uptake of the offer by experimental group. 
#' 
#' Returns a ggplot2 plot of uptake. 
#' 
#' @return  
#' @export

library(Hmisc)
library(ggplot2)

CreateUptakeFigure <- function(){
    data('df')
    # compute Wilson CIs. 
    df$ymin = mapply(function(s,n) Hmisc::binconf(s,n)[2], df$s, df$n.obs)
    df$ymax = mapply(function(s,n) Hmisc::binconf(s,n)[3], df$s, df$n.obs)
   # Figure 
    g.uptake <- ggplot(data = df, aes(x = group, y = effect)) +
        geom_point() +
            geom_linerange(aes(ymin = ymin, ymax = ymax)) +
                theme_bw() +
                    facet_wrap(~meta, ncol = 5, scales = "free_x") +
                        ylab("Fraction of subjects completing \n an additional paragraph")  + 
                            xlab("Experimental groups") + 
                                theme(strip.text.y = element_text(size = 8, angle = 0)) +
                                    theme(axis.text.x = element_text(angle = 45, hjust = 1))
    g.uptake
}
