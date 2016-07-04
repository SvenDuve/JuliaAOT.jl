function AmericanPutIFD(K, T, S, sig, r, div, N, Nj, dx)

dt = T/N
nu = r - div - 0.5 * sig^2
edx = exp(dx)
pu = -0.5 * dt * ((sig/dx)^2 + nu/dx)
pm = 1 + dt * (sig/dx)^2 + r * dt
pd = -0.5 * dt * ((sig/dx)^2 - nu/dx)


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
  C[J[j], 1] = max(0, K - St[J[j]])
end

## compute derivative boundary condition

lambda_L = -1 * (St[J[-Nj]+1] - St[J[-Nj]])
lambda_U = 0.0


  function solve_implicit_tridiagonal_system(C, pu, pm, pd, lambda_L, lambda_U)

    ## substitute boundary condition at j = -Nj into j = -Nj+1

    pmp = zeros(Float64, 2N+1)
    pp = zeros(Float64, 2N+1)

    pmp[J[-Nj]+1] = pm + pd
    pp[J[-Nj]+1] = C[J[-Nj]+1, 1] + pd * lambda_L

    ## eliminate upper diagonal
    for j = -Nj+2:Nj-1
      pmp[J[j]] = pm - pu * pd / pmp[J[j]-1]
      pp[J[j]] = C[J[j], 1] - pp[J[j-1]] * pd / pmp[J[j]-1]
    end


    ## use boundary condition at j = Nj and equation at j = Nj-1

    C[J[Nj], 2] = (pp[J[Nj]-1] + pmp[J[Nj]-1] * lambda_U) / (pu + pmp[J[Nj]-1])
    C[J[Nj]-1, 2] = C[J[Nj], 2] - lambda_U

    ## back substitution

    for j = Nj-1:-1:-Nj+1
      C[J[j], 2] = (pp[J[j]] - pu*C[J[j]+1, 2]) / pmp[J[j]]
    end

  C

  end


## Stepping back through the lattice/ This algo is accelerated,
## as it only overwrites the first two cols

  for i = N-1:-1:0

    solve_implicit_tridiagonal_system(C, pu, pm, pd, lambda_L, lambda_U)

    for j = -Nj:Nj
      C[J[j], 1] = max(C[J[j], 2], K - St[J[j]])
    end

  end

C[J[0],1]

end
