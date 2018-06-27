

using RCall
## run library in R
@rlibrary IBrokers
## run TimeSeries
using TimeSeries


symbol = "GBL"
exch = "DTB"
expiry = "201809"
currency = "EUR"
duration = "1 M"
barSize = "30 mins"


function getConnectIB()

    R"""
    library(IBrokers)
    tws <- twsConnect()
    """

end




function getIB(symbol, exch, expiry, currency, barSize, duration)

    R"""
    contract <- twsFuture(symbol = $symbol, exch = $exch , expiry = $expiry, currency = $currency)
    data <- reqHistoricalData(tws, contract, barSize = $barSize, duration = $duration)['T08:00/T18:00']
    """

    data = TimeArray(rcopy(R"index(as.xts(data))"), rcopy(R"data"))
    data.colnames[:] = ["Open", "High", "Low", "Close", "Volume", "WAP", "hasGaps", "Count"]


    return data


end



function getDailyIB(symbol, exch, expiry, currency, barSize, duration)

    R"""
    contract <- twsFuture(symbol = $symbol, exch = $exch , expiry = $expiry, currency = $currency)
    data <- reqHistoricalData(tws, contract, barSize = $barSize, duration = $duration)
    """

    data = TimeArray(Date.(rcopy(R"index(as.xts(data))")), rcopy(R"data"))
    data.colnames[:] = ["Open", "High", "Low", "Close", "Volume", "WAP", "hasGaps", "Count"]


    return data


end




# #establish R connectin to IB, chech this by R>tws1
#
# rcopy(R"index(as.xts(data))")
# rcopy(data)
#
#
# rcopy(as.data.frame(data))
#
# dates = @rget df
#
#
# data = rcopy(data)
#
# rcopy(df)
#
# BarTimes = (@rget df)
#
# DateTime(BarTimes, "yyyy-mm-dd HH:MM:SS")
