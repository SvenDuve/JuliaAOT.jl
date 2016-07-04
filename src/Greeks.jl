
dS = 0.01


# b = r gives Black Scholes on Stocks
# b = r - q gives stock option with dividend yield q
# b = 0 give Black76
# b and r = 0 gives margined Future Options
# b = r - rf give Garman Kohlhagen currency options



function Delta(CallPutFlag,  S,  X,  T,  r,  b,  v)

        return (
        (GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v) -
        GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v)) / (2 * dS)
        )

end


function Elasticity(CallPutFlag,  S,  X,  T,  r,  b,  v)

        return ((GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v) -
                GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v)) / (2 * dS)
                * S / GBlackScholes(CallPutFlag, S, X, T, r, b, v)
                )
end


function Gamma(CallPutFlag,  S,  X,  T,  r,  b,  v)

        return ((GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v)
                - 2 * GBlackScholes(CallPutFlag, S, X, T, r, b, v) +
                GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v)) / dS^2
                )

end


function DGammaDVol(CallPutFlag, S, X, T, r, b, v)

        return ((GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v + dS) -
                2 * GBlackScholes(CallPutFlag, S , X, T, r, b, v + dS) +
                GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v + dS) -
                GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v - dS) +
                2 * GBlackScholes(CallPutFlag, S, X, T, r, b, v - dS) -
                GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v - dS)) /
                (2 * dS * dS^2) / 100
                )

end


function GammaP(CallPutFlag, S, X, T, r, b, v)

        return (S / 100 * (GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v) -
                2 * GBlackScholes(CallPutFlag, S , X, T, r, b, v) +
                GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v)) / dS^2
                )

end


function DDeltaDVol(CallPutFlag, S, X, T, r, b, v)


        return (
                1/(4 * dS * dS) * (GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v + dS)
                - GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v - dS)
                - GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v + dS)
                + GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v - dS)) / 100
                )

end


function Vega(CallPutFlag, S, X, T, r, b, v)

        return (
                (GBlackScholes(CallPutFlag, S, X, T, r, b, v + dS) -
                GBlackScholes(CallPutFlag, S, X, T, r, b, v - dS)) / 2
                )

end

function Vomma(CallPutFlag, S, X, T, r, b, v)

        return (
                (GBlackScholes(CallPutFlag, S, X, T, r, b, v + dS)
                - 2 * GBlackScholes(CallPutFlag, S, X, T, r, b, v)
                + GBlackScholes(CallPutFlag, S, X, T, r, b, v - dS)) / dS^2 / 10000
                )
end


function VegaP(CallPutFlag, S, X, T, r, b, v)

        return (
                v / 0.1 * (GBlackScholes(CallPutFlag, S, X, T, r, b, v + dS) -
                GBlackScholes(CallPutFlag, S, X, T, r, b, v - dS)) / 2
                )

end

function DVegaDVol(CallPutFlag, S, X, T, r, b, v)

        return (
                (GBlackScholes(CallPutFlag, S, X, T, r, b, v + dS) -
                2 * GBlackScholes(CallPutFlag, S, X, T, r, b, v) +
                GBlackScholes(CallPutFlag, S, X, T, r, b, v - dS))
                )

end


function Theta(CallPutFlag, S, X, T, r, b, v)

        if T <= (1/365)

                return (
                        GBlackScholes(CallPutFlag, S, X, 1e-05, r, b, v) -
                        GBlackScholes(CallPutFlag, S, X, T, r, b, v)
                        )
        else

                return (
                        GBlackScholes(CallPutFlag, S, X, T - (1/365), r, b, v) -
                        GBlackScholes(CallPutFlag, S, X, T, r, b, v)
                        )
        end

end



function Rho(CallPutFlag, S, X, T, r, b, v)

        return (
                (GBlackScholes(CallPutFlag, S, X, T, r + dS, b + dS, v)
                - GBlackScholes(CallPutFlag, S, X, T, r - dS, b - dS, v)) / 2
                )

end

function RhoFut(CallPutFlag,  S,  X,  T,  r,  b,  v)

        return (
                (GBlackScholes(CallPutFlag, S, X, T, r + dS, b, v) -
                GBlackScholes(CallPutFlag, S, X, T, r - dS, b, v)) / 2
                )

end

function Rho2(CallPutFlag, S, X, T, r, b, v)

        return (
                (GBlackScholes(CallPutFlag, S, X, T, r, b - dS, v) -
                GBlackScholes(CallPutFlag, S, X, T, r, b + dS, v)) / 2
                )

end


function Carry(CallPutFlag, S, X, T, r, b, v)

        return (
                (GBlackScholes(CallPutFlag, S, X, T, r, b + dS, v) -
                GBlackScholes(CallPutFlag, S, X, T, r, b - dS, v)) / 2
                )

end


function Speed(CallPutFlag, S, X, T, r, b, v)

        return (
                1 / dS^3 * (GBlackScholes(CallPutFlag, S + 2 * dS, X, T, r, b, v) -
                3 * GBlackScholes(CallPutFlag, S + dS, X, T, r, b, v) +
                3 * GBlackScholes(CallPutFlag, S, X, T, r, b, v) -
                GBlackScholes(CallPutFlag, S - dS, X, T, r, b, v))
                )

end


function StrikeDelta(CallPutFlag, S, X, T, r, b, v)

        return (
                (GBlackScholes(CallPutFlag, S, X + dS, T, r, b, v) -
                GBlackScholes(CallPutFlag, S, X - dS, T, r, b, v)) / (2 * dS)
                )

end

function RNDensity(CallPutFlag, S, X, T, r, b, v)

        return (
                (GBlackScholes(CallPutFlag, S, X + dS, T, r, b, v) -
                2 * GBlackScholes(CallPutFlag, S, X, T, r, b, v) +
                GBlackScholes(CallPutFlag, S, X - dS, T, r, b, v)) / dS^2
                )

end

# function CrossGamma(CallPutFlag, S1, S2, X, T, r, b1, b2, v1, v2, cor)
#
#         return {
#                 (KirkSpreadOption(CallPutFlag, S1, S2 + dS, X, T, r, b1, b2, v1, v2, cor)
#                 - 2 * KirkSpreadOption(CallPutFlag, S1, S2, X, T, r, b1, b2, v1, v2, cor) +
#                 KirkSpreadOption(CallPutFlag, S1, S2 - dS, X, T, r, b1, b2, v1, v2, cor)) / dS^2
#                 }
#
# end
