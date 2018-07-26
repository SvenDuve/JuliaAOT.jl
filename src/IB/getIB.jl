

using RCall
## run library in R
@rlibrary IBrokers
## run TimeSeries
using TimeSeries
using DataFrames


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




function getIB2(symbol, endDateTime, exch, expiry, currency, barSize, duration)


    #RCall for IBrokers
    R"""
    contract <- twsFuture(symbol = $symbol, exch = $exch , expiry = $expiry, currency = $currency)
    data <- reqHistoricalData(tws, contract, endDateTime = $endDateTime, barSize = $barSize, duration = $duration)['T08:00/T18:00']
    """

    #jData DataFrame, with timestamps first
    jData = DataFrame(TimeStamp = rcopy(R"index(as.xts(data))"))

    #colnames for Julia DataFrame
    cNames = ["Open", "High", "Low", "Close", "Volume", "WAP", "hasGaps", "Count"]


    for i in 1:length(cNames)

        # iterate through the return array of R and combine with initial DataFrame
        jData[Symbol(cNames[i])] = rcopy(R"data")[:,i]

    end

    return jData

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
