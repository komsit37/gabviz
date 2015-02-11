if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("mul118/shinyMCE")
devtools::install_github("mul118/shinyGridster")
devtools::install_github("iheartradio/ShinyBuilder")

ShinyBuilder::runShinyBuilder()
library(RSQLite)
RSQLite
sessionInfo()
remove.packages('RSQLite')