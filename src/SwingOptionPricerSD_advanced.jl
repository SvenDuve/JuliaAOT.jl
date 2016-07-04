function SwingOptionPricerSD_advanced(K, T, SMA, SDA, days, Strike, sigMA, sigDA, alpha1, alpha2, Vbar1, Vbar2, xi1, xi2, rhoz, MR_alphaMA, MR_alphaDA, MeanLNMA, MeanLNDA, r, N, M)

## setting parameters

dt = T/N
alpha1dt = alpha1 * dt
alpha2dt = alpha2 * dt


xi1sdt = xi1 * sqrt(dt)
xi2sdt = xi2 * sqrt(dt)
sdt = sqrt(dt)

lnSMA = log(SMA)
lnSDA = log(SDA)

z = zeros(Float64, 4)
pathMA = zeros(Float64, N, M)
pathDA = zeros(Float64, N, M)

## outer loop is the number of simulations bigger is better

for j = 1:M

	lnStMA = lnSMA
	lnStDA = lnSDA
	Vt1 = Vbar1
	Vt2 = Vbar2

	## inner loop is simulating each price path of length N
	for i = 1:N

		z = generateCorrRandom(rhoz)

		pathMA[i,j] = lnStMA
		pathDA[i,j] = lnStDA


		###
		Vt1 = Vt1 + alpha1dt * (Vbar1 - Vt1) + xi1sdt * sqrt(Vt1) * z[3]
		Vt2 = Vt2 + alpha2dt * (Vbar2 - Vt2) + xi2sdt * sqrt(Vt2) * z[4]


		lnStMA = lnStMA + (MR_alphaMA * (MeanLNMA - lnStMA)-0.5*Vt1) * dt + sqrt(Vt1) * sdt * z[1]
		lnStDA = lnStDA + (MR_alphaDA * (MeanLNDA - lnStDA)-0.5*Vt2) * dt + sqrt(Vt2) * sdt * z[2]
	end


end



means = zeros(Float64, 12, M)

for j in 1:M

	for i in 1:12

		means[i, j] = mean(exp(pathMA[21*(i-1)+(1:21), j]))
	end
end

MAAverage = zeros(Float64, (N-21), M)


for j in 1:M

	for i in 1:12

		MAAverage[21*(i-1)+(1:21), j] = fill(means[i,j], 21)
	end

end


diff = exp(pathDA[22:N,1:M]) - (MAAverage + Strike)


resultVector = zeros(Float64, M)

for i in 1:M

	resultVector[i] = mean(sort(diff[1:(N-21),i], rev=true)[1:days])

end

swingValue = mean(resultVector) * exp(-r*T)

SD = std(resultVector)
SE = SD / sqrt(M)

println("The Call Value is $swingValue")
println("The SD is $SD")
println("The SE is $SE")

MC = [swingValue , SD, SE]

end
