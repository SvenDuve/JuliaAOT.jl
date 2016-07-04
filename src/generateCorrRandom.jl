function generateCorrRandom(rhoz)

        e = randn(size(rhoz, 2))

        C = transpose(chol(rhoz))

        *(C,e)

end
