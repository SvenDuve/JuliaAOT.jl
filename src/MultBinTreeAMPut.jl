function MultBinTreeAMPut(K, T, S, r, N, u, d)
        dt = T/N ## Time to Maturity/ Number of Steps
        p = (exp(r * dt) - d) / (u - d)
        disc = exp(-r * dt)

        #St = linspace(1,N+1,N+1)

        St = Array(Float64, (N+1, N+1))

        # Initialising asset prices at maturity

        St[1 , N+1] = S * u^N
        for j in 2:(N+1)
                St[j, N+1] = St[j-1, N+1] * d/u
        end

        #St = flipdim(St, 1)

        # create Array for options value tree

        P = Array(Float64, (N+1, N+1))#linspace(1, N+1, N+1)

        # Initialise Option Values at maturity

        for j in 1:(N+1)
                P[j, N+1] = max(0.0, K - St[j, N+1])
        end

        # Stepping back through the tree

        for i = linrange(N, 1, N)
                for j in 1:i
                      P[j, i] = disc * (p * P[j, i+1] + (1-p) * P[j+1, i+1])
                      St[j,i] = St[j,i+1] * d
                      P[j, i] = max(P[j, i], K - St[j,i])
                end
        end

P

end

MultBinTreeAMPut(100,1,100,0.06,3,1.1,0.9091)

