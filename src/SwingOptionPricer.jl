function SwingOptionPricer(K, T, SMA, SDA, days, Strike, sigMA, sigDA, rho, r, div1, div2, N, M)

## setting parameters

dt = T/N
nuMAdt = (r - div1 - 0.5 * sigMA^2) * dt
nuDAdt = (r - div2 - 0.5 * sigDA^2) * dt

sigMAsdt = sigMA * sqrt(dt)
sigDAsdt = sigDA * sqrt(dt)
srho = sqrt(1 - rho^2)

pathMA = zeros(Float64, N, M)
pathDA = zeros(Float64, N, M)

## outer loop is the number of simulations bigger is better

for j = 1:M

	StMA = SMA
	StDA = SDA


	## inner loop is simulating each price path of length N
	for i = 1:N

		error1 = randn()
		error2 = randn()

		z1 = error1
		z2 = rho * error1 + srho * error2

		pathMA[i,j] = StMA
		pathDA[i,j] = StDA

		StMA = StMA * exp(nuMAdt + sigMAsdt * z1)
		StDA = StDA * exp(nuDAdt + sigDAsdt * z2)

	end


end



means = zeros(Float64, 12, M)

for j in 1:M

	for i in 1:12

		means[i, j] = mean(pathMA[21*(i-1)+(1:21), j])
	end
end

MAAverage = zeros(Float64, (N-21), M)


for j in 1:M

	for i in 1:12

		MAAverage[21*(i-1)+(1:21), j] = fill(means[i,j], 21)
	end

end


diff = pathDA[22:N,1:M] - (MAAverage + Strike)


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
