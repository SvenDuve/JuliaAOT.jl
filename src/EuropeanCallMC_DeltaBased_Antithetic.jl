function EuropeanCallMC_DeltaBased_Antithetic(K, T, S, sig, r, div, N, M)

## setting parameters

dt = T/N
nudt = (r - div - 0.5 * sig^2) * dt
sigsdt = sig * sqrt(dt)
erddt = exp((r - div) * dt)

beta1 = -1

## variables to store the sums of the option values

sum_CT = 0
sum_CT2 = 0


function CND(X)
#   y::float64
#   Exponential::float64
#   SumA::float64
#   SumB::float64

  y = abs(X)

  if y > 37
    cnd = 0
  else
    Exponential = exp(-y^2/2)

    if y < 7.07106781186547
      SumA = 0.0352624965998911 * y + 0.700383064443688
      SumA = SumA * y + 6.37396220353165
      SumA = SumA * y + 33.912866078383
      SumA = SumA * y + 112.079291497871
      SumA = SumA * y + 221.213596169931
      SumA = SumA * y + 220.206867912376
      SumB = 0.0883883476483184 * y + 1.75566716318264
      SumB = SumB * y + 16.064177579207
      SumB = SumB * y + 86.7807322029461
      SumB = SumB * y + 296.564248779674
      SumB = SumB * y + 637.333633378831
      SumB = SumB * y + 793.826512519948
      SumB = SumB * y + 440.413735824752
      cnd = Exponential * SumA / SumB
    else
      SumA = y + 0.65
      SumA = y + 4 / SumA
      SumA = y + 3 / SumA
      SumA = y + 2 / SumA
      SumA = y + 1 / SumA
      cnd = Exponential / (SumA * 2.506628274631)

      end
  end

  if X > 0
    cnd = 1 - cnd
  end

cnd

end


function GDelta(CallPutFlag, S, X, T, r, b, v)

  #require("CND.jl")
  d1::Float64

  d1 = (log(S / X) + (b + v^2 / 2) * T) / (v * sqrt(T))

  if CallPutFlag == "c"
    delta = exp((b - r) * T) * CND(d1)

  elseif CallPutFlag == "p"
    delta = -exp((b - r) * T) * CND(-d1)
  end

    delta

end








## outer loop is the number of simulations bigger is better

for j = 1:M

  St1 = S
  St2 = S
  cv1 = 0
  cv2 = 0


    ## inner loop is simulating each price path of length N
  for i = 1:N

    t = (i) * dt
    delta1 = GDelta("c", St1, K, t, r, div, sig)
    delta2 = GDelta("c", St2, K, t, r, div, sig)
    error = randn()
    Stn1 = St1 * exp(nudt + sigsdt * (error)) ## note, it only add the changes, does not store the path
    Stn2 = St2 * exp(nudt + sigsdt * (-error)) ## note, it only add the changes, does not store the path
    cv1 = cv1 + delta1 * (Stn1 - St1 * erddt)
    cv2 = cv2 + delta2 * (Stn2 - St2 * erddt)
    St1 = Stn1
    St2 = Stn2

  end

    ## wraps up and stores all the values of each path

  CT = 0.5 * (max(0, St1 - K) + beta1*cv1 + max(0, St2 - K) + beta1*cv2)
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
