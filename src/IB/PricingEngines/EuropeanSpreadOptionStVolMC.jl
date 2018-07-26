function EuropeanSpreadOptionStVolMC(K, T, S1, S2, sig1, sig2, div1, div2, alpha1, alpha2,
        Vbar1, Vbar2, xi1, xi2, rhoz, r, N, M)

        #rhoz to be entered as a korrelation matrix

        #N = 1

        dt = T/N
        alpha1dt = alpha1 * dt
        alpha2dt = alpha2 * dt

        xi1sdt = xi1 * sqrt(dt)
        xi2sdt = xi2 * sqrt(dt)
        sdt = sqrt(dt)

        lnS1 = log(S1)
        lnS2 = log(S2)

        z = zeros(Float64, 4)



        ## variable to store the sum of the option values
        sum_CT = 0
        sum_CT2 = 0

        ## outer loop number of simulations

        for j = 1:M

                lnSt1 = lnS1
                lnSt2 = lnS2
                Vt1 = Vbar1
                Vt2 = Vbar2

                for i = 1:N

                        # require generateCorrRandom.jl
                        z = generateCorrRandom(rhoz)

                        Vt1 = Vt1 + alpha1dt * (Vbar1 - Vt1) + xi1sdt * sqrt(Vt1) * z[3]
                        Vt2 = Vt2 + alpha2dt * (Vbar2 - Vt2) + xi2sdt * sqrt(Vt2) * z[4]

                        lnSt1 = lnSt1 + (r-div1-0.5*Vt1)*dt + sqrt(Vt1) * sdt * z[1]
                        lnSt2 = lnSt2 + (r-div2-0.5*Vt2)*dt + sqrt(Vt2) * sdt * z[2]

                end

                St1 = exp(lnSt1)
                St2 = exp(lnSt2)
                CT = max(0 , St1 - St2 - K)
                sum_CT = sum_CT + CT
                sum_CT2 = sum_CT2 + CT*CT

        end


        call_value = sum_CT / M * exp(-r * T)
        SD = sqrt((sum_CT2 - sum_CT * sum_CT / M ) * exp(-2 * r * T) / (M - 1))
        SE = SD / sqrt(M)

end
