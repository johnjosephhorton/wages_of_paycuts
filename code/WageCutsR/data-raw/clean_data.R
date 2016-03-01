#! /usr/bin/Rscript --vanilla

library(devtools)
library(plyr)

raw <- read.csv('./replication/wage_cuts.csv')

data <- subset(raw, e1 < 100 & e2 < 100 & e3 < 100 & !is.na(uscan))
data$G_numeric <- data$G
data$G <- factor(data$G)

data <- within(data, {
               advice.z = ( advice - mean(advice)) / sd(advice)
               trust.z = (trust - mean(trust)) / sd(trust)
               prior.error = log1p(e1 + e2 + e3)
           })

groups.desc <- c("Control (same 10c)", 
                 "Unexplained", 
                 "No Cut", 
                 "Productivity", 
                 "Profit", 
                 "Neighbor", 
                 "Unframed", 
                 "Primed")

groups.desc <- c("Control", 
                 "WageCut", 
                 "OnlyGames", 
                 "ProductivityWC", 
                 "ProfitWC", 
                 "NeighborWC", 
                 "UnframedWC", 
                 "FairnessPrimedWC")

group.desc.long <- list(
    "control"      = "G1 Control: Offered same rate (not a wage cut)",
    "unexplained"  = "G2 Unexplained: No explanation for low offer", 
    "nocut"        = "G3: No Cut Control: No 4th paragraph---straight to games", 
    "productivity" = "G4 Productivity: Low offer explained as response to increased productivity",
    "profit"       = "G5 Profit: Low offer explained as profit motive by employer", 
    "neighbor"     = "G6 Neighbor: Subjects told others willing to accept the offer", 
    "unframed"     = "G7 Unframed: Subjects brought to next task without receiving an offer", 
    "fairness"     = "G8 Primed for Fairness: Subjects asked what is a fair wage before offer"
)

meta.desc <- c("Control", 
               "Unreasonable/None", 
               NA, 
               "Reasonable", 
               "Unreasonable/None", 
               "Reasonable",
               "Unframed", 
               "Unreasonable/None")
data$group <- sapply(data$G, function (x) groups.desc[x])
data$meta <- sapply(data$G, function (x) meta.desc[x])

data$any.cut <- with(data, !(group %in% c("Control",
                                          "OnlyGames")))

data$e4cf <- data$e4 
data$e4cf[data$G==5][1] <- NA

df <- subset(ddply(data, .(G), summarise,
                   s = sum(add, na.rm = TRUE),
                   effect = mean(add, na.rm = TRUE),
                   n.obs = length(G)),
             G != 3)

df$group <- sapply(df$G, function (x) groups.desc[x])
df$meta <- sapply(df$G, function (x) meta.desc[x])

devtools::use_data(df, pkg = "..", overwrite = TRUE)

df_no_3 <- subset(data,G != 3)
df_no_3$G <- relevel(df_no_3$G, ref="1")

devtools::use_data(df_no_3, pkg = "..", overwrite = TRUE)


df_no_1 <- data
df_no_1$group <- factor(df_no_1$group)
df_no_1$group <- relevel(df_no_1$group, ref= "OnlyGames")
df_no_1$group <- with(df_no_1, reorder(group, G_numeric, mean))

devtools::use_data(df_no_1, pkg = "..",  overwrite = TRUE)
