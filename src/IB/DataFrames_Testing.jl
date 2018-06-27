dv = @data([NA, 3, 2, 5, 4])

dv

mean(dv)

dropna(dv)

mean(dropna(dv))

convert(Array, dv) #fails...

convert(Array, dropna(dv)) # works fine...

# or overwrite the NA value like:

dv[1] = 3

#then

convert(Array, dv) # also works

# replaciung and converting in one go:

dv = @data([NA, 3, 2, 5, 4])

mean(convert(Array, dv, 11))


# similar for n-dinemsianal arrays...

dm = @data([NA 0.0; 0.0 1.0])
dm * dm


## The Data frame type

df = DataFrame(A = 1:4, B = ["M", "F", "F", "M"]) ## how to build a data frame
df

# can also be done in stages

df = DataFrame()
df[:A] = 1:8
df[:B] = ["M", "F", "F", "F", "M", "M", "F", "M"]

df

# check size

nrows = size(df, 1)
ncols = size(df,2)

head(df)

df[1:3, :B]

# getting a summary

describe(df)

# access columns via this
mean(df[1])
median(df[1])

# or via names

mean(df[:A])
median(df[:A])


# columnwise functions:

df = DataFrame(A = 1:4, B = randn(4))
colwise(cumsum, df) # for all columns

cumsum(df[:A]) # here just the one column returns just one vector



## more complex things

using RDatasets
using Requests
url = "http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"

# read without error checking

df = readtable(Requests.get_streaming(url))

# and with error checking

r = Requests.get_streaming(url; timeout = 30.0)

if r.response.status / 100 != 2
        error("Error Downloading Data")
end
df = readtable(r)


df = DataFrame(A = 1:10)


writetable("output.csv", df)



a = DataFrame(ID = [1, 2], Name = ["A", "B"])
b = DataFrame(ID = [1, 3], Job = ["Doctor", "Lawywer"])

iris = df

by(iris, :Species, size)


#time stuff

now()
Date(2018, 6, 18)
Date("20180618", DateFormat("yyyymmdd"))
Date("2018-06-18", DateFormat("y-m-d"))


t = Date(now())
t2 = Date(now() - Dates.Day(7))

Dates.firstdayofweek(Date(now() - Dates.Day(1)))

ceil(DateTime(now()), Dates.Minute(30))

Dates.dayname(t2)



dr = Dates.Date(2018):Dates.Date(now())
Dates.dayofweek(dr) .== Dates.Tue

sum(1:10) do x
        2x
end

a = 1:10
filter(a) do x 
        isodd(x)
end


dr = Dates.Date(now() - Dates.Day(12)):Dates.Date(now());

datums = filter(dr) do x 
        ((Dates.dayofweek(x) == Dates.Mon) || (Dates.dayofweek(x) == Dates.Tue)) && (Dates.Week(x) < Dates.Week(now()))
end

Dates.firstdayofweek(Date(now()-Dates.Day(5))) + Dates.Day(1)
Dates.firstdayofweek(Date(now()-Dates.Day(5)))


round(convert(Int,(ceil(DateTime(now()), Dates.Minute(30)) - DateTime(now()))) / 1000)

maxVolume = 50000
timeBlock = 60 * 30

currentVolume = 20000
timeCurrent = 1800 - round(convert(Int,(ceil(DateTime(now()), Dates.Minute(30)) - DateTime(now()))) / 1000)

(currentVolume/timeCurrent) / (maxVolume/timeBlock)



