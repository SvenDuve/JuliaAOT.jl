





StrikePrices = [13:0.25:19]



SensitivityMatrix = zeros(Float64, length(StrikePrices), 7)



SensitivityMatrix[:,1] = StrikePrices
SensitivityMatrix[:,2] = 0.25
for i in 1:length(StrikePrices) SensitivityMatrix[i,3] = Black76("c", 11, StrikePrices[i], 1/12, 0.05, SensitivityMatrix[i,2]) end

for i in 1:length(StrikePrices) SensitivityMatrix[i,4] = VannaVolga(10, 11, 12, StrikePrices[i], "c", 1, 0.05, 0, 0.26, 0.25, 0.35)[2] end

for i in 1:length(StrikePrices) SensitivityMatrix[i,5] = Black76("c", 11, StrikePrices[i], 1/12, 0.05, SensitivityMatrix[i,4]) end

for i in 1:length(StrikePrices) SensitivityMatrix[i,6] = Delta("c", 11, StrikePrices[i], 1/12, 0.05, 0, SensitivityMatrix[i,4]) end

for i in 1:length(StrikePrices) SensitivityMatrix[i,7] = Gamma("c", 11, StrikePrices[i], 1/12, 0.05, 0, SensitivityMatrix[i,4]) end



CallAugust = DataFrame(SensitivityMatrix)



impliedVol = zeros(Float64, length(StrikePrices))

for i in 1:length(StrikePrices) impliedVol[i] = VannaVolga(14, 15.75, 18, StrikePrices[i], "c", (84/365), 0.005, 0, 0.34, 0.3245, 0.3375)[2] end


DataFrame(Strikes=StrikePrices, Implied=impliedVol)


Dates.days(Date(2016, 9,29) - today())/365
