# set wd
setwd("C:/Users/eriks/Documents/GitHub/QuantPortfolioMgmtPrjct/project/R")

# source functions
source("functions.R")
filter <- dplyr::filter
select <- dplyr::select

# For non-nix users (as defined in `./shell.nix`)
library(tidyverse)
library(xts)
library(readxl)
library(openxlsx)
library(timeSeries)
library(kableExtra) # tables.
library(skimr) # decriptive stats
library(gridExtra)
library(GGally)
library(xtable)
library(caret)
library(shape)
library(tikzDevice)
library(cleandata)
library(ggcorrplot)
library(psych)
library(pracma) # moving average


# pf of dynamic stock and logconstract. Payoff in T for certain paths of T


# data for future
S = 2500
k = 2500
tau = 1
r_f = 0

n = 10 # number steps of the tree

vol1=0.22
vol2=0.25
vol3=0.30





# build tree
# A) Index - Cox-Ross-Rubenstein Tree
# Cox Rubenstein probabilities
# in our application interest rate is 0
u_vol1 = exp(vol1*sqrt(tau/n)) 
d_vol1 =exp(-vol1*sqrt(tau/n))

u_vol2 = exp(vol2*sqrt(tau/n))
d_vol2 =exp(-vol2*sqrt(tau/n))

u_vol3 = exp(vol3*sqrt(tau/n))
d_vol3 =exp(-vol3*sqrt(tau/n))

p_vol1 = (exp(r_f*tau/n)-d_vol1)/ (u_vol1-d_vol1) 
p_vol2 = (exp(r_f*tau/n)-d_vol2)/ (u_vol2-d_vol2) 
p_vol3 = (exp(r_f*tau/n)-d_vol3)/ (u_vol3-d_vol3) 

# initialize dataset for tree
# also works for non-recombining trees.
# rows for steps, cols for outcomes for each step. # steps = n, #cols = 2^n
tree_index_vol1 = matrix(rep(NA,len=(n+1)*(2^n)), nrow=n+1)
tree_index_vol1[1,1] = S

tree_index_vol2 = tree_index_vol1
tree_index_vol3 = tree_index_vol1

# calculate trees
# vol1
for (i in 2:(n+1)){
  for (j in 1:(2^n)) {
    if (is.na(tree_index_vol1[i-1,j]) ==FALSE) { # if value previous step not missing then use for getting 2 new point in this step
      tree_index_vol1[i,j*2-1] <- tree_index_vol1[i-1,j]*u_vol1 # up movement point
      tree_index_vol1[i,j*2] <-  tree_index_vol1[i-1,j]*d_vol1  # down movement point
    }
  }
}