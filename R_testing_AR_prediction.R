p = rep(1,31)
for (k in 1:30){ p[k+1] = (k-roll.fd$d)*p[k]/(k+1) }
plot(1:30, p[-1], ylab=expression(pi(d)), xlab="Index", type="h")
res.fd = diffseries(roll, roll.fd$d) # frac diff resids
res.arima = resid(arima(roll, order=c(1,1,1))) # arima resids
par(mfrow=c(2,1))
acf(res.arima, 100, main="")
acf(res.fd, 100, main="")

roll1.arima = resid(arima(roll, order=c(2,4,2)))
rolltest <- roll[1:32500]
proll = predict(arima(rolltest,order=c(7,0,0)),2500)
nroll = ts(c(rolltest,proll$pred))
plot.ts(nroll,ylim=c(-2,2),xlim=c(32000,35000),col="green")
par(new=TRUE)
plot.ts(roll,ylim=c(-2,2),xlim=c(32000,35000),col="red")

vert1.arima = resid(arima(roll, order=c(2,4,2)))
verttest <- vert[1:32500]
pvert = predict(arima(verttest,order=c(5,0,0)),2500)
nvert = ts(c(verttest,pvert$pred))
plot.ts(nvert,ylim=c(-56,-48),xlim=c(32000,35000),col="blue")
par(new=TRUE)
plot.ts(vert,ylim=c(-56,-48),xlim=c(32000,35000),col="red")
