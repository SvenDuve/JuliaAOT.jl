con = createConn()


t = floor((now() - Dates.Month(6)), Dates.Day(1))

while t < Date("2018-03-09")

    #time now in my time zone

    startDate = floor((t - Dates.Day(14)), Dates.Minute(30))

    # Instrumen deklaration
    inst = instrument("RXH8 Comdty", "TRADE", startDate, t)

    #request data
    bundDaten = sort(BarFrame(con, inst, 30), cols = [:Volume])[(end-19):end,:]




    # Create File name
    path = "C:\\Users\\sduve\\JuliaPrPack\\bbgTS\\src\\"
    filename = string(path, "Bund", Date(t),".csv")

    # export File
    CSV.write(filename, bundDaten)

    t = DateTime(t) + Dates.Day(1)

end
