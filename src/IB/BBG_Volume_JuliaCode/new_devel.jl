
using Blpapi
using CSV

# Verbindungsaufbau
con = createConn()


t = floor((now() - Dates.Month(0)), Dates.Day(1))
startDate = floor((t - Dates.Day(1)), Dates.Minute(30))

    # Instrumen deklaration
inst = instrument("RXU8 Comdty", "TRADE", startDate, t)

    #request data
BarFrame(con, inst, 30)








z = bundDaten[[:Dates, :Volume]]

sort(z, cols = [:Volume])[(end-19):end,:]





















i
TS(con, inst)

bdh(connection.session, "IBM US Equity", "TRADE", startDate, t)



bdh(connection.session, ["IBM US Equity"], ["PX_LAST"], "20180101", "20180331")
bdh(connection.session, [inst.ticker], "PX_Last", "20180101", "20180331")


barsize = 30

# Pulling all from BBG
Response = bar(connection.session, inst.ticker, inst.fields, string(inst.startDate), string(inst.endDate); interval=barsize)


#sorting into DataFrame

df = DataFrame()
df[:Dates] = Response.datetimes
df[:Open] = zeros(length(Response.datetimes))
df[:High] = zeros(length(Response.datetimes))
df[:Low] = zeros(length(Response.datetimes))
df[:Close] = zeros(length(Response.datetimes))
df[:Volume] = zeros(length(Response.datetimes))


for i in 1:length(Response.datetimes)
df[i,:Open] = Response[Response.datetimes[i]].openVar
df[i,:High] = Response[Response.datetimes[i]].highVar
df[i,:Low] = Response[Response.datetimes[i]].lowVar
df[i,:Close] = Response[Response.datetimes[i]].closeVar
df[i,:Volume] = Response[Response.datetimes[i]].volumeVar
end

using TimeZones

df



d = df[:,1]

zd = ZonedDateTime.(d, tz"UTC")

finalDT = astimezone.(zd, tz"Europe/Zurich")

df[:,1] = finalDT

df

Date(finalDT[1], dateformat"y-m-d")







con = createConn()
"PX_High", "PX_Low", "PX_Last"
# For historical end of day, mind the date format
inst = instrument("RXU8 Comdty", ["PX_Open", "PX_High", "PX_Low", "PX_Last"], "20180501", "20180625")



#function TS(con = connection, inst = ibm)

#endData = Array()

for i in (1:length(inst.fields))

    response = bdh(con.session, [inst.ticker], [inst.fields[i]], inst.startDate, inst.endDate; periodicitySelection = "DAILY")
    data = response[inst.ticker, inst.fields[i]]

    dformat = Dates.DateFormat("y-m-d")
    dates = similar(data[:,1], Date)
    prices = similar(data[:,2], Float64)

    for j in (1:length(data[:,1]))

        dates[j] = Date(data[j,1], dformat)
        prices[j] = data[j,2]

    end

    k = sortperm(dates)
    dates = dates[k]
    prices = prices[k]

    #if i > 1
    #    data2 = similar(data)

    data = TimeArray(dates, prices, [inst.fields[i]])

    # if i == 1
    #     dataFinal = similar(1:length(data), Float64)
    #     dataFinal = data
    # end
    #
    # if i > 1
    #     dataFinal = merge(dataFinal, data)
    # end
    #

end









connection = createConn()
bund = instrument("RXU8 Comdty", ["PX_Open", "PX_High", "PX_Low", "PX_Last"], "20180601", "20180627")


function TS(con = connection, inst = ibm, field = "PX_Last")

  response = bdh(con.session, [inst.ticker], [field], inst.startDate, inst.endDate; periodicitySelection = "DAILY")
  data = response[inst.ticker, field]

  dformat = Dates.DateFormat("y-m-d")
  dates = similar(data[:,1], Date)
  prices = similar(data[:,2], Float64)

  for i in (1:length(data[:,1]))
    dates[i] = Date(data[i,1], dformat)
    prices[i] = data[i,2]
  end

  k = sortperm(dates)
  dates = dates[k]
  prices = prices[k]

  data = TimeArray(dates, prices, [field])

end



TS(connection, bund, bund.fields[1])





data = TS(connection, bund)


colnames(data)

Dates.firstdayofweek(Date(now()-Dates.Day(5))) + Dates.Day(1)
Dates.firstdayofweek(Date(now()-Dates.Day(5)))







data[Dates.firstdayofweek(Date(now()-Dates.Day(5)))]
data[Dates.firstdayofweek(Date(now()-Dates.Day(5))) + Dates.Day(1)]

data.timestamp


















#end
for

    #refresh end time to now

    #call BarFrame

    #write result to csv./ or call this function from excel







function barUpdate(contract, con = con)

    t = now()
    startDate = t - Dates.Month(2)

    inst = instrument(contract.ticker, contract.fieldnames, startDate, t)

    BarFrame(con, inst, 30)


end



quantile(barUpdate()[(end-300):end,:Volume],0.95)
log(bund2[:High]./bund2[:Low]) ./ log(bund2[:Close])

(bund2[end,:High] - bund2[end,:Low]) / maximum(bund2[:High] - bund2[:Low])


for i in keys(instContracts)
       contract = instContracts[i]
       barUpdate(contract)
end


function volIndicatorXL(commodity, days_back)

    inst = bbgTS.contracts[commodity]
    inst.startDate = now() - Dates.Month(2)
    inst.endDate = now()
    df = BarFrame(bbgTS.conInternal, inst, bbgTS.n)
    df = Array{Any}(df[Date(df[:,:Dates]) .== Date(now())-Dates.Day(days_back), [:Dates, :Volume, :RotFact]])
    df[:,1] = toXLDate.(df[:,1])
    return df

end
