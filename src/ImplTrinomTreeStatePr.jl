
call = [0 0 0.0001 0.0011 0.0055 ;
        0 0 0.005 0.0412 0.1399 ;
        0 0.0403 0.4195 1.1159 1.9965 ;
        0 4.7469 7.1559 9.1754 10.9895 ;
        22.3035 23.4719 24.7110 25.9912 27.2682 ;
        39.6325 40.5313 41.4170 42.2922 43.1598 ;
        53.0966 53.7949 54.4828 55.1604 55.8281]
put = [113.2040 110.0298 106.903 103.8236 100.7935 ;
       65.6521 63.1859 60.7613 58.4042 56.1451 ;
       28.7059 26.83 25.3216 24.1584 23.2072 ;
       0 3.2581 4.2004 4.7752 5.1660 ;
       0 0.0117 0.1112 0.2689 0.44 ;
       0 0 0.0003 0.0033 0.0118 ;
       0 0 0 0 0.0001]


put[1,1]


T, S, r, N, dx = 1, 100, 0.06, 4, 0.2524



dt = T/N
edx = exp(dx)

## Initialise asset prices at maturity

St = zeros(Float64, 2N+1)
Q = zeros(Float64, (2N+1, N+1))

  ## creating a shifted ranged for addressing the Array in the usual i,j notation
J = sub(1:(2N+1), (1+(N+1):((2N+1)+(N+1))))

## Asset price at node N,-N
St[2N+1] = S * exp(-N * dx)

## Asset prices from bottom -N, to N, at time step N
for j = 2N:-1:1
St[j] = St[j+1] * edx
end



for i = 1:N

    for j = i:-1:0

            sum = 0


            for k = i:-1:(j+1)

                 sum = sum + Q[(N+1)-k, i]*(St[(N+1)-k] - St[(N+1)-j])

            end

        Q[(N+1)-j, i] = (call[(N+1)-j, i] - sum) / (St[(N+1)-j] - St[(N+1)-j+1])

    end


    for j = -i:1:-1

            sum = 0
            println("I am here $j")

            for k = -i:-1:j
                     println("k is $k")
                sum = sum + Q[(N+1)-k, i]*(St[(N+1)+j-1] - St[(N+1)-k])
                #println("$sum")
            end

         Q[N+1-j, i] = (put[N-j-1, i] - sum) / (St[N+1+j-1] - St[N+1+j])

    end


end


Q

Q = zeros(Float64, (2N+1, N+1))

for j in -4:1:-1
    x = put[N-j-1,1]
    println("x is $x")
end
call[]




  ## initialise Array for the tree

  C = zeros(Float64, (2N+1, N+1))

  ## Option Values at expiry, time step = N, in rows -N to
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
