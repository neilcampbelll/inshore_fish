## build packages not on CRAN (only run this once)

#library(devtools)
#install_git("https://github.com/ices-tools-prod/icesDatras.git")


## load required libraries

library(sf)
library(dplyr)
library(icesDatras)


## declare parameters

length.threshold <- 200  ## let's look at fish smaller and larger than 20cm
min.year <- 2012
max.year <- 2023