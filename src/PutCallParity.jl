function PutCallParity(CallPutFlag, OptionPrice, F, X, T, r)

  # returns for a known options price and the corresponding underlying and Strike
  # the parity price of the other option gender

  if CallPutFlag == "c"
    p = OptionPrice - (F - X) * exp(-r * T)
  elseif CallPutFlag == "p"
    c = OptionPrice + (F - X) * exp(-r * T)
  end

end
