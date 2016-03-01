#! /usr/bin/Rscript --vanilla

# Paper Authors: Daniel Chen and John Horton
# Code Author: John Horton
# Date: October 6th, 2015

library(devtools)

devtools::install_github("johnjosephhorton/JJHmisc")
library(JJHmisc)

devtools::install("../WageCutsR", local = TRUE)
library(WageCutsR)

# Uptake Table 
WageCutsR::CreateUptakeTable(out.file = "../../writeup/tables/uptake_simple.tex")

# Uptake Framing Table 
WageCutsR::CreateUptakeFramingTable(out.file = "../../writeup/tables/uptake_framing.tex")

# Uptake Unframed Cut 
WageCutsR::CreateUptakeUnframedCutTable(out.file = "../../writeup/tables/uptake_unframed.tex")

# Uptake Figure 
g.uptake <- WageCutsR::CreateUptakeFigure()
JJHmisc::writeImage(g.uptake, "uptake", width = 7, height = 4)

# Error table 
WageCutsR::CreateErrorTable(out.file = "../../writeup/tables/error.tex")

# Correlation table for consummate performance measures 
WageCutsR::CreateCorrelationTable(out.file = "../../writeup/tables/cor.tex")

# Games results 
WageCutsR::CreateGamesTable(out.file =  "../../writeup/tables/games.tex")
