

## Options


mean(Black76Option("p", 16.875, 15, S16, -.0024, .2345)@price)*24*182*300
mean(Black76Option("p", 16.875, 12, S16, -.0024, .299)@price)*24*182*300
Black76Option("p", 17.55, 17, Jan16, -.0024, .26)@price
pricerange <- seq(10,25,0.01)

mean(Black76Option("p", 17, 15, Q116, -.0024, .274)@price)
mean(Black76Option("p", 17, 16, Q116, -.0024, .2488)@price)
mean(Black76Option("c", 17, 18, Q116, -.0024, .251)@price)
mean(Black76Option("c", 17, 19, Q116, -.0024, .267)@price)


n <- 2*Black76Option("p", pricerange, 15, Jan16, -.0024, .274)@price
o <- -Black76Option("p", pricerange, 16, Jan16, -.0024, .2488)@price
p <- -Black76Option("c", pricerange, 18, Jan16, -.0024, .251)@price
q <- 2*Black76Option("c", pricerange, 19, Jan16, -.0024, .267)@price

c <- 2*GBSGreeks("delta", "p", pricerange, 15, Jan16, -.0024, b=0, .274)
d <- -GBSGreeks("delta", "p", pricerange, 16, Jan16, -.0024, b=0, .2488)
a <- -GBSGreeks("delta", "c", pricerange, 18, Jan16, -.0024, b=0, .251)
b <- 2*GBSGreeks("delta", "c", pricerange, 19, Jan16, -.0024, b=0, .267)

e <- 2*GBSGreeks("gamma", "p", pricerange, 15, Jan16, -.0024, b=0, .274)
f <- -GBSGreeks("gamma", "p", pricerange, 16, Jan16, -.0024, b=0, .2488)
g <- -GBSGreeks("gamma", "c", pricerange, 18, Jan16, -.0024, b=0, .251)
h <- 2*GBSGreeks("gamma", "c", pricerange, 19, Jan16, -.0024, b=0, .267)

j <- GBSGreeks("theta", "p", 17.55, 17, seq(Jan16,0, -0.01), -.0024, b=0, .299)
k <- -GBSGreeks("theta", "p", 17.55, 15, seq(Jan16,0, -0.01), -.0024, b=0, .2345)
l <- -GBSGreeks("theta", "c", 17.55, 18, seq(Jan16,0, -0.01), -.0024, b=0, .2345)
m <- GBSGreeks("theta", "c", 17.55, 20, seq(Jan16,0, -0.01), -.0024, b=0, .299)


par(mfrow=c(3,1))
plot(pricerange, (n+o), type="l", main="Price")
plot(pricerange, (c+d), type="l", main="Delta")
plot(pricerange, (e+f), type="l", main="Gamma")
plot(-seq(Jan16,0, -0.01), (j+k), type="l", main="Theta")



mean(Black76Option("p", 17.9, 16, W16, -.0024, .23)@price)#*24*182*300
mean(Black76Option("p", 17.9, 13, W16, -.0024, .303)@price)#*24*182*300

pricerange <- seq(8,24,0.01)

a <- GBSGreeks("delta", "p", pricerange, 16, mean(W16), -.0024, b=0, .23)
b <- -GBSGreeks("delta", "p", pricerange, 13, mean(W16), -.0024, b=0, .303)

c <- GBSGreeks("gamma", "p", pricerange, 16, mean(W16), -.0024, b=0, .23)
d <- -GBSGreeks("gamma", "p", pricerange, 13, mean(W16), -.0024, b=0, .303)

e <- GBSGreeks("theta", "p", 16.875, 16, seq(mean(W16),0, -0.01), -.0024, b=0, .23)
f <- -GBSGreeks("theta", "p", 16.875, 13, seq(mean(W16),0, -0.01), -.0024, b=0, .303)

par(mfrow=c(3,1))
plot(pricerange, (a+b), main="Delta")
plot(pricerange, (c+d), main="Gamma")
plot(-seq(mean(W16),0, -0.01), -(e+f), main="Theta")


## Summer16 TTF
crossS16 <- 16.6
mean(dLocalizer("TTF", "p", crossS16, 18, S16, -0.002, 0.216, 4))
mean(Black76Option("c", crossS16, 17, S16, -.003, .2123)@price)
mean(Black76Option("c", crossS16, 18, S16, -.003, .221)@price)
mean(Black76Option("c", crossS16, 19, S16, -.003, .221)@price)

mean(Black76Option("p", crossS16, 16, S16, -.003, .2168)@price)
mean(Black76Option("p", crossS16, 12, S16, -.003, .31)@price)



## Winter16 TTF
crossW16 <- 17.65
mean(dLocalizer("TTF", "p", crossW16, 16.5, S16, -0.002, 0.212, 10))
mean(Black76Option("p", crossW16, 16.5, W16, -.003, .212)@price)

## Summer17 TTF
crossS17 <- 16
mean(dLocalizer("TTF", "c", crossS17, 18, S17, -0.002, 0.1839, 16))
mean(Black76Option("c", crossS17, 18, S17, -0.003, 0.19)@price)

## Q1 TTF
crossQ116TTF <- 17.25
mean(dLocalizer("TTF", "p", crossQ116TTF, 15, Q116, -0.002, 0.2797, 1))
mean(Black76Option("c", crossQ116TTF, 18, Q116, -.002, .251)@price)
mean(Black76Option("c", crossQ116TTF, 19, Q116, -.002, .267)@price)
mean(Black76Option("c", crossQ116TTF, 20, Q116, -.002, .2815)@price)

mean(Black76Option("p", crossQ116TTF, 16, Q116, -.002, .248)@price)
mean(Black76Option("p", crossQ116TTF, 15, Q116, -.002, .2797)@price)
-mean(GBSGreeks("Delta", "p", crossQ116TTF, 16, Q116, -.002, 0, 0.248))
2*mean(GBSGreeks("Delta", "p", crossQ116TTF, 15, Q116, -.002, 0, 0.2744))
dLocalizer("TTF", "p", 17.1, 17, Jan16, -0.002, 0.238,1)
Black76Option("p", 17.1, 17, Jan16, -.002, 0.239)@price

## Q116 NBP
crossQ116NBP <- 37.1
mean(dLocalizer("NBP", "c", crossQ116NBP, 46, Q116, -0.002, 0.334, 1))
mean(Black76Option("c", crossQ116NBP, 38, Q116, -.003, .259)@price)
mean(Black76Option("c", crossQ116NBP, 39, Q116, -.003, .2704)@price)
mean(Black76Option("c", crossQ116NBP, 46, Q116, -.003, .334)@price)



## Expiries

today <- Sys.Date()
Dec15 <- as.numeric(as.Date("26/11/2015", "%d/%m/%Y")-today)/365
Jan16 <- as.numeric(as.Date("24/12/2015", "%d/%m/%Y")-today)/365
Feb16 <- as.numeric(as.Date("27/01/2016", "%d/%m/%Y")-today)/365
Mar16 <- as.numeric(as.Date("25/02/2016", "%d/%m/%Y")-today)/365
Apr16 <- as.numeric(as.Date("24/03/2016", "%d/%m/%Y")-today)/365
May16 <- as.numeric(as.Date("26/04/2016", "%d/%m/%Y")-today)/365
Jun16 <- as.numeric(as.Date("27/05/2016", "%d/%m/%Y")-today)/365
Jul16 <- as.numeric(as.Date("24/06/2016", "%d/%m/%Y")-today)/365
Aug16 <- as.numeric(as.Date("27/07/2016", "%d/%m/%Y")-today)/365
Sep16 <- as.numeric(as.Date("26/08/2016", "%d/%m/%Y")-today)/365
Oct16 <- as.numeric(as.Date("26/09/2016", "%d/%m/%Y")-today)/365
Nov16 <- as.numeric(as.Date("27/10/2016", "%d/%m/%Y")-today)/365
Dec16 <- as.numeric(as.Date("25/11/2016", "%d/%m/%Y")-today)/365
Jan17 <- as.numeric(as.Date("23/12/2016", "%d/%m/%Y")-today)/365
Feb17 <- as.numeric(as.Date("27/01/2017", "%d/%m/%Y")-today)/365
Mar17 <- as.numeric(as.Date("24/02/2017", "%d/%m/%Y")-today)/365
Apr17 <- as.numeric(as.Date("27/03/2017", "%d/%m/%Y")-today)/365
May17 <- as.numeric(as.Date("26/04/2017", "%d/%m/%Y")-today)/365
Jun17 <- as.numeric(as.Date("26/05/2017", "%d/%m/%Y")-today)/365
Jul17 <- as.numeric(as.Date("26/06/2017", "%d/%m/%Y")-today)/365
Aug17 <- as.numeric(as.Date("27/07/2017", "%d/%m/%Y")-today)/365
Sep17 <- as.numeric(as.Date("25/08/2017", "%d/%m/%Y")-today)/365
Oct17 <- as.numeric(as.Date("26/09/2017", "%d/%m/%Y")-today)/365
Nov17 <- as.numeric(as.Date("27/10/2017", "%d/%m/%Y")-today)/365
Dec17 <- as.numeric(as.Date("24/11/2017", "%d/%m/%Y")-today)/365

Q116 <- c(Jan16, Feb16, Mar16)
Q216 <- c(Apr16, May16, Jun16)
Q316 <- c(Jul16, Aug16, Sep16)
Q416 <- c(Oct16, Nov16, Dec16)
Q117 <- c(Jan17, Feb17, Mar17)
Q217 <- c(Apr17, May17, Jun17)
Q317 <- c(Jul17, Aug17, Sep17)
Q417 <- c(Oct17, Nov17, Dec17)

S16 <- c(Q216, Q316)
W16 <- c(Q416, Q117)
S17 <- c(Q217, Q317)
#W17 <- c(Q417, Q118)

ACQMax <- 1500000
ACQMin <- 1200000
DCQMax <- 350 * 24
DCQMin <- 0


data <- convertYearMon(readexcel())

dpfcttf <- caldailyspline(data, 2016)

diffdpfc <- dpfcttf-mean(dpfcttf)

A <- matrix(0, nrow=nrow(diffdpfc)+1, ncol=nrow(diffdpfc))
A[1,] <- 1
for(i in 1:nrow(diffdpfc)) A[i+1,i] <- 1

A2 <- matrix(0, nrow=nrow(diffdpfc)+1, ncol=nrow(diffdpfc))
A2[1,] <- 1
for(i in 1:nrow(diffdpfc)) A2[i+1,i] <- 1

a <- as.numeric(diffdpfc)
b <- ACQMin + 1
b[2:(nrow(diffdpfc)+1)] <- DCQMax
b2 <- ACQMin
b2[2:(nrow(diffdpfc)+1)] <- DCQMin
e <- simplex(a=a, A1=A, b1=b, A2=A2, b2=b2, maxi=TRUE)
optimised <- as.numeric(e$soln)
offtake <- cbind(diffdpfc,optimised)
names(offtake) <- c("Spread", "Schedule")
offtake$PNL <- offtake$Spread * offtake$Schedule

optimised <- xts(optimised, seq.Date(from=as.Date('2016-01-01'), by=1, length.out=nrow(diffdpfc)))
