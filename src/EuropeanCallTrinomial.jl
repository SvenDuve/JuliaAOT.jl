function EuropeanCallTrinomial(K, T, S, sig, r, div, N, dx)

  dt = T/N
  nu = r - div - 0.5 * sig^2
  edx = exp(dx)
  pu = 0.5 * ((sig^2 * dt + nu^2 * dt^2) / dx^2 + nu * dt / dx)
  pm = 1 - (sig^2 * dt + nu^2 * dt^2) / dx^2
  pd = 0.5 * ((sig^2 * dt + nu^2 * dt^2) / dx^2 - nu * dt / dx)
  disc = exp(-r * dt)




  ## Initialise asset prices at maturity

  St = zeros(Float64, 2N+1)

  ## creating a shifted ranged for addressing the Array in the usual i,j notation
  J = sub(1:(2N+1), (1+(N+1):((2N+1)+(N+1))))

  ## Asset price at node N,-N
  St[J[-N]] = S * exp(-N * dx)

  ## Asset prices from bottom -N, to N, at time step N
  for j = (-N+1):N
    St[J[j]] = St[J[j]-1] * edx
  end


  ## initialise Array for the tree

  C = zeros(Float64, (2N+1, N+1))

  ## Option Values at expiry, time step = N, in rows -N to N

  for j = -N:N
    C[J[j], N+1] = max(0, St[J[j]] - K)
  end

  ## Stepping back through the lattice

  for i in range(N-1, -1, N)
    for j = -i:i
      C[J[j], i+1] = disc * (pu * C[J[j]+1, i+2] + pm * C[J[j], i+2] + pd * C[J[j]-1, i+2])
    end
  end

C
end