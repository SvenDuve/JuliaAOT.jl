function EuropeanCallMC_Antithetic(K, T, S, sig, r, div, N, M)

## setting parameters

dt = T/N
nudt = (r - div - 0.5 * sig^2) * dt
sigsdt = sig * sqrt(dt)
lnS = log(S)

## variables to store the sums of the option values


sum_CT = 0
sum_CT2 = 0

## outer loop is the number of simulations bigger is better


for j = 1:M

    ## setting up two path variables
  lnSt1 = lnS
  lnSt2 = lnS

  for i = 1:N

      # antithetic variance reduction through the perectly negative correlated error term
    error = randn()
    lnSt1 = lnSt1 + nudt + sigsdt * (error)
    lnSt2 = lnSt2 + nudt + sigsdt * (-error)

  end

    ## wraps up and stores all the values of each path

  ST1 = exp(lnSt1)
  ST2 = exp(lnSt2)
  CT = 0.5 * ( max(0, ST1 - K) + max(0, ST2 - K))
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
