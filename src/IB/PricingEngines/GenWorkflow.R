require(xts)
require(fExoticOptions)
require(quantmod)
require(RQuantLib)
require(lubridate)
require(boot)

dailyspline <- function(anchorDate = 20160615, endDate = 20220915, from = 201610, to = 201609){
  
  
  x <- readCurve()
  
  ad <- ymd(anchorDate)
  
  marketDates <- c(ad, ad + months(seq(1,nrow(x)-1,1)))
  
  marketDates <- as.Date(substring(marketDates, 1, 10))
  
  index(x) <- marketDates
  
  dates <- timeBasedSeq(paste(anchorDate, "/", endDate, "/", "d", sep = ""))
  
  days <- xts(rep(NA, length(dates)), dates)
  
  dpfc <- merge(days, x)
  
  dpfc <- na.spline(dpfc$Price)
  
  
  suppressWarnings(dpfc[paste(from, '/', to, sep = "")])
  
  
}



intraMonthDailySpline <- function(DA = 10,
                                  SndPrice = 11,
                                  ThrdPrice = 12,
                                  anchorDate = 20160109,
                                  SndDate = 20160115,
                                  ThrdDate = 20160120,
                                  endDate = 20160131){
  
  
  
  
  x <- c(DA, SndPrice, ThrdPrice)
  
  marketDates <- c(ymd(anchorDate), ymd(SndDate), ymd(ThrdDate))
  
  marketDates <- as.Date(substring(marketDates, 1, 10))
  
  x <- xts(x, marketDates)
  
  dates <- timeBasedSeq(paste(anchorDate, "/", endDate, "/", "d", sep = ""))
  
  days <- xts(rep(NA, length(dates)), dates)
  
  dpfc <- merge(days, x)
  
  dpfc <- na.spline(dpfc$x)
  
  dpfc
  
  
}
Voldailyspline <- function(anchorDate = 20160115, endDate = 20180115, from = 201601, to = 201612, x = ATMVol){
  
  
  x <- x
  
  ad <- ymd(anchorDate)
  
  marketDates <- c(ad, ad + months(seq(1,nrow(x)-1,1)))
  
  marketDates <- as.Date(substring(marketDates, 1, 10))
  
  index(x) <- marketDates
  
  dates <- timeBasedSeq(paste(anchorDate, "/", endDate, "/", "d", sep = ""))
  
  days <- xts(rep(NA, length(dates)), dates)
  
  dpfc <- merge(days, x)
  
  dpfc <- na.spline(dpfc$Vol)
  
  
  suppressWarnings(dpfc[paste(from, '/', to, sep = "")])
  
  
}

dLocalizer <- function(market = "TTF", typeflag="c", FT=18, X=18, t=W16, r=-0.0024, sig=0.2345, rowLocation=1){
  
  if(market=="NBP"){
    deltasSplined <- NBPVolSurface
  }else if(market=="TTF"){
    deltasSplined <- TTFVolSurface
  }else if(market=="NCG"){
    deltasSplined <- NCGVolSurface
  }
  
  
  if(typeflag=="c"){
    
    deltalocation <- 100 - round(abs(GBSGreeks("delta", typeflag, FT, X, t, r, b=0, sig)), 2)*100
  }else{
    deltalocation <- round(abs(GBSGreeks("delta", typeflag, FT, X, t, r, b=0, sig)), 2)*100
  }
  
  
  volsSheet <- rep(0,length(t))
  #print(deltalocation)
  
  
  for(i in 1:length(t)){
    
    volsSheet[i] <- deltasSplined[rowLocation+i, deltalocation[i]]
    
  }
  
  volsSheet
  
}

SplineDelta <- function(market="TTF"){
  
  if(market=="NBP"){
    
    volSurface <- read.csv("~/OptionsPriceSeriesCSV.csv", sep=";", nrows = 24)[,1:15]
    
  }else if(market=="TTF"){
    
    volSurface <- read.csv("~/OptionsPriceSeriesCSV.csv", sep=";", nrows = 24, skip=27)[,1:15]
    
  }else if(market=="NCG"){
    
    volSurface <- read.csv("~/OptionsPriceSeriesCSV.csv", sep=";", nrows = 24, skip=53)[,1:15]
    
  }else{
    print("Market unknown")
  }
  
  dPC <- 1:99   	
  
  deltasSplined <- matrix(nrow=nrow(volSurface), ncol = 99)	
  
  
  for (i in 1:nrow(volSurface))
  {
    
    deltasSplined[i,] <- spline(1:length(as.numeric(volSurface[i, 5:15])), as.numeric(volSurface[i, 5:15]), n=99)$y
    
  }
  
  deltasSplined    	
  
}

caldailyspline <- function(x, year=2016){
  
  if(year==2016){
    curve <- x
    curve <- curve['2013-01/2022-10']
    
    
    
    
    
    
    janstart <- 0.5 * (as.numeric(curve['2015-12']) + as.numeric(curve['2016-01']))
    febstart <- 0.5 * (as.numeric(curve['2016-01']) + as.numeric(curve['2016-02']))
    marstart <- 0.5 * (as.numeric(curve['2016-02']) + as.numeric(curve['2016-03']))
    aprstart <- 0.5 * (as.numeric(curve['2016-03']) + as.numeric(curve['2016-04']))
    maystart <- 0.5 * (as.numeric(curve['2016-04']) + as.numeric(curve['2016-05']))
    junstart <- 0.5 * (as.numeric(curve['2016-05']) + as.numeric(curve['2016-06']))
    julstart <- 0.5 * (as.numeric(curve['2016-06']) + as.numeric(curve['2016-07']))
    augstart <- 0.5 * (as.numeric(curve['2016-07']) + as.numeric(curve['2016-08']))
    sepstart <- 0.5 * (as.numeric(curve['2016-08']) + as.numeric(curve['2016-09']))
    octstart <- 0.5 * (as.numeric(curve['2016-09']) + as.numeric(curve['2016-10']))
    novstart <- 0.5 * (as.numeric(curve['2016-10']) + as.numeric(curve['2016-11']))
    decstart <- 0.5 * (as.numeric(curve['2016-11']) + as.numeric(curve['2016-12']))
    decend <- 0.5 * (as.numeric(curve['2016-12']) + as.numeric(curve['2017-01']))
    
    
    
    
    mprices <- c(janstart, as.numeric(curve['2016-01']),
                 febstart, as.numeric(curve['2016-02']),
                 marstart, as.numeric(curve['2016-03']),
                 aprstart, as.numeric(curve['2016-04']),
                 maystart, as.numeric(curve['2016-05']),
                 junstart, as.numeric(curve['2016-06']),
                 julstart, as.numeric(curve['2016-07']),
                 augstart, as.numeric(curve['2016-08']),
                 sepstart, as.numeric(curve['2016-09']),
                 octstart, as.numeric(curve['2016-10']),
                 novstart, as.numeric(curve['2016-11']),
                 decstart, as.numeric(curve['2016-12']),
                 decend)
    
    nodes <- c(1, 15, 32, 47, 62, 77, 93, 108, 124, 138, 152, 167, 183, 198, 213, 228, 244, 259, 274, 289, 305, 320, 336, 351, 366)
    spline <- spline(nodes, mprices, n=366)
    seq <- timeBasedSeq('20160101/20161231')
    
    dpfc <- xts(spline$y, seq.Date(from=as.Date('2016-01-01'), by=1, length.out=366))
    names(dpfc) <- "dPrice"
    dpfc
  }
  else
  {
    
    curve <- x
    curve <- curve['2013-01/2022-10']
    
    
    janstart <- 0.5 * (as.numeric(curve['2016-12']) + as.numeric(curve['2017-01']))
    febstart <- 0.5 * (as.numeric(curve['2017-01']) + as.numeric(curve['2017-02']))
    marstart <- 0.5 * (as.numeric(curve['2017-02']) + as.numeric(curve['2017-03']))
    aprstart <- 0.5 * (as.numeric(curve['2017-03']) + as.numeric(curve['2017-04']))
    maystart <- 0.5 * (as.numeric(curve['2017-04']) + as.numeric(curve['2017-05']))
    junstart <- 0.5 * (as.numeric(curve['2017-05']) + as.numeric(curve['2017-06']))
    julstart <- 0.5 * (as.numeric(curve['2017-06']) + as.numeric(curve['2017-07']))
    augstart <- 0.5 * (as.numeric(curve['2017-07']) + as.numeric(curve['2017-08']))
    sepstart <- 0.5 * (as.numeric(curve['2017-08']) + as.numeric(curve['2017-09']))
    octstart <- 0.5 * (as.numeric(curve['2017-09']) + as.numeric(curve['2017-10']))
    novstart <- 0.5 * (as.numeric(curve['2017-10']) + as.numeric(curve['2017-11']))
    decstart <- 0.5 * (as.numeric(curve['2017-11']) + as.numeric(curve['2017-12']))
    decend <- 0.5 * (as.numeric(curve['2017-12']) + as.numeric(curve['2018-01']))
    
    
    
    
    mprices <- c(janstart, as.numeric(curve['2017-01']),
                 febstart, as.numeric(curve['2017-02']),
                 marstart, as.numeric(curve['2017-03']),
                 aprstart, as.numeric(curve['2017-04']),
                 maystart, as.numeric(curve['2017-05']),
                 junstart, as.numeric(curve['2017-06']),
                 julstart, as.numeric(curve['2017-07']),
                 augstart, as.numeric(curve['2017-08']),
                 sepstart, as.numeric(curve['2017-09']),
                 octstart, as.numeric(curve['2017-10']),
                 novstart, as.numeric(curve['2017-11']),
                 decstart, as.numeric(curve['2017-12']),
                 decend)
    
    nodes <- c(1, 15, 32, 47, 62, 77, 93, 108, 124, 138, 152, 167, 183, 198, 213, 228, 244, 259, 274, 289, 305, 320, 336, 351, 365)
    spline <- spline(nodes, mprices, n=365)
    seq <- timeBasedSeq('20170101/20171231')
    
    dpfc <- xts(spline$y, seq.Date(from=as.Date('2017-01-01'), by=1, length.out=365))
    names(dpfc) <- "dPrice"
    dpfc
    
    
    
  }
  
}




copytoexcel <- function(x){
  
  write.table(x,"clipboard", sep="\t", col.names=NA)
  
}



readexcel <- function(x="clipboard"){
  
  read.delim("clipboard")
}



readCurve <- function(){
  
  x <- xts(read.csv("GasCurve.csv")[,2],
           as.yearmon(as.Date(read.csv("GasCurveTTF.csv")[,1], "%m/%d/%Y")))
  
  names(x) <- "Price"
  x
  
}


convertYearMon <- function(x){
  
  xts(x[,2], as.yearmon(as.Date(x[,1], "%d/%m/%Y")))
  
}


readPriceSeries <- function(x="clipboard", timeFrame='201602/201701', name="TTF"){
  
  data <- as.xts(read.delim(x), order.by = as.Date(timeBasedSeq(timeFrame)))
  
  names(data) <- name
  
  data
  
}


Params <- function(ACQMax = 1500000, ACQMin = 1200000, HCQMax = 350, HCQMin = 0, Strike = 18){
  
  daysOfftakeMin <- ACQMin / (HCQMax * 24)
  daysOfftakeMax <- ACQMax / (HCQMax * 24)
  daysVolumetric <- daysOfftakeMax - daysOfftakeMin
  
  DCQMax <- HCQMax * 24
  DCQMin <- HCQMin * 24
  list(ACQMax = ACQMax, ACQMin = ACQMin, HCQMax = HCQMax,
       HCQMin = HCQMin, DCQMax = DCQMax, DCQMin = DCQMin,
       DaysMin = daysOfftakeMin, DaysMax = daysOfftakeMax,
       daysVolumetric = daysVolumetric,
       Strike = Strike)
  
}


SpreadOptionMatrix <- function(x, cor = 0.9){
  
  p <- matrix(0, nrow(x), nrow(x))
  
  for(j in 1:nrow(x)){
    
    for(i in j:nrow(x)){
      
      if(as.numeric(spreadData$dPrice[i]) < as.numeric(spreadData$dPrice[j])){
        flag <- "c"
      }else{
        flag <- "p"
      }
      
      p[j,i] <- SpreadApproxOption(TypeFlag = flag,
                                   S1 = as.numeric(spreadData$dPrice[i]),
                                   S2 = as.numeric(spreadData$dPrice[j]),
                                   X = 0,
                                   Time = as.numeric(spreadData$Time[j]),
                                   r = 0,
                                   sigma1 = as.numeric(spreadData$Vol[i]),
                                   sigma2 = as.numeric(spreadData$Vol[j]), rho = cor)@price
      
    }
    
  }
  
  
  for(i in 1:nrow(x)){p[i,i] <- 0}
  
  p
  
}
