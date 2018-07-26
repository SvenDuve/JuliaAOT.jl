function Black76(CallPutFlag, F, X, T, r, v)


  d1 = (log(F / X) + (v^2 / 2) * T) / (v * sqrt(T))
  d2 = d1 - v * sqrt(T)

  if CallPutFlag == "c"
          exp(-r * T) * (F * CND(d1) - X * CND(d2))
  elseif CallPutFlag == "p"
          exp(-r * T) * (X * CND(-d2) - F * CND(-d1))
  else
          println(STDERR, "Falsche Eingabe! Abbruch")
  end

end
