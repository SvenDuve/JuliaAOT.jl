
function BinTreeCall(K, T, S, r, N, u, d)
        dt = T/N ## Time to Maturity/ Number of Steps
        p = (exp(r * dt) - d) / (u - d)
        disc = exp(-r * dt)

        St = zeros(N+1)

        St[1] = S * d^N

        for j in 2:(N+1)
                St[j] = St[j-1] * u/d
        end

        St = flipdim(St, 1)

        C = Array(Float64, (N+1, N+1))#linspace(1, N+1, N+1)

        for j in 1:(N+1)
                C[j, N+1] = max(0.0, St[j] - K)
        end

        for i = N:-1:1
                for j in 1:i
                      C[j, i] = disc * (p * C[j, i+1] + (1-p) * C[j+1, i+1])
                end
        end

C
end




BinTreeCall(100,1,100,0.06,3,1.1,0.9091)
