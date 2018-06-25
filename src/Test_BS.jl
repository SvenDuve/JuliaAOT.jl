function BlackScholes(CallPutFlag, S, X, T, r, v)


  d1 = (log(S / X) + (r + v^2 / 2) * T) / (v * sqrt(T))
  d2 = d1 - v * sqrt(T)

  if CallPutFlag == "c"
    BS = S * CND(d1) - X * exp(-r * T) * CND(d2)
  elseif CallPutFlag == "p"
    BS = X * exp(-r * T) * CND(-d2) - S * CND(-d1)
  end

end
