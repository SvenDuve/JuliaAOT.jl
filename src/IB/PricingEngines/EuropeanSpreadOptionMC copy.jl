function EuropeanSpreadOptionMC(K, T, S1, S2, sig1, sig2, div1, div2, rho, r, N, M)

## setting parameters

dt = T/N
nu1dt = (r - div1 - 0.5 * sig1^2) * dt
nu2dt = (r - div2 - 0.5 * sig2^2) * dt
sig1sdt = sig1 * sqrt(dt)
sig2sdt = sig2 * sqrt(dt)
srho = sqrt(1 - rho^2)


## variables to store the sums of the option values

sum_CT = 0
sum_CT2 = 0

## outer loop is the number of simulations bigger is better

for j = 1:M

	St1 = S1
	St2 = S2




	## inner loop is simulating each price path of length N
	for i = 1:N

		error1 = randn()
		error2 = randn()

		z1 = error1
		z2 = rho * error1 + srho * error2

		St1 = St1 * exp(nu1dt + sig1sdt * z1)
		St2 = St2 * exp(nu2dt + sig2sdt * z2)

	end

    	## wraps up and stores all the values of each path
	CT = max(0, St1 - St2 - K)
	sum_CT = sum_CT + CT
	sum_CT2 = sum_CT2 + CT^2

end

## discounting the average call value
call_value = sum_CT / M * exp(-r*T)


SD = (sqrt(sum_CT2 - 1/M * (sum_CT^2)) * exp(-2*r*T)) / (M-1)
SE = SD / sqrt(M)

println("The Call Value is $call_value")
println("The SD is $SD")
println("The SE is $SE")

MC = [call_value, SD, SE]

end
