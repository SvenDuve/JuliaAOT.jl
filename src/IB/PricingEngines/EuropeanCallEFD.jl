function EuropeanCallEFD(K, T, S, sig, r, div, N, Nj, dx)

  dt = T/N
  nu = r - div - 0.5 * sig^2
  edx = exp(dx)
  pu = 0.5 * dt * ((sig/dx)^2 + nu/dx)
  pm = 1 - dt * (sig/dx)^2 - r * dt
  pd = 0.5 * dt * ((sig/dx)^2 - nu/dx)


  ## Initialise asset prices at maturity

  St = zeros(Float64, 2N+1)

  ## creating a shifted ranged for addressing the Array in the usual i,j notation

  J = sub(1:(2N+1), (1+(N+1):((2N+1)+(N+1))))

  ## Asset price at node N,-N
  St[J[-Nj]] = S * exp(-Nj * dx)

  ## Asset prices from bottom -N, to N, at time step N
  for j = (-Nj+1):Nj
    St[J[j]] = St[J[j]-1] * edx
  end


  ## initialise Array for the tree

  C = zeros(Float64, (2N+1, N+1))

  ## Option Values at expiry, time step = N, in rows -N to N

  for j = -Nj:Nj
    C[J[j], Nj+1] = max(0, St[J[j]] - K)
  end


  ## Stepping back through the lattice

  for i in range(N-1, -1, N)
    for j = -Nj+1:Nj-1
      C[J[j], i+1] = pu * C[J[j]+1, i+2] + pm * C[J[j], i+2] + pd * C[J[j]-1, i+2]
    end
    C[J[-Nj], i+1] = C[J[-Nj]+1, i+1]
    C[J[Nj], i+1] = C[J[Nj]-1, i+1] + (St[J[Nj]]-St[J[Nj]-1])

  end

C
end
