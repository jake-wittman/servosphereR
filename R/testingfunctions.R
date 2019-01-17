library(data.table)
library(tidyverse)
source("./R/derived_variables.R")
source("./R/fetch_clean_functions.R")
source("./R/servospherer.R")
source("./R/summarize_variables.R")
dat <- getFiles(path = "./inst/extdata/", pattern = "_servosphere.csv")
trial_id <- read.csv("./inst/extdata/trial_id.csv")
dat <- cleanNames(dat,
              colnames = c("stimulus",
                           "dT",
                           "dx",
                           "dy",
                           "enc1",
                           "enc2",
                           "enc3"))
dat <- mergeTrialInfo(trial_id, c("id", "treatment", "date"), dat)
dat <- thin(dat, n = 100)
dat <- calcXY(dat)
dat <- calcDistance(dat)
dat <- calcBearing(dat)
dat <- calcVelocity(dat)
dat <- calcTurnAngle(dat)
dat <- calcTurnVelocity(dat)
summary_dat <- summaryTotalDistance(dat)
summary_dat <- summaryNetDisplacement(dat, summary.df = summary_dat)
summary_dat <- summaryTortuosity(summary.df = summary_dat,
                                 net.displacement = net_displacement,
                                 total.distance = total_distance,
                                 inverse = FALSE)
summary_dat <- summaryAvgBearing(dat, summary.df = summary_dat)
summary_dat <- summaryAvgVelocity(dat, summary.df = summary_dat)
summary_dat <- summaryStops(dat,
                               summary.df = summary_dat,
                               stop.threshold = 0.1)
