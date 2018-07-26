using Base.Dates

today = today()

Aug16 = Dates.days(Date(2016, 7, 27)-today)/365
Sep16 = Dates.days(Date(2016, 8, 26)-today)/365
Oct16 = Dates.days(Date(2016, 9, 26)-today)/365
Nov16 = Dates.days(Date(2016, 10, 27)-today)/365
Dec16 = Dates.days(Date(2016, 11, 25)-today)/365
Jan17 = Dates.days(Date(2016, 12, 23)-today)/365
Feb17 = Dates.days(Date(2017, 1, 27)-today)/365
Mar17 = Dates.days(Date(2017, 2, 24)-today)/365
Apr17 = Dates.days(Date(2017, 3, 27)-today)/365
May17 = Dates.days(Date(2017, 4, 26)-today)/365
Jun17 = Dates.days(Date(2017, 5, 26)-today)/365
Jul17 = Dates.days(Date(2017, 6, 26)-today)/365
Aug17 = Dates.days(Date(2017, 7, 27)-today)/365
Sep17 = Dates.days(Date(2017, 8, 25)-today)/365
Oct17 = Dates.days(Date(2017, 9, 26)-today)/365
Nov17 = Dates.days(Date(2017, 10, 27)-today)/365
Dec17 = Dates.days(Date(2017, 11, 24)-today)/365
Jan18 = Dates.days(Date(2017, 12, 27)-today)/365
Feb18 = Dates.days(Date(2018, 1, 26)-today)/365
Mar18 = Dates.days(Date(2018, 2, 23)-today)/365
Apr18 = Dates.days(Date(2018, 3, 27)-today)/365
May18 = Dates.days(Date(2018, 4, 26)-today)/365
Jun18 = Dates.days(Date(2018, 5, 25)-today)/365
Jul18 = Dates.days(Date(2018, 6, 26)-today)/365
Aug18 = Dates.days(Date(2018, 7, 27)-today)/365
Sep18 = Dates.days(Date(2018, 8, 27)-today)/365
Oct18 = Dates.days(Date(2018, 9, 26)-today)/365
Nov18 = Dates.days(Date(2018, 10, 26)-today)/365
Dec18 = Dates.days(Date(2018, 11, 26)-today)/365



Q416 = [Oct16, Nov16, Dec16]
Q117 = [Jan17, Feb17, Mar17]
Q217 = [Apr17, May17, Jun17]
Q317 = [Jul17, Aug17, Sep17]
Q417 = [Oct17, Nov17, Dec17]
Q118 = [Jan18, Feb18, Mar18]
Q218 = [Apr18, May18, Jun18]
Q318 = [Jul18, Aug18, Sep18]
Q418 = [Oct18, Nov18, Dec18]

W16 = [Q416, Q117]
S17 = [Q217, Q317]
W17 = [Q417, Q118]
S18 = [Q218, Q318]


# Date(2017,12) - Dates.Day(7)
# Dates.dayofweek(Date(2017,10) - Dates.Day(5))
# Date(2017,7)
#
# Dates.days(Date(2016,7) - Dates.Day(5)
#
# if (Dates.dayofweek(Date(2016,7) - Dates.Day(5)) == 7)
