# Replication of Realized Variance Plot

#functions
source("functions.R")
filter <- dplyr::filter
select <- dplyr::select

library(plotly)


vol_up = 0.25

r_f = 0.00
S_0 = 20
mu_gmb = 0.00
maturity = 1
size_process = 20
size_process_with_start = size_process+1
number_trajectories = 1
payoff_log_contract = 0

set.seed=1

simulated_stock = geometric_brownian_motion(Xzero = S_0, mu=mu_gmb, sigma =vol_up, T= maturity, size_process = size_process, number_trajectories = number_trajectories)

# realized variance
#ret_simulated_stock = simulated_stock[2:length(simulated_stock)] / simulated_stock[1:length(simulated_stock)-1]-1
ret_simulated_stock = log(simulated_stock[2:length(simulated_stock)] / simulated_stock[1:length(simulated_stock)-1])
var_ret = var(ret_simulated_stock)  *size_process
#var_ret = sum((ret_simulated_stock^2)/(size_process)) * size_process
var_ret
sqrt(var_ret)

# dynamic pf of stock
share_stock = rep(NA, size_process)
value_rf_position = rep(NA, size_process)
share_stock[1] = 1/S_0
value_rf_position[1] = 0

for (i in 2:size_process){
  share_stock[i] = 1/simulated_stock[i,1]
  #print(-(share_stock[i]-share_stock[i-1])*simulated_stock[i,1] +value_rf_position[i-1]*exp(r_f*maturity/size_process))
  #print(value_rf_position[i-1] * exp(r_f*maturity/size_process) + ret_simulated_stock[i-1])
  value_rf_position[i] = -(share_stock[i]-share_stock[i-1])*simulated_stock[i,1] +value_rf_position[i-1]*exp(r_f*maturity/size_process)
  #value_rf_position[i] = value_rf_position[i-1] * exp(r_f*maturity/size_process) + ret_simulated_stock[i-1]
}


# logcontract
payoff_log_contract = log(tail(simulated_stock[,1],1)/S_0)

t(simulated_stock)
value_rf_position
share_stock
payoff_log_contract

# aggregated position
# riskfree + asset - logcontract
(tail(value_rf_position,1) - payoff_log_contract)
var_ret
sqrt(var_ret)
2/maturity*(tail(value_rf_position,1) - payoff_log_contract) - var_ret/maturity

num_rounds = 20000

#simultion log contracts with different variances
log_contract_return = matrix(NA, nrow=10, ncol=num_rounds)
var_swap_return = matrix(NA, nrow=10, ncol=num_rounds)
stock_return = matrix(NA, nrow=10, ncol=num_rounds)
rf_position_return = matrix(NA, nrow=10, ncol=num_rounds)
stock_st = matrix(NA, nrow=10, ncol=num_rounds)
realized_var = matrix(NA, nrow=10, ncol=num_rounds)
vola = rep(NA, 10)
size_process = 500
for (i in 1:10) {
  set.seed=i+42
  vola[i] = 1-0.1*(i-1)
  
  for (j in 1:num_rounds){
    simulated_stock = geometric_brownian_motion(Xzero = S_0, mu=mu_gmb, sigma =vola[i], T= maturity, size_process = size_process, number_trajectories = number_trajectories)
    log_contract_return[i, j] = log(tail(simulated_stock[,1],1)/S_0)
    #var_swap_return[i, j] = 2/maturity*exp(r_f*maturity)*(log(S_0/tail(simulated_stock[,1],1))+tail(simulated_stock[,1],1)/S_0 -1)
    var_swap_return[i, j] = 2/maturity*exp(r_f*maturity)*(log(S_0/tail(simulated_stock[,1],1))+tail(simulated_stock[,1],1)/S_0 -1)
    realized_var[i,j] = var(log(simulated_stock[2:length(simulated_stock)] / simulated_stock[1:length(simulated_stock)-1]))  *size_process
    
    share_stock = rep(NA, size_process)
    value_rf_position = rep(NA, size_process)
    share_stock[1] = 1/S_0
    value_rf_position[1] = 0
    
    for (k in 2:size_process){
      share_stock[k] = 1/simulated_stock[k,1]
      value_rf_position[k] = -(share_stock[k]-share_stock[k-1])*simulated_stock[k,1] +value_rf_position[k-1]*exp(r_f*maturity/size_process)
    }
    rf_position_return[i, j] = tail(value_rf_position,1)
    stock_return[i, j] = tail(simulated_stock[,1],1)*tail(share_stock,1)
    #var_swap_return[i, j] = 2*(rf_position_return[i, j]+stock_return[i, j] - log(S_0/tail(simulated_stock[,1],1)))
    stock_st[i, j] = tail(simulated_stock[,1],1)
  }
}

avg_log_contract_return = rowMeans(log_contract_return)
avg_var_swap_return = rowMeans(var_swap_return)
avg_stock_return = rowMeans(stock_return)
avg_rf_position_return = rowMeans(rf_position_return)
avg_realized_var = rowMeans(realized_var)

checksum = avg_var_swap_return - avg_realized_var


p <-  plot_ly(x=as.vector(stock_st), y=as.vector(realized_var), z=as.vector(var_swap_return)-as.vector(realized_var), type="scatter3d", mode="markers", marker=list(size=8,color=as.vector(var_swap_return), colorscale='Viridis'))
p <-  p %>% layout(scene = list(
  xaxis = list(title="Price of Underlying at T"),
  yaxis = list(title="Realized Variance"),
  zaxis = list(title="Payoff Variance Swap")
))
p


2*(avg_stock_return - avg_log_contract_return)
vola

logcon_returns = matrix(NA, nrow=10, ncol=10)


for (i in 15:25){
  for (j in 1:10){
    select = stock_st[j, ]>(i-0.5) & stock_st[j, ]<(i+0.5)
    print(sum(select))
    selection = var_swap_return[j, select]
    logcon_returns[j, i-15] = mean(selection)
  }
}
