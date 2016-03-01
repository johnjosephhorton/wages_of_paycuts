#' Returns a table with uptake by framing 
#' 
#' Returns a table with uptake by framing 
# ' 
#' @return  
#' @export

library(stargazer)

CreateUptakeFramingTable <- function(out.file){
    data('df_no_3')

    df.uptake.framing <- subset(df_no_3, group %in% c("WageCut", "ProductivityWC", "ProfitWC", "NeighborWC"))
    df.uptake.framing$meta <- with(df.uptake.framing, factor(meta))
    df.uptake.framing <- within(df.uptake.framing, meta <- relevel(meta, ref = "Unreasonable/None"))
    df.uptake.framing$group <- with(df.uptake.framing, factor(group))
    df.uptake.framing <- within(df.uptake.framing, group <- relevel(group, ref = "WageCut"))
                                        # fit models
    m.uptake.framing <- lm(add ~ group, data = df.uptake.framing)
    m.uptake.meta <- lm(add ~ meta, data = df.uptake.framing)
    # writeup outputs 
    sink(tempfile(file = "garbage"))
    s <- stargazer::stargazer(m.uptake.framing, m.uptake.meta,  
               title = "The effects of wage cut justifications on worker output choice following a wage cut",
               dep.var.labels = c("Transcribe additional paragraph?"),
               label = "tab:uptake_framing",
               no.space = TRUE,
               align = TRUE, 
               font.size = "footnotesize", 
               covariate.labels = c(
                   "Neighbor justification, \\textsc{NeighborWC}",
                   "Productivity justification, \\textsc{ProductivityWC}",
                   "Profit justification, \\textsc{ProfitWC}",
                   "``Reasonable'' justifications (\\textsc{NeighborWC} + \\textsc{ProductivityWC})"),
                              add.lines = list(c("Comparison Group", "\\multicolumn{1}{c}{\\textsc{WageCut}}",
                                  "\\multicolumn{1}{c}{\\textsc{WageCut + ProfitWC}}")), 
               star.cutoffs = star.cutoffs,
               omit.stat = c("aic", "f", "adj.rsq", "bic", "ser"),
               type = "latex")
    sink()
    note <- c("\\\\ ",
          "\\begin{minipage}{0.95 \\textwidth}",
          "\\emph{Notes:}
This table reports two OLS regressions where the dependent variable is an indicator for whether the worker subject was willing to transcribe a fourth paragraph.
Comparisons are being made against \\textsc{WageCut}, in which the offer was 3 cents and no justification was offered for the cut.
In Column~(1), indicators for each justification---productivity increases, employer profits and comparison to ``neighbor'' choices are used as regressors.
In Column~(2), the ``unreasonable'' profit justification is pooled with the unexplained cut and the two ``reasonable'' justifications from \\textsc{NeighborWC} and \\textsc{ProductivityWC} are pooled as an indicator for ``Reasonable'' justifications. 
Standard errors are robust. 
\\starlanguage",
"\\end{minipage}")
    AddTableNote(s, out.file, note)
} 

    
