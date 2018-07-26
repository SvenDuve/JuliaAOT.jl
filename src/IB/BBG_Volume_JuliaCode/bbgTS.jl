module bbgTS

using DataFrames
using TimeSeries
using Base.Dates
using Blpapi
using Gadfly
using GLM
using JuliaInXL
using Sauhaufen


export connObject
export createConn
export instrument
export TS
export BarFrame
export intrRotFact
export intrRotFactXL

# using JuliaInXL:xldate
# fromDate = DateTime(xldate(xlFromDate))

type connObject

  IP
  Port
  session

end




function createConn(IP = "localhost", Port = 8194)
  try
    session = createSession(IP, Port)
    conn = connObject(IP, Port, session)
  catch e
    e_msg = string(sprint(io->Base.showerror(io,e)), sprint(io->Base.show_backtrace(io,catch_backtrace())))
    println(e_msg)
    return e_msg
  end
end


type instrument

  ticker
  fields
  startDate
  endDate

end


function TS(con = connection, inst = ibm)

  response = bdh(con.session, [inst.ticker], [inst.fields], inst.startDate, inst.endDate; periodicitySelection = "DAILY")
  data = response[inst.ticker, inst.fields]

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

  data = TimeArray(dates, prices, [inst.ticker])

end


function BarFrame(con, inst, barsize)

    Response = bar(con.session, inst.ticker, inst.fields, string(inst.startDate), string(inst.endDate); interval=barsize)

    df = DataFrame()
    df[:Dates] = Response.datetimes
    df[:Open] = zeros(length(Response.datetimes))
    df[:High] = zeros(length(Response.datetimes))
    df[:Low] = zeros(length(Response.datetimes))
    df[:Close] = zeros(length(Response.datetimes))
    df[:Volume] = zeros(length(Response.datetimes))
    df[:RotFact] = zeros(length(Response.datetimes))


    for i in 1:length(Response.datetimes)
    df[i,:Open] = Response[Response.datetimes[i]].openVar
    df[i,:High] = Response[Response.datetimes[i]].highVar
    df[i,:Low] = Response[Response.datetimes[i]].lowVar
    df[i,:Close] = Response[Response.datetimes[i]].closeVar
    df[i,:Volume] = Response[Response.datetimes[i]].volumeVar
    end


    for i in collect(nrow(df):-1:2)
        if df[i,:High] > df[i-1,:High] && df[i,:Low] > df[i-1,:Low]
            df[i,:RotFact] = mean([df[i,:High], df[i,:Low]])*df[i,:Volume]
        elseif df[i,:High] < df[i-1,:High] && df[i,:Low] < df[i-1,:Low]
            df[i,:RotFact] = mean([df[i,:High], df[i,:Low]])*df[i,:Volume]*-1
        else
        df[i,:RotFact] = 0
        end
    end


    return df

end




function intrRotFact(commodity, days_back)

    df = bbgTS.VolAnalytics[commodity]
    df = Array{Any}(df[Date(df[:,:Dates]) .== Date(now())-Day(days_back), [:Dates, :Volume, :RotFact]])
    df[:,1] = toXLDate.(df[:,1])
    return df

end



function intrRotFactXL(commodity, days_back)

    inst = bbgTS.contracts[commodity]
    inst.startDate = now() - Dates.Month(2)
    inst.endDate = now()
    df = BarFrame(bbgTS.conInternal, inst, bbgTS.n)
    df = Array{Any}(df[Date(df[:,:Dates]) .== Date(now())-Dates.Day(days_back), [:Dates, :Volume, :RotFact]])
    df[:,1] = toXLDate.(df[:,1])
    return df

end





t = now()
startDate = t - Dates.Month(2)
conInternal = createConn()
n = 30

VolAnalytics = Dict([("Gas", BarFrame(conInternal, instrument("FNA Comdty", "TRADE", startDate, t), n)),
                ("Brent", BarFrame(conInternal, instrument("COA Comdty", "TRADE", startDate, t), n)),
                ("Bund", BarFrame(conInternal, instrument("RXA Comdty", "TRADE", startDate, t), n))])

contracts = Dict([("Gas", instrument("FNA Comdty", "TRADE", startDate, t)),
                    ("Brent", instrument("COA Comdty", "TRADE", startDate, t)),
                    ("Bund", instrument("RXA Comdty", "TRADE", startDate, t))])




end
