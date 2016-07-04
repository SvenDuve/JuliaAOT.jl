function GBlackScholes(CallPutFlag, S, X, T, r, b, v)

  # b = r, give the BS stock option model
  # b = r - q, gives Merton 73, stock option with dividend
  # b = 0, give black 76
  # b = 0 && r = 0, gives Asay for margined futures options
  # b = r- r_f, gives garman kohlhagen currency options model

  d1 = (log(S / X) + (b + v^2 / 2) * T) / (v * sqrt(T))
  d2 = d1 - v * sqrt(T)

  if CallPutFlag == "c"
    GBS = S * exp((b - r) * T) * CND(d1) - X * exp(-r * T) * CND(d2)
  elseif CallPutFlag == "p"
    GBS = X * exp(-r * T) * CND(-d2) - S * exp((b - r) * T) * CND(-d1)
  end


end



function KirkSpreadOption(CallPutFlag, S1, S2, X, T, r, b1, b2, v1, v2, cor)


        S = (S1 * exp((b1 - r) * T)) / (S2 * exp((b2 - r) * T) + X * exp((-r) * T))
        F = (S2 * exp((b2 - r) * T)) / (S2 * exp((b2 - r) * T) + X * exp((-r) * T))
        sig = sqrt(v1^2 + (v2 * F)^2 - 2 * cor * v1 * v2 * F)


        d1 = (log(S) + (sig^2 / 2) * T) / (sig * sqrt(T))
        d2 = d1 - sig * sqrt(T)

        if CallPutFlag == "c"


                return (S2 * exp((b2 - r) * T) + X * exp((-r) * T)) * (S * CND(d1) - CND(d2))


        elseif CallPutFlag == "p"

                return (S2 * exp((b2 - r) * T) + X * exp((-r) * T)) * (CND(-d2) - S * CND(-d1))


        else

                println(STDERR, "Falsche Eingabe! Abbruch\n")
                return 0.0 #eventuell nochmal checken ob das sinn macht

        end



end


function GeoAveRate(CallPutFlag, S, X, T, r, b, v)


        sigAdj = v / sqrt(3)
        bAdj = (b - v^2 / 6) / 2

        d1 = (log(S / X) + (bAdj + (sigAdj^2 / 2)) * T) / (sigAdj * sqrt(T))
        d2 = d1 - sigAdj * sqrt(T)

        if CallPutFlag == "c"

                return S * exp((bAdj - r) * T) * CND(d1) - X * exp((-r) * T) * CND(d2)

        elseif CallPutFlag == "p"

                return X * exp((-r) * T) * CND((-d2)) - S * exp((bAdj - r) * T) * CND((-d1))


        else

                println(STDERR, "Falsche Eingabe! Abbruch\n")
                return 0.0 #eventuell nochmal checken ob das sinn macht
        end

end
