#' Returns a table showing how group assignmed affected game play
#' 
#' Returns a table showing how group assignmed affected game play
#' 
#' @return  
#' @export

library(stargazer)

CreateGamesTable <- function(out.file){
    data('df_no_1')
    # create datasets  - games
    df.games <- subset(df_no_1, group %in% c("Control", "OnlyGames"))
    df.games$group <- with(df.games, factor(group))
    df.games <- within(df.games, group <- relevel(group, ref = "OnlyGames"))
    # fit models 
    m.games.attr.advice <- lm(advice.z ~ I(group == "Control"), data = df.games)
    m.games.attr.survey <- update(m.games.attr.advice, survey ~ .)
    m.games.attr.trust <- update(m.games.attr.advice, trust.z ~ .)
    # create datasets - justifications 
    df.games.just <- subset(df_no_1, any.cut)
    df.games.just$group <- with(df.games.just, factor(group))
    df.games.just <- within(df.games.just, group <- relevel(group, ref = "WageCut"))
    # fit models
    m.games.cuts.just.advice <- lm(advice.z ~ group, data = df.games.just)
    m.games.cuts.just.trust <- lm(trust.z ~ group, data = df.games.just)
    m.games.cuts.just.survey <- lm(survey ~ group, data = df.games.just)
    # create datsets - any cuts 
    df.games.any.cuts <- subset(df_no_1, any.cut | group == "Control")
    # fit models 
    m.games.any.cut.advice <- lm(advice.z ~ any.cut, data = df.games.any.cuts)
    m.games.any.cut.trust <- update(m.games.any.cut.advice, trust ~ .)
    m.games.any.cut.survey <- update(m.games.any.cut.trust, survey ~ .)   
    #stargazer(m.games.cuts.just.advice, m.games.cuts.just.trust, m.games.cuts.just.survey, type = "text")
    #waldtest(m.games.cuts.just.advice)
    #waldtest(m.games.cuts.just.trust)
    sink(tempfile(file = "garbage"))
    s <- stargazer::stargazer(m.games.attr.survey,
                              m.games.any.cut.survey,
                              m.games.cuts.just.survey,
                              m.games.cuts.just.advice,
                              m.games.cuts.just.trust,  
               title = "The effects of wage cuts on consummate performance measures from the ``games'' phase of the experiment",
               dep.var.labels = c("Agree to complete survey?, (\\textsc{Survey} = 1)", "Advice Z-Score", "Trust Z-Score"),
               label = "tab:games",
               no.space = TRUE,
               align = TRUE, 
               font.size = "footnotesize", 
                              covariate.labels = c("\\textsc{Control}",
                                  "Any wage cut offer?",
                                  "\\textsc{FairnessPrimedWC}",
                                  "\\textsc{NeighborWC}",
                                  "\\textsc{ProductivityWC}",
                                  "\\textsc{ProfitWC}",
                                  "\\textsc{UnframedWC}"),
                              star.cutoffs = star.cutoffs,
                              omit.stat = c("aic", "f", "adj.rsq", "bic", "ser"),
                              add.lines = list(c(
                                  "Comparison Group",
                                  "\\multicolumn{1}{c}{\\textsc{OnlyGames}}",
                                  "\\multicolumn{1}{c}{\\textsc{Control}}",
                                  "\\multicolumn{1}{c}{\\textsc{WageCut}}",
                                  "\\multicolumn{1}{c}{\\textsc{WageCut}}",
                                  "\\multicolumn{1}{c}{\\textsc{WageCut}}")), 
                              type = "latex")
    sink()
    note <- c("\\\\ ",
          "\\begin{minipage}{0.95 \\textwidth}",
          "\\emph{Notes:}
This table reports OLS regressions where the dependent variable is an indicator for whether the subject agreed to complete a short survey in the future, in Columns~(1) through (3) and a z-score measure of the workers' offered advice, in Column~(4), and their trust in us as employers/trading partners, in Column~(5). 
In Column~(1), the comparison group are those subjects assigned to \\textsc{OnlyGames}, which were not offered the chance to do a fourth transcription.
They are compared against \\textsc{Control}, which was offered 10 cents.
In Column~(2), all cells where a wage cut was proposed (i.e., 3 cents for a fourth paragraph) are compared to the \\textsc{Control} to see if the wage cut collectively lowered willingness to take the survey.
Finally, in Column~(3), each of the justified or primed cells in which 3 cents was offered is compared against \\textsc{WageCut}, the unexplained wage cut. 
Robust standard errors are reported.
\\starlanguage",
          "\\end{minipage}")
    AddTableNote(s, out.file, note)
}
