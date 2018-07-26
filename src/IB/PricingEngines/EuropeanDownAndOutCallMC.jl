function EuropeanDownAndOutCallMC(K, T, S, sig, r, div, H, N, M)


dt = T/N
nudt = (r - div - 0.5 * sig^2) * dt
sigsdt = sig * sqrt(dt)


## variables to store the sums of the option values

sum_CT = 0
sum_CT2 = 0

## outer loop is the number of simulations bigger is better

for j = 1:M

        St = S
        BARRIERCROSSED = false
    ## inner loop is simulating each price path of length N
        for i = 1:N

        St = St * exp( nudt + sigsdt * randn()) ## note, it only add the changes, does not store the path

        if St <= H

                BARRIERCROSSED = true
                break
        end

        end

    ## wraps up and stores all the values of each path

if BARRIERCROSSED == true
            CT = 0

        else

            CT = max(0, St - K)
        end

sum_CT = sum_CT + CT
sum_CT2 = sum_CT2 + CT^2

    end

  ## discounting the average call value
call_value = sum_CT / M * exp(-r*T)


SD = (sqrt(sum_CT2 - 1/M * (sum_CT^2)) * exp(-2*r*T)) / (M-1)
SE = SD / sqrt(M)

println("The Call Value is $call_value")
println("The SD is $SD")
println("The SE is $SE")

MC = [call_value, SD, SE]

end



