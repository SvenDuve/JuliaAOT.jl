function VannaVolga(putStrike, ATMStrike, callStrike, kStrike, kFlag, T, r, b, putVol, ATMVol, callVol)

# Reversal and BF

RRVol = callVol - putVol
BFVol = (callVol + putVol) / 2 - ATMVol


# Put

vega1 = Vega("c", ATMStrike, putStrike, T, r, b, ATMVol)
volga1 = DVegaDVol("c", ATMStrike, putStrike, T, r, b, ATMVol)
vanna1 = DDeltaDVol("c", ATMStrike, putStrike, T, r, b, ATMVol)


# ATM

vega2 = Vega("c", ATMStrike, ATMStrike, T, r, b, ATMVol)
volga2 = DVegaDVol("c", ATMStrike, ATMStrike, T, r, b, ATMVol)
vanna2 = DDeltaDVol("c", ATMStrike, ATMStrike, T, r, b, ATMVol)


# Call

vega3 = Vega("c", ATMStrike, callStrike, T, r, b, ATMVol)
volga3 = DVegaDVol("c", ATMStrike, callStrike, T, r, b, ATMVol)
vanna3 = DDeltaDVol("c", ATMStrike, callStrike, T, r, b, ATMVol)


# Any Strike K

vegaK = Vega("c", ATMStrike, kStrike, T, r, b, ATMVol)
volgaK = DVegaDVol("c", ATMStrike, kStrike, T, r, b, ATMVol)
vannaK = DDeltaDVol("c", ATMStrike, kStrike, T, r, b, ATMVol)


weight1 = (vegaK / vega1) * ((log(ATMStrike / kStrike) * log(callStrike / kStrike)) / (log(ATMStrike / putStrike) * log(callStrike / putStrike)))
weight2 = (vegaK / vega2) * ((log(kStrike / putStrike) * log(callStrike / kStrike)) / (log(ATMStrike / putStrike) * log(callStrike / ATMStrike)))
weight3 = (vegaK / vega3) * ((log(kStrike / putStrike) * log(kStrike / ATMStrike)) / (log(callStrike / putStrike) * log(callStrike / ATMStrike)))


o1 = weight1 * (GBlackScholes("c", ATMStrike, putStrike, T, r, b, putVol) - GBlackScholes("c", ATMStrike, putStrike, T, r, b, ATMVol))
o2 = weight2 * (GBlackScholes("c", ATMStrike, ATMStrike, T, r, b, ATMVol) - GBlackScholes("c", ATMStrike, ATMStrike, T, r, b, ATMVol))
o3 = weight3 * (GBlackScholes("c", ATMStrike, callStrike, T, r, b, callVol) - GBlackScholes("c", ATMStrike, callStrike, T, r, b, ATMVol))

premiumK = GBlackScholes(kFlag, ATMStrike, kStrike, T, r, b, ATMVol) + sum([o1, o2, o3])


impliedK = putVol * ((log(ATMStrike / kStrike) * log(callStrike / kStrike)) / (log(ATMStrike / putStrike) * log(callStrike / putStrike))) +
                ATMVol * ((log(kStrike / putStrike) * log(callStrike / kStrike)) / (log(ATMStrike / putStrike) * log(callStrike / ATMStrike))) +
                callVol * ((log(kStrike / putStrike) * log(kStrike / ATMStrike)) / (log(callStrike / putStrike) * log(callStrike / ATMStrike)))


[premiumK, impliedK]

end
