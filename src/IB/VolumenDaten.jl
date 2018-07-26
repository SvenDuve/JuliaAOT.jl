
quantile(daten["Volume"].values, 0.9)
mean(daten["Volume"].values)



tpers = (daten["Volume"].values/60) / (quantile(daten["Volume"].values, 0.99)/60)
tvsmax = (daten["Volume"].values/60) / (maximum(daten["Volume"].values)/60)

plot(1:length(tpers), tpers)
plot(1:length(tpers), tvsmax)


histogram(tpers)
histogram(daten["Volume"].values)




# To try/ to do
# find a way to first sort the volume and then get the array index of the top 20/ 4 volumes
# try to rename the x axis with strings of the timestamps,
# try and redude the background grid so that you can navigate through the graph

# working like this perhaps avoids writing it to a CSV file.


symbol = "GBL"
exch = "DTB"
expiry = "201809"
currency = "EUR"
duration = "14 D"
barSize = "30 mins"


getConnectIB()

#can also do this, perhaps right a funciton with default end TimeArray, which then is the real getIB

endTime = "20180724 18:00:00"

datenSatz = getIB2(symbol, "20180725 18:00:00", exch, expiry, currency, barSize, duration)




using Plots
pyplot()


plot(datenSatz[:TimeStamp], datenSatz[:Close])
plot!(datenSatz[:TimeStamp][5:10], datenSatz[:Open][5:10])



names(datenSatz)




quantile(daten2["Volume"].values, 0.9)
mean(daten2["Volume"].values)



tpers = (daten2["Volume"].values[(end-299:end)]) / (quantile(daten2["Volume"].values, 0.95))
tvsmax = (daten2["Volume"].values) / (maximum(daten2["Volume"].values))

plot(1:length(tpers), tpers)
plot(1:length(tpers), tvsmax)


histogram(tpers)
histogram(daten2["Volume"].values)


daten2["Volume"].values[end]
daten2.timestamp[end]

#convert to number

trialTime = DateTime(2018, 6, 22, 15, 57, 20)

#length of regular time interval
#convert(Float64, (DateTime(now()) - daten2.timestamp[end]))

mscPerBar = 5 * 60 * 1000
timeToGoInBar = (5 * 60 * 1000) - convert(Float64, (daten2.timestamp[end] - trialTime)) # potentially either reduce "end" or different difference

#extrapolation factor
extrPolFactor = 1 - timeToGoInBar / mscPerBar


#now extrapolate current volume as if it would grow in the same rate,
#if this is then bigger then the quantile, it should raise a red flag

(daten2["Volume"].values[end] / extrPolFactor) / (quantile(daten2["Volume"].values, 0.95))


writetimearray(daten2, "bund.csv")

neu = readtimearray("bund.csv")



symbol = "GBL"
exch = "DTB"
expiry = "201809"
currency = "EUR"
duration = "1 M"
barSize = "1 day"



data2 = getDailyIB(symbol, exch, expiry, currency, barSize, duration)



Dates.firstdayofweek(Date(now()-Dates.Day(5))) + Dates.Day(1)
Dates.firstdayofweek(Date(now()-Dates.Day(5)))
Dates.firstdayofweek(Date(now()))
