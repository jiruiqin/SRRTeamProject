#Load the futures price data from the R schwartz97 package
data(futures)
#Run schwartz two-factor model to estimate the variables
live.cattle.fit.constr <- fit.schwartz2f(futures$live.cattle$price, futures$live.cattle$ttm / 260,kappa = 1,opt.pars = c(s0 = FALSE, delta0 = FALSE, mu = TRUE,sigmaS = TRUE, kappa = FALSE, alpha = TRUE,sigmaE = TRUE, rho = TRUE, lambda = FALSE),meas.sd = 1 / vol.std / sum(1 / vol.std) * length(vol.std) * 0.01,deltat = 1 / 260, control = list(maxit = 300))
plot(live.cattle.fit.constr, type = "trace.pars")

#Values of estimated variables
result<-coef(live.cattle.fit.constr)

#Format prices data for year 2007
live.cattle.2007 <- lapply(futures$live.cattle,function(x)x[as.Date(rownames(x)) > "2007-01-01" & as.Date(rownames(x)) < "2008-07-01",])
par(mfrow = c(1, 2))
#Generate futures curve from given historical prices with term structure for each futures price
futuresplot(live.cattle.2007, type = "forward.curve")
#Generate futures predicted curve with term structure for each futures price
plot(live.cattle.fit.constr, type = "forward.curve", data = live.cattle.2007$price,ttm = live.cattle.2007$ttm / 260)