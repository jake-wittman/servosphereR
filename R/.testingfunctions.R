library(data.table)
library(tidyverse)
source("./R/derived_variables.R")
source("./R/fetch_clean_functions.R")
source("./R/ballr.R")
source("./R/summarize_variables.R")
# Test without stimulus split
dat <- getFiles(path = "./inst/extdata/", pattern = "_servosphere.csv")
trial_id <- read.csv("./inst/extdata/trial_id.csv", stringsAsFactors = FALSE)
dat <- cleanNames(dat,
              colnames = c("stimulus",
                           "dT",
                           "dx",
                           "dy"))
dat <- mergeTrialInfo(dat, trial_id, c("id", "treatment", "date"), stimulus.keep = c(1))
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
summary_dat

# Test stimulus separate
dat_stim_split <- getFiles(path = "./inst/extdata/", pattern = "_servosphere.csv")
dat_stim_split <- cleanNames(dat_stim_split,
                             colnames = c("stimulus",
                                          "dT",
                                          "dx",
                                          "dy"))

trial_id_split <- read.csv("./inst/extdata/trial_id_stimulus.csv",
                           stringsAsFactors = FALSE)
dat_stim_split <- mergeTrialInfo(dat_stim_split,
                                 trial_id_split,
                                 c("treatment", "date"),
                                 stimulus.split = TRUE,
                                 stimulus.keep = c(1, 2))
dat_stim_split <- thin(dat_stim_split, n = 100)
dat_stim_split <- calcXY(dat_stim_split)
dat_stim_split <- calcDistance(dat_stim_split)
dat_stim_split <- calcBearing(dat_stim_split)
dat_stim_split <- calcVelocity(dat_stim_split)
dat_stim_split <- calcTurnAngle(dat_stim_split)
dat_stim_split <- calcTurnVelocity(dat_stim_split)
summary_dat_split <- summaryTotalDistance(dat_stim_split)
summary_dat_split <- summaryNetDisplacement(dat_stim_split,
                                            summary.df = summary_dat_split)
summary_dat_split <- summaryTortuosity(summary.df = summary_dat_split,
                                       net.displacement = net_displacement,
                                       total.distance = total_distance,
                                       inverse = FALSE)
summary_dat_split <- summaryAvgBearing(dat_stim_split,
                                       summary.df = summary_dat_split)
summary_dat_split <- summaryAvgVelocity(dat_stim_split,
                                        summary.df = summary_dat_split)
summary_dat_split <- summaryStops(dat_stim_split,
                                  summary.df = summary_dat_split,
                                  stop.threshold = 0.1)
summary_dat_split
