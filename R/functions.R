# Function File for QPM - Volatility 

## general functions ----

value_at_risk_empirical = function(data, significance_level, time) {
  # data = returns in correct time scale
  # signif level= bound  for var, signifince
  # time = scaling factor for VaR with different timeframe. Requires normality
  if(missing(time)) { time=1}
  value_at_risk = -quantile(data,significance_level, na.rm=TRUE)*sqrt(time)
  return(value_at_risk)
}

expected_shortfall_empirical = function(data, significance_level, time) {
  # data = returns in correct time scale
  # signif level= bound  for var, signifince
  # time = scaling factor for VaR with different timeframe. Requires normality
  value_at_risk = -quantile(data,significance_level, na.rm=TRUE)
  expected_shortfall = -mean(subset(data, data < -value_at_risk), na.rm=TRUE)*sqrt(time)
  return(expected_shortfall)
}

## plotting function ----
line_plot_multiple = function(title, x,xlab, ylab, names_y, y_percent, legend, y1, y2,y3,y4,y5,y6,y7,y8,y9,y10) {
  # plots up to 10 lines with same scale 
  # insert vectors for x, y1, y2... y2-10 are optional
  # give vector for legend entry names_y, ...
  # if names_y na or missing colors are still given
  # legend: boolean if legend should be created, Default is TRUE
  if(missing(xlab)) {xlab=NULL}
  if(missing(ylab)) {ylab=NULL}
  if(missing(title)) {title=NULL}
  if(missing(names_y)==T | all(is.na(names_y))==T) {names_y=c(1:10)}
  if(missing(legend)){legend = T}
  if(missing(y_percent)){y_percent = FALSE}
  
  plot = ggplot(data=NULL, aes(x=x))+
    geom_line(aes(y=y1, col = names_y[1])) 
  
  # only add layers if value provided
  if (missing(y2)==F) {
    plot = plot + geom_line(aes(y =y2 , col =names_y[2]))
  }  
  if (missing(y3)==F) {
    plot = plot + geom_line(aes(y =y3 , col =names_y[3]))
  }  
  if (missing(y4)==F) {
    plot = plot + geom_line(aes(y =y4 , col =names_y[4]))
  }  
  if (missing(y5)==F) {
    plot = plot + geom_line(aes(y =y5 , col =names_y[5]))
  }  
  if (missing(y6)==F) {
    plot = plot + geom_line(aes(y =y6 , col =names_y[6]))
  }  
  if (missing(y7)==F) {
    plot = plot + geom_line(aes(y =y7 , col =names_y[7]))
  }  
  if (missing(y8)==F) {
    plot = plot + geom_line(aes(y =y8 , col =names_y[8]))
  }  
  if (missing(y9)==F) {
    plot = plot + geom_line(aes(y =y9 , col =names_y[9]))
  }  
  if (missing(y10)==F) {
    plot = plot + geom_line(aes(y =y10 , col =names_y[10]))
  }  

  
  plot = plot + theme_bw()+
    labs(x = xlab)+
    labs(y = ylab)
    
  # add legend if Legend is true are given
  if(legend==T) {
    plot = plot + theme(legend.title = element_blank(), legend.position = "bottom", legend.box.background = element_rect(colour = "black"))
  } else {
    plot = plot + theme(legend.position = "none")
  }
  
  # add units to yaxis (e.g. percent)
  if(y_percent==T) {
    plot = plot + scale_y_continuous(labels = scales::percent_format(accuracy = 2))
  }
  
  # other plot options
  plot = plot +  ggtitle(paste(title,sep=" ")) +
    theme(plot.title = element_text(size=10, face="bold"))+
    theme(axis.text=element_text(size=10),
          axis.title=element_text(size=10,face="bold"))+
    ggsave(file=paste0("./r_output/",title,".png"), width=6, height=4, dpi=600)
  
  plot
  return(plot)
}

line_point_plot_multiple = function(title, x,xlab, ylab, names_y, y_percent, legend, y1, y2,y3,y4,y5,y6,y7,y8,y9,y10) {
  # plots up to 10 lines with same scale 
  # insert vectors for x, y1, y2... y2-10 are optional
  # give vector for legend entry names_y, ...
  # if names_y na or missing colors are still given
  # legend: boolean if legend should be created, Default is TRUE
  # y6-y10 are geom point
  if(missing(xlab)) {xlab=NULL}
  if(missing(ylab)) {ylab=NULL}
  if(missing(title)) {title=NULL}
  if(missing(names_y)==T | all(is.na(names_y))==T) {names_y=c(1:10)}
  if(missing(legend)){legend = T}
  if(missing(y_percent)){y_percent = FALSE}
  
  #first geom point
  plot = ggplot(data=NULL, aes(x=x))+
    geom_point(aes(y=y1, col = names_y[1])) 
  
  # geom lines
  if (missing(y2)==F) {
    plot = plot + geom_line(aes(y =y2 , col =names_y[2]))
  }  
  if (missing(y3)==F) {
    plot = plot + geom_line(aes(y =y3 , col =names_y[3]))
  }  
  if (missing(y4)==F) {
    plot = plot + geom_line(aes(y =y4 , col =names_y[4]))
  }  
  if (missing(y5)==F) {
    plot = plot + geom_line(aes(y =y5 , col =names_y[5]))
  }  
  
  # geom points
  if (missing(y6)==F) {
    plot = plot + geom_point(aes(y =y6 , col =names_y[6]))
  }  
  if (missing(y7)==F) {
    plot = plot + geom_point(aes(y =y7 , col =names_y[7]))
  }  
  if (missing(y8)==F) {
    plot = plot + geom_point(aes(y =y8 , col =names_y[8]))
  }  
  if (missing(y9)==F) {
    plot = plot + geom_point(aes(y =y9 , col =names_y[9]))
  }  
  if (missing(y10)==F) {
    plot = plot + geom_point(aes(y =y10 , col =names_y[10]))
  }  
  
  
  plot = plot + theme_bw()+
    labs(x = xlab)+
    labs(y = ylab)
  
  # add legend if Legend is true are given
  if(legend==T) {
    plot = plot + theme(legend.title = element_blank(), legend.position = "bottom", legend.box.background = element_rect(colour = "black"))
  } else {
    plot = plot + theme(legend.position = "none")
  }
  
  # add units to yaxis (e.g. percent)
  if(y_percent==T) {
    plot = plot + scale_y_continuous(labels = scales::percent_format(accuracy = 2))
  }
  
  # other plot options
  plot = plot +  ggtitle(paste(title,sep=" ")) +
    theme(plot.title = element_text(size=10, face="bold"))+
    theme(axis.text=element_text(size=10),
          axis.title=element_text(size=10,face="bold"))+
    ggsave(file=paste0("./r_output/",title,".png"), width=6, height=4, dpi=600)
  
  plot
  return(plot)
}


# times series plot function
time_series_plot_basic = function(date,title, y, ylab, min_date, max_date) {
  if(missing(ylab)) {ylab=NULL}
  if(missing(title)) {title=NULL}
  
  plot = ggplot(data=NULL, aes(x=as.Date(date,format = "%m/%d/%Y"), y = y))+
    geom_line(colour = "cornflowerblue", size = 1)+
    scale_x_date(limits = c(min=min_date, max=max_date)) + 
    theme_bw()+
    labs(x = "Date")+
    labs(y = ylab)+
    theme(legend.position = "bottom", legend.box.background = element_rect(colour = "black"))+
    ggtitle(paste(title,sep=" ")) +
    theme(plot.title = element_text(size=10, face="bold"))+
    theme(axis.text=element_text(size=10),
          axis.title=element_text(size=10,face="bold"))+
    ggsave(file=paste0("./r_output/",title,".png"), width=6, height=4, dpi=600)
  plot
  return(plot)
}



time_series_plot_multiple = function(date,title, y, ylab, seperating_var,min_date, max_date) {
  if(missing(ylab)) {ylab=NULL}
  if(missing(title)) {title=NULL}
  
  plot = ggplot(data=NULL, aes(x=as.Date(date,format = "%m/%d/%Y"), y = y))+
    geom_line(aes(color = seperating_var), size = 1)+
    scale_x_date(limits = c(min=min_date, max=max_date)) + 
    theme_bw()+
    labs(x = "Date")+
    labs(y = ylab)+
    theme(legend.position = "bottom", legend.box.background = element_rect(colour = "black"))+
    ggtitle(paste(title,sep=" ")) +
    theme(plot.title = element_text(size=10, face="bold"))+
    theme(axis.text=element_text(size=10),
          axis.title=element_text(size=10,face="bold"))+
    ggsave(file=paste0("./r_output/",title,".png"), width=6, height=4, dpi=600)
  
  plot
  return(plot)
}

## Constant Proportional Option functions ----

constantProportionPortfolio = function(data, startvalue_pf, share_asset1, rebalance_intervall_days, transaction_cost_share) {
  
  # Rebalancing portfolio
  # function to calulate portfolio value 
  # Inputs
  # data with price_asset1, price_asset2 as columns 
  # startvalue_pf: initial investment
  # share portfolio asset 1
  # rebalance intervall_days: in days. put to length on timeframe if on rebalancing
  # transaction_cost_share: relative trading cost for each transaction based on traded value (change in share pf*value_pf*2 because need to sell and and buy the other asset)
  # Output
  # data - dataframe with portfolio contents
  
  share_asset2= 1-share_asset1
  
  # initial number of contracts 
  # asset prices = cum return. Can be true prices
  contracts_asset1= startvalue_pf *share_asset1/ (data$price_asset1[1])
  contracts_asset2= startvalue_pf* (1-share_asset1) / (data$price_asset2[1])
  
  
  
  # rebalancing frequency - STARTING from day 1, so transaction cost for buying are included
  rebalance_intervall = rebalance_intervall_days # in busdays
  rebalance_days = seq(from = 1, to = (nrow(data)), by = rebalance_intervall)[-1]
  
  # initialize data    
  data$value_rebalance_pf = NA
  data$ret_rebalance_pf = NA
  data$cret_rebalance_pf = NA
  data$transaction_cost_rebalance = NA
  data$contracts_asset1= NA
  data$contracts_asset2= NA
  data$change_share_asset1= NA # relevant for proportional transaction costs
  
  data$value_rebalance_pf[1] = startvalue_pf
  data$cret_rebalance_pf[1]=0
  data$transaction_cost_rebalance[1] = 0 # ignore initial transaction cost because they always occur
  
  # set number of contracts at start 
  data$contracts_asset1[1] = contracts_asset1
  data$contracts_asset2[1] = contracts_asset2
  
  
  # calulate # contracts, pf value and return step by step
  
  for (i in 2:nrow(data)){
    # get portfolio value today
    data$value_rebalance_pf[i] =  data$contracts_asset1[i-1]*data$price_asset1[i]+ data$contracts_asset2[i-1]*data$price_asset2[i]
    
    
    # rebalance if it its a rebalancing day
    # check if rebalancing day
    if (is.element(i, rebalance_days)==TRUE) {
      # change share asset via value_rebalance_pf (before transaction cost in that period)
      data$change_share_asset1[i] = data$contracts_asset1[i-1]*data$price_asset1[i]/data$value_rebalance_pf[i]-share_asset1
        
      # transaction cost due to rebalancing (share of value of traded assets = 2*change in share*rel_transactioncost*pf_value
      data$transaction_cost_rebalance[i] = 2* abs(data$change_share_asset1[i])* transaction_cost_share * data$value_rebalance_pf[i] 
      data$value_rebalance_pf[i] = data$value_rebalance_pf[i] - data$transaction_cost_rebalance[i]
      
      # rebalance to constant weight again
      data$contracts_asset1[i] = share_asset1 * data$value_rebalance_pf[i] / data$price_asset1[i]
      data$contracts_asset2[i] = share_asset2* data$value_rebalance_pf[i] / data$price_asset2[i]
    }
    else{
      # no rebalancing
      data$change_share_asset1[i] = 0
      data$transaction_cost_rebalance[i] =0
      # without rebalancing: same weights as before
      data$contracts_asset1[i] = data$contracts_asset1[i-1]
      data$contracts_asset2[i] = data$contracts_asset2[i-1]
    }
    
    # get portfolio return with rebalancing cost today
    data$ret_rebalance_pf[i] = data$value_rebalance_pf[i] / c(NA, data$value_rebalance_pf[-length(data$value_rebalance_pf)])[i] -1
    
    data$cret_rebalance_pf[i] = (data$cret_rebalance_pf[i-1]+1)*(1+data$ret_rebalance_pf[i])-1
    
  }
  return(data)
}


## Volatility Option functions ----

gl96_forward = function(kappa_fw, theta_fw,T_fw,current_value_fw) {
  # function to calculate VSTOXX forward value following Gruenbichler and Longstaff
  # input parameters notation following CIR-process parameters
  alpha = kappa_fw * theta_fw
  beta = kappa_fw + zeta
  fw = alpha/beta*(1-exp(-beta*T_fw)) + exp(-beta*T_fw)*current_value_fw
  return(fw)
}


gl96_call_option = function(kappa_call, zeta_call, theta_call ,sigma_call, T_call,strike_call, current_value_underlying, riskfree_call) { 
  # uses approximation for chisquared
   # input parameters notation following CIR-process parameters
  alpha = kappa_call * theta_call
  beta = kappa_call + zeta_call
  gamma = 4*beta/((sigma_call^2)*(1-exp(-beta*T_call)))
  v = 4*alpha / (sigma_call^2)
  lambda = gamma * exp(-beta*T_call) * current_value_underlying
  
  # calculate chisquare distribution via approximation
    # for component 1
    v1 = v+4
    
    h1 = 1-2/3*(v1+lambda)*(v1+3*lambda)*(v1+2*lambda)^(-2)
    k1 = (h1^2*2*(v1+2*lambda)/((v1+lambda)^2)*(1-(1-h1)*(1-3*h1)*(v1+2*lambda)*(v1+lambda)^(-2)))^(-1/2)
    l1= 1+h1*(h1-1)*(v1+2*lambda)/((v1+lambda)^2)-h1*(h1-1)*(2-h1)*(1-3*h1)*((v1+2*lambda)^2)/(2*(v1+lambda)^4)
    d1 = k1*((gamma*strike_call/(v1+lambda))^h1 -l1)
    ch_square_1 = 1-pnorm(d1) 
    
    # for component 2
    v2 = v+2
    
    h2 = 1-2/3*(v2+lambda)*(v2+3*lambda)*(v2+2*lambda)^(-2)
    k2 = (h2^2*2*(v2+2*lambda)/((v2+lambda)^2)*(1-(1-h2)*(1-3*h2)*(v2+2*lambda)*(v2+lambda)^(-2)))^(-1/2)
    l2= 1+h2*(h2-1)*(v2+2*lambda)/((v2+lambda)^2)-h2*(h2-1)*(2-h2)*(1-3*h2)*((v2+2*lambda)^2)/(2*(v2+lambda)^4)
    d2 = k2*((gamma*strike_call/(v2+lambda))^h2 -l2)
    ch_square_2 = 1-pnorm(d2) 
    
    # for component 2
    v3 = v
    
    h3 = 1-2/3*(v3+lambda)*(v3+3*lambda)*(v3+2*lambda)^(-2)
    k3 = (h3^2*2*(v3+2*lambda)/((v3+lambda)^2)*(1-(1-h3)*(1-3*h3)*(v3+2*lambda)*(v3+lambda)^(-2)))^(-1/2)
    l3= 1+h3*(h3-1)*(v3+2*lambda)/((v3+lambda)^2)-h3*(h3-1)*(2-h3)*(1-3*h3)*((v3+2*lambda)^2)/(2*(v3+lambda)^4)
    d3 = k3*((gamma*strike_call/(v3+lambda))^h3 -l3)
    ch_square_3 = 1-pnorm(d3) 
  
  # calc parts of price.
    # remember: take complement of chi^2- cdf (value>=X, since thats when payoff call >0)
  price_component_1 = exp(-riskfree_call*T_call)*exp(-beta*T_call)*current_value_underlying*ch_square_1
  price_component_2 = exp(-riskfree_call*T_call)*alpha/beta*(1-exp(-beta*T_call)) * ch_square_2
  price_component_3 = exp(-riskfree_call*T_call)*strike_call* ch_square_3
  
  call_price = price_component_1+ price_component_2 - price_component_3
  
  
  
  return(call_price)
}


gl96_call_option_exact = function(kappa_call, zeta_call, theta_call ,sigma_call, T_call,strike_call, current_value_underlying, riskfree_call) { 
  # uses correct chisquared
  # input parameters notation following CIR-process parameters
  alpha = kappa_call * theta_call
  beta = kappa_call + zeta_call
  gamma = 4*beta/((sigma_call^2)*(1-exp(-beta*T_call)))
  v = 4*alpha / (sigma_call^2)
  lambda = gamma * exp(-beta*T_call) * current_value_underlying
  
  # calc parts of price.
  # remember: take complement of chi^2- cdf (value>=X, since thats when payoff call >0)
  price_component_1 = exp(-riskfree_call*T_call)*exp(-beta*T_call)*current_value_underlying*pchisq(q=strike_call*gamma ,df=v+4, ncp=lambda,lower.tail = FALSE, log.p=FALSE)
  price_component_2 = exp(-riskfree_call*T_call)*alpha/beta*(1-exp(-beta*T_call)) * pchisq(q=strike_call*gamma ,df=v+2, ncp=lambda,lower.tail = FALSE, log.p=FALSE)
  price_component_3 = exp(-riskfree_call*T_call)*strike_call* pchisq(q=strike_call*gamma ,df=v, ncp=lambda,lower.tail = FALSE, log.p=FALSE)
  
  call_price = price_component_1+ price_component_2 - price_component_3
  
  
  
  return(call_price)
}

gl96_put_call_parity = function(optionprice, input_optiontype, future, strike,riskfree, T) {
  # function to calculate put or call value based on other given option price 
  
  if (input_optiontype == "call") {
    calc_option_price = optionprice - exp(-riskfree*T)*future+ exp(-riskfree*T)* strike
  } else {
    
    if(input_optiontype == "put") {
      calc_option_price = optionprice + exp(-riskfree*T)*future - exp(-riskfree*T)* strike
    } else {
      print("Error: wrong input for optiontype")
    }
  }
  return(calc_option_price)
}

## Calibration ----

loss_function <- function(startParms, input_list) {
  # Loss function: minimize sum of squared errors
  # returns MSE/RMSE of GL96 Model vs Observed Prices with the given parameters
  # always uses option prices, can include forward price. 50% weight options, 50% weight forward in loss calculation
  
  # check number optimization parameters
  if(length(startParms)!=3) {
    print("Incorrect Number of Starting Parameters supplied to loss_function")
  }
  # rewrite optimization parameters
  kappa = startParms[1] 
  theta = startParms[2] 
  sigma = startParms[3]
  
  # calculate theoretical prices via GL96 model
  theoretical_forward_price = gl96_forward(kappa, theta,input_list$time_to_maturity,input_list$current_price_underlying)
  theoretical_call_price = gl96_call_option(kappa, input_list$zeta, theta ,sigma, input_list$time_to_maturity,input_list$strike_call, input_list$current_price_underlying, input_list$riskfree)
  
  theoretical_call_price_for_put_valuation = gl96_call_option(kappa, input_list$zeta, theta ,sigma, input_list$time_to_maturity,input_list$strike_put, input_list$current_price_underlying, input_list$riskfree)
  theoretical_put_price = gl96_put_call_parity(theoretical_call_price_for_put_valuation, "call", theoretical_forward_price, input_list$strike_put,input_list$riskfree, input_list$time_to_maturity)
  
  # set prices to theoretical price if not given -> no impact on loss function
  if(is.null(input_list$observed_forward_price)) {
    input_list$observed_forward_price=theoretical_forward_price
  }
  if(is.null(input_list$observed_call_prices)) {
    input_list$observed_call_prices=theoretical_call_price
  }
  if(is.null(input_list$observed_put_prices)) {
    input_list$observed_put_prices=theoretical_put_price
  }
  
  # calculate number of options as inverse weight for each option. Set to 1 if no options to avoid div0 error
  number_option = max((length(input_list$strike_call)+length(input_list$strike_put)),1)
  
  # calculate loss (MSE/RMSE): weight loss options=50%, forward=50%. (call+ put) with (1/number of calls+puts) is weight for indiv option
  if(input_list$method =="MSE") {
    loss = (sum((input_list$observed_call_prices-theoretical_call_price)^2) +sum((input_list$observed_put_prices-theoretical_put_price)^2)) + (input_list$observed_forward_price-theoretical_forward_price)^2
  } 
  if(input_list$method=="RMSE") {
    loss = (sum(((input_list$observed_call_prices-theoretical_call_price)/input_list$observed_call_prices)^2) +sum(((input_list$observed_put_prices-theoretical_put_price)/input_list$observed_put_prices)^2)) + ((input_list$observed_forward_price-theoretical_forward_price)/input_list$observed_forward_price)^2
  }
  return(loss)
}




## Simluation  ----
cir_simulation_milstein <- function(kappa, theta, sigma, Xzero, 
                                    T, size_process, number_simulations) {
  # function for estimation of CIR-process via milstein scheme
  
  # a         drift
  # theta     long term mean 
  # Xzero     X0, starting value
  # T         length of interval 
  # N         step length of Milstein
  # simN      number of trajectories
  
  # dataframe to save trajactory data
  simulated_cir_paths = matrix(data=NA, nrow=size_process+1, ncol = number_simulations)
  simulated_cir_paths[1,] = Xzero
  # loop over all trajactorys
  for (i in  1:number_simulations) {
    # initialize delta, brownian motion, data vector and start value
    dt = T/size_process;         
    dW = sqrt(dt)*rnorm(size_process);         
    Xmilstein   = rep(0,size_process);                 
    Xtemp = Xzero;
    # calculate one trajactory
    for (j in 1:size_process) {
      Winc   = dW[j]; 
      Xtemp  = Xtemp + kappa*(theta -Xtemp)*dt + sigma*sqrt(Xtemp)*Winc + 0.25*sigma^2*(Winc^2-dt) # dX(t) = kappa*(theta-X(t))dt + sigma *sqrt(X(t)) Z(t) 
      Xmilstein[j] = Xtemp
    }
    # save trajactory
    simulated_cir_paths[(1:size_process)+1,i]  = Xmilstein
  }
  return(simulated_cir_paths)
}



geometric_brownian_motion <- function(Xzero, mu, sigma,  T, size_process, number_trajectories) {
  simulated_gbm_paths = matrix(data=NA, nrow=size_process+1, ncol = number_trajectories)
  simulated_gbm_paths[1,] = Xzero
  
  
  # loop over all trajactorys
  for (i in  1:number_trajectories) {
    # initialize delta, brownian motion, vector to collect estimation, starting value
    dt = T/size_process;         
    dW = sqrt(dt)*rnorm(size_process);         
    
    X_gbm   = rep(0,size_process);
    t = c(1:T)/size_process
    # calculate one trajactory
    for (j in 1:size_process) {
      Winc   = dW[j]; 
      X_gbm[j]  = exp((mu-sigma^2/2)*dt + sigma*Winc)
    }
    # save trajactory
    simulated_gbm_paths[(1:size_process)+1,i]  = Xzero*cumprod(X_gbm)
  }
  
  return(simulated_gbm_paths)
}

price_european_option = function(payoff_T, strike_vector, maturity, r_f) {
  # Normal European Options
  # loop over all strikes and calculate payoffs
  po_call_eu = matrix(data=NA, nrow=length(payoff_T), ncol=length(strike_vector))
  po_put_eu = matrix(data=NA, nrow=length(payoff_T), ncol=length(strike_vector))
  
  for (i in 1:length(strike_vector)) {
    po_call_eu[,i] = pmax(payoff_T -strike_vector[i],0)
    po_put_eu[,i] = pmax(strike_vector[i]-payoff_T,0)
  }
  
  call_eu_sim = colMeans(po_call_eu*exp(-r_f*maturity))
  put_eu_sim =  colMeans(po_put_eu*exp(-r_f*maturity))
  option_prices = as.data.frame(cbind(strike_vector,call_eu_sim, put_eu_sim)) 
  colnames(option_prices) = c("strike", "call", "put")
  return(option_prices)
}
