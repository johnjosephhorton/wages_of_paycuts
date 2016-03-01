#' Returns a table showing worker error rates. 
#' 
#' Returns a string of a table showing worker error rates. 
# ' 
#' @return  
#' @export

library(stargazer)

CreateUptakeUnframedCutTable <- function(out.file){
    data('df_no_3')
    df.unframed <- subset(df_no_3, group %in% c("WageCut", "UnframedWC"))
    df.unframed$group <- with(df.unframed, factor(group))
    df.unframed <- within(df.unframed, group <- relevel(group, ref = "WageCut"))
                                        # fit models
    m.unframed <- lm(add ~ group, data = df.unframed)
    df.unframed.10c <- subset(df_no_3, group %in% c("Control", "UnframedWC"))
    df.unframed.10c$group <- with(df.unframed.10c, factor(group))
    df.unframed.10c <- within(df.unframed.10c, relevel(group, ref = "Control"))                          
    m.unframed.10c <- lm(add ~ group, data = df.unframed.10c)
                             
    sink(tempfile(file = "garbage"))
    s <- stargazer::stargazer(m.unframed, m.unframed.10c, 
               title = "The effect of not explicitly framing the wage cut as a decision to continue working", 
               dep.var.labels = c("Transcribe additional paragraph? (\\textsc{AddPara} = 1)"),
               label = "tab:uptake_unframed", 
               no.space = TRUE,
               align = TRUE, 
               font.size = "footnotesize", 
               covariate.labels = c("Unframed wage cut, \\textsc{UnframedWC}"),
               add.lines = list(c("Comparison Group", "\\multicolumn{1}{c}{\\textsc{WageCut}}", "\\multicolumn{1}{c}{\\textsc{Control}}")), 
               star.cutoffs = star.cutoffs, 
               omit.stat = c("aic", "f", "adj.rsq", "bic", "ser"),
               type = "latex")
    sink()
    note <- c("\\\\ ",
          "\\begin{minipage}{0.80 \\textwidth}",
          "\\emph{Notes:}
This table reports OLS regressions where the dependent variable is an indicator for whether the worker subject was willing to transcribe a fourth paragraph.
In Column~(1), the independent variable is an indicator for assignment to \\textsc{UnframedWC}, the unframed wage cut.
The comparison group is \\textsc{WageCut}.
In Column~(2) the comparison group is instead \\textsc{Control}, in which subjects received a 10 cent offer to perform an additional transcription. 
Standard errors are robust. 
\\starlanguage",
          "\\end{minipage}")
    AddTableNote(s, out.file, note)
}
