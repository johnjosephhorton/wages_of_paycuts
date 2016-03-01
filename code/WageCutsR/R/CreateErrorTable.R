#' Returns a table showing worker error rates. 
#' 
#' Returns a string of a table showing worker error rates. 
# ' 
#' @return  
#' @export

library(stargazer)

CreateErrorTable <- function(out.file){
    data('df_no_3')
    #m <- lm(prior.error ~ add, data = df_no_3)
    df.error <- subset(df_no_3, e4 > 0 & e4 < 200)
    df.error$e4.z <- with(df.error, (log(e4) - mean(log(e4)) )/(sd(log(e4))))
    df.error$any.cut <- with(df.error, !(group %in% c("Control")))
    df.error.cuts <- subset(df.error, group != "Control")
    df.error.cuts$group <- with(df.error.cuts, factor(group))
    df.error.cuts <- within(df.error.cuts, group <- relevel(group, ref = "WageCut"))
    m.error.any <- lm(log(e4) ~ any.cut + prior.error, data = df.error)
    m.error.pe <- lm(log(e4) ~ group + prior.error, data = df.error.cuts)
    sink(tempfile(file = "garbage"))
    s <- stargazer::stargazer(m.error.any, m.error.pe, 
                              title = "Transcription errors in fourth paragraph among workers willing to accept the new offer", 
                              dep.var.labels = c("Log edit distance for the fourth paragraph"),
                              label = "tab:errors", 
                              no.space = TRUE,
                              align = TRUE, 
                              font.size = "footnotesize", 
                              covariate.labels = c(
                                  "\\textsc{AnyWageCut}",
                                  "\\textsc{FairnessPrimedWC}",
                                  "\\textsc{NeighborWC}",
                                  "\\textsc{ProductivityWC}",
                                  "\\textsc{ProfitWC}",
                                  "\\textsc{UnframedWC}",
                                  "Prior Error"), 
                              add.lines = list(c(
                                  "Comparison Group",
                                  "\\multicolumn{1}{c}{\\textsc{Control}}",
                                  "\\multicolumn{1}{c}{\\textsc{WageCut}}")), 
                              star.cutoffs = star.cutoffs, 
                              omit.stat = c("aic", "f", "adj.rsq", "bic", "ser"),
               type = "latex")
    sink()
    note <- c("\\\\ ",
              "\\begin{minipage}{0.65 \\textwidth}",
          "\\emph{Notes:}
This table reports OLS regressions where the dependent variable is the log edit distance for the fourth pargraph. 
In Column~(1), the independent variable is an indicator for assignment to any group where wages were cut. 
The comparison group is \\textsc{Control}.
In Column~(2) the comparison group is instead \\textsc{WageCut} and regressors are indicators for the remaining cells in which wages were cut. 
Both regressions include controls for worker error in the first phase of the experiment.
This prior error control is the log of the sum of edit distances for the first three paragraphs transcribed. 
Standard errors are robust.
\\starlanguage",
          "\\end{minipage}")
    AddTableNote(s, out.file, note)
}
