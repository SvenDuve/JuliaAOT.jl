function GDelta(CallPutFlag, S, X, T, r, b, v)

  d1 = (log(S / X) + (b + v^2 / 2) * T) / (v * sqrt(T))

  if CallPutFlag == "c"
    delta = exp((b - r) * T) * CND(d1)

  elseif CallPutFlag == "p"
    delta = -exp((b - r) * T) * CND(-d1)
  end


end
