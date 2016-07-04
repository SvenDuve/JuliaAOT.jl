function AmericanSpreadCallBinomial(K, T, S1, S2, sig1, sig2, div1, div2, rho, r, N)


  dt = T/N ## Time to Maturity/ Number of Steps
  nu1 = r - div1 - 0.5 * sig1^2
  nu2 = r - div2 - 0.5 * sig2^2


  dx1 = sig1 * sqrt(dt)
  dx2 = sig2 * sqrt(dt)

  disc = exp(-r * dt)

  puu = (dx1 * dx2 + (dx2 * nu1 + dx1 * nu2 + rho * sig1 * sig2) * dt) / (4 * dx1 * dx2) * disc

  pud = (dx1 * dx2 + (dx2 * nu1 - dx1 * nu2 - rho * sig1 * sig2) * dt) / (4 * dx1 * dx2) * disc

  pdu = (dx1 * dx2 + (-dx2 * nu1 + dx1 * nu2 - rho * sig1 * sig2) * dt) / (4 * dx1 * dx2) * disc

  pdd = (dx1 * dx2 + (-dx2 * nu1 - dx1 * nu2 + rho * sig1 * sig2) * dt) / (4 * dx1 * dx2) * disc


  edx1 = exp(dx1)
  edx2 = exp(dx2)



  S1t = linspace(-N, N, 2N+1)
  S2t = linspace(-N, N, 2N+1)

  S1t[1] = S1 * exp(-N * dx1)
  S2t[1] = S2 * exp(-N * dx2)



  for j in 2:length(-N:N)
    S1t[j] = S1t[j-1] * edx1
    S2t[j] = S2t[j-1] * edx2
  end

  C = Array(Float64, (2N+1,2N+1))

  for j = 1:2:length(-N:N)
    for k = 1:2:length(-N:N)
      C[k, j] = max(0.0, S1t[j] - S2t[k] - K)
    end
  end

  for i in range(N-1, -1, N)
    for j in range(-i, 2, i+1) # potentially this is i^2
      for k in range(-i, 2, i+1) # potentiall this is i^2 as well
        C[k+(N+1), j+(N+1)] = pdd * C[k+(N+1)-1, j+(N+1)-1] + pud * C[k+(N+1)-1, j+(N+1)+1] + pdu * C[k+(N+1)+1, j+(N+1)-1] + puu * C[k+(N+1)+1, j+(N+1)+1]
        C[k+(N+1), j+(N+1)] = max(C[k+(N+1), j+(N+1)], S1t[j+(N+1)] - S2t[k+(N+1)] - K)
      end
    end
  end

  C[N+1, N+1]

end
