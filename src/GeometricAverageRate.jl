function GeometricAverageRate(CallPutFlag, S, X, T, r, b, v)

  # b = r, give the BS stock option model
  # b = r - q, gives Merton 73, stock option with dividend
  # b = 0, give black 76
  # b = 0 && r = 0, gives Asay for margined futures options
  # b = r- r_f, gives garman kohlhagen currency options model


#require("CND.jl")
d1::Float64
d2::Float64

b = (1/2) * (b - v^2/6)
v = v/sqrt(3)

d1 = (log(S / X) + (b + v^2 / 2) * T) / (v * sqrt(T))
d2 = d1 - v * sqrt(T)

if CallPutFlag == "c"

        GBS = S * exp((b - r) * T) * CND(d1) - X * exp(-r * T) * CND(d2)

elseif CallPutFlag == "p"

        GBS = X * exp(-r * T) * CND(-d2) - S * exp((b - r) * T) * CND(-d1)

end

end

