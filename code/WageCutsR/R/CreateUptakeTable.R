#' Returns a table showing worker error rates. 
#' 
#' Returns a string of a table showing worker error rates. 
# ' 
#' @return  
#' @export

library(stargazer)

CreateUptakeTable <- function(out.file){
    # construct dataset
    data("df_no_3")
    df.uptake <- subset(df_no_3, group %in% c("WageCut", "Control"))
    # fit models 
    m.uptake <- lm(add ~ group, data = df.uptake)
    m.uptake.c <- lm(add ~ group + uscan + male + prior.error, data = df.uptake)
    m.uptake.c.full <- lm(add ~ group * (uscan + male + prior.error),
                          data = df.uptake)
    # waldtest(m.uptake.c, m.uptake.c.full) - had this for some reason in code - not sure why. JJH. 
    sink(tempfile(file = "garbage"))
    s <- stargazer::stargazer(m.uptake, m.uptake.c, 
                              title = "Effect of a wage cut on willingness of the worker to perform an additional task",
                              dep.var.labels = c("Transcribe additional paragraph? (\\textsc{AddPara} = 1)"),
                              label = "tab:uptake_simple",
                              no.space = TRUE,
                              align = TRUE, 
                              font.size = "footnotesize", 
                              covariate.labels = c("Offered 3 cents for fourth transcription, \\textsc{WageCut}",
                                  "From US/CAN", "Male", "Prior Error"),
                              add.lines = list(c("Comparison Group", "\\multicolumn{1}{c}{\\textsc{Control}}",
                                  "\\multicolumn{1}{c}{\\textsc{Control}}")), 
                              star.cutoffs = star.cutoffs, 
                              omit.stat = c("aic", "f", "adj.rsq", "bic", "ser"),
                              type = "latex")
    sink()
    note <- c("\\\\ ",
          "\\begin{minipage}{0.90 \\textwidth}",
          "\\emph{Notes:}
This table reports two OLS regressions where the dependent variable is an indicator for whether the subject was willing to transcribe a fourth paragraph.
In the control (the omitted group), \\textsc{Control}, the offer was 10 cents---the same piece rate as for the previous work.
For the treated group, \\textsc{WageCut}, the offer was 3 cents.
In Column~(2) regressors are added for several pre-treatment variables, including the indicators for whether the subject was from the US or Canada, a self-reported male, and a continuous variable which is the log cumulative prior errors on the three previous paragaraph transcriptions.   
Robust standard errors are reported.
\\starlanguage",
          "\\end{minipage}")
    AddTableNote(s, out.file, note)
}

