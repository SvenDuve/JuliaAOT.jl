function GenEuropeanBinomialCall(K, T, S, sig, r, N)

        dt = T/N ## Time to Maturity/ Number of Steps
        nu = r - 0.5*sig^2
        dxu = sqrt(sig^2*dt + (nu*dt)^2)
        dxd = -dxu
        pu = 1/2 + 1/2*(nu*dt/dxu)
        pd = 1 - pu

        disc = exp(-r*dt)

        St = zeros(Float64, (N+1, N+1))

        # Initialising asset prices at maturity

        St[1 , N+1] = S / exp(N * dxd)
        for j in 2:(N+1)
                St[j, N+1] = St[j-1, N+1] / exp(dxu - dxd)
        end


        # create Array for options value tree

        C = zeros(Float64, (N+1, N+1))#linspace(1, N+1, N+1)

        # Initialise Option Values at maturity

        for j in 1:(N+1)
                C[j, N+1] = max(0.0, St[j, N+1] - K)
        end

        # Stepping back through the tree

        for i = linrange(N, 1, N)
                for j in 1:i
                      C[j, i] = disc * (pu * C[j, i+1] + pd * C[j+1, i+1])
                      #St[j,i] = St[j,i+1] / d
                      #P[j, i] = max(P[j, i], K - St[j,i])
                end
        end

C
end
