function CND(X)

  y = abs(X)

  if y > 37
    cum = 0
  else
    Exponential = exp(-y^2/2)

    if y < 7.07106781186547
      SumA = 0.0352624965998911 * y + 0.700383064443688
      SumA = SumA * y + 6.37396220353165
      SumA = SumA * y + 33.912866078383
      SumA = SumA * y + 112.079291497871
      SumA = SumA * y + 221.213596169931
      SumA = SumA * y + 220.206867912376
      SumB = 0.0883883476483184 * y + 1.75566716318264
      SumB = SumB * y + 16.064177579207
      SumB = SumB * y + 86.7807322029461
      SumB = SumB * y + 296.564248779674
      SumB = SumB * y + 637.333633378831
      SumB = SumB * y + 793.826512519948
      SumB = SumB * y + 440.413735824752
      cum = Exponential * SumA / SumB
    else
      SumA = y + 0.65
      SumA = y + 4 / SumA
      SumA = y + 3 / SumA
      SumA = y + 2 / SumA
      SumA = y + 1 / SumA
      cum = Exponential / (SumA * 2.506628274631)

      end
  end

  if X > 0
    cum = 1 - cum
  else
          cum
  end


end
