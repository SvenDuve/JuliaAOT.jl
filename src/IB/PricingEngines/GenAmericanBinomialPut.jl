function GenAmericanBinomialPut(K, T, S, sig, r, N)

        ## as discussed in clewlow and strickland chapter 2, figure 2.12
        ## deviates as different stepping through the matrix requires sometimes
        ## to make use of * instead of /



        dt = T/N ## Time to Maturity/ Number of Steps
        nu = r - 0.5*sig^2
        dxu = sqrt(sig^2*dt + (nu*dt)^2)
        dxd = -dxu
        pu = 1/2 + 1/2*(nu*dt/dxu)
        pd = 1 - pu

        disc = exp(-r*dt)
        dpu = disc*pu
        dpd = disc * pd
        edxud = exp(dxu - dxd)
        edxd = exp(dxd)

        St = zeros(Float64, (N+1, N+1))

        # Initialising asset prices at maturity

        St[1 , N+1] = S / exp(N * dxd)
        for j in 2:(N+1)
                St[j, N+1] = St[j-1, N+1] / edxud
        end


        # create Array for options value tree

        P = zeros(Float64, (N+1, N+1))#linspace(1, N+1, N+1)

        # Initialise Option Values at maturity

        for j in 1:(N+1)
                P[j, N+1] = max(0.0, K - St[j, N+1])
        end

        # Stepping back through the tree

        for i = linrange(N, 1, N)
                for j in 1:i
                      P[j, i] = dpu * P[j, i+1] + dpd * P[j+1, i+1]
                      St[j,i] = St[j,i+1] * edxd
                      P[j, i] = max(P[j, i], K - St[j,i])
                end
        end

P, St
end

