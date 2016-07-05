

##General fix Price Pricer.



parameters <- Params(ACQMax = 33000000, ACQMin = 33000000, HCQMax = (250000/24), HCQMin = 0, Strike = 39.35)

### Intrinsic
diffdpfc <- dailyspline(from = 201610, to = 201709) - parameters$Strike

A <- matrix(0, nrow=nrow(diffdpfc)+1, ncol=nrow(diffdpfc))
A[1,] <- 1
for(i in 1:nrow(diffdpfc)) A[i+1,i] <- 1

A2 <- matrix(0, nrow=nrow(diffdpfc)+1, ncol=nrow(diffdpfc))
A2[1,] <- 1
for(i in 1:nrow(diffdpfc)) A2[i+1,i] <- 1

a <- as.numeric(diffdpfc)
b <- parameters$ACQMin + 1
b[2:(nrow(diffdpfc)+1)] <- parameters$DCQMax
b2 <- parameters$ACQMin
b2[2:(nrow(diffdpfc)+1)] <- parameters$DCQMin
e <- simplex(a=a, A1=A, b1=b, A2=A2, b2=b2, maxi=TRUE)
optimised <- as.numeric(e$soln)
offtake <- cbind(diffdpfc, optimised)
names(offtake) <- c("Spread", "Schedule")
offtake$PNL <- offtake$Spread * offtake$Schedule

intrinsic <- sum(offtake$PNL)

###

### Volumetric

CashVol <- 0.35
ATMVol <- read.csv("~/OptionsPriceSeriesCSV.csv", sep=";", nrows = 24, skip=27)[,9]
ATMVol <- c(CashVol, ATMVol)                 

ATMVol <- xts(ATMVol, as.yearmon(seq(as.Date(Sys.Date()), by = "month", length = 25)))
names(ATMVol) <- "Vol"

BF76 <- caldailyspline(data)
BF76$Strike <- parameters$Strike
BF76$time <- as.numeric(index(BF76) - Sys.Date())/365
BF76$Vol <- caldailyspline(ATMVol)
BF76$OptionValue <- Black76Option("c", as.numeric(BF76$dPrice),
                                  X = as.numeric(BF76$Strike),
                                  Time = as.numeric(BF76$time),
                                  sigma = as.numeric(BF76$Vol),
                                  r = -0.002)@price

BF76$OptionDelta <- GBSGreeks("delta", "c", S = as.numeric(BF76$dPrice),
                              X = as.numeric(BF76$Strike),
                              Time = as.numeric(BF76$time),
                              sigma = as.numeric(BF76$Vol),
                              b = 0, r = -0.002)


VolumetricValue <- sum(sort(as.numeric(BF76$OptionValue[offtake$Schedule==parameters$DCQMin]),
                            decreasing = T)[1:round(parameters$daysVolumetric)] * parameters$DCQMax)


dataSGTTF16$B76Option <- Black76Option("c", as.numeric(dataSGTTF16$TTF), as.numeric(dataSGTTF16$Strike), as.numeric(index(dataSGTTF16) - Sys.Date())/365
                                       , -0.002, as.numeric(TTFVol2016))@price
dataSGTTF16$B76Delta <- GBSGreeks("Delta", "c", as.numeric(dataSGTTF16$TTF), as.numeric(dataSGTTF16$Strike), as.numeric(index(dataSGTTF16) - Sys.Date())/365,
                                  -.002, 0, as.numeric(TTFVol2016))

spreadData <- cbind(apply.monthly(BF76[,c(1,2,4,5,6)], mean),
                    (as.numeric(BF76$time[(endpoints(BF76$time, on = "months", k = 1)+1)[1:12]])))
names(spreadData) <- c("dPrice", "Strike", "Vol", "OptionValue", "OptionDelta", "Time")
SpreadOptionMatrix(spreadData)
spreadValuation <- mean(c(b1, b2, b3, b4)) * parameters$ACQMin

(intrinsic + VolumetricValue + spreadValuation) / 12
(intrinsic + VolumetricValue + spreadValuation) / parameters$ACQMax
