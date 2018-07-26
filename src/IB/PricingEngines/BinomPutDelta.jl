function BinomPutDelta(K, T, S, sig, r, N)

  PutArray, AssetArray = (GenAmericanBinomialPut(K, T, S, sig, r, N))

  delta = (PutArray[1,2] - PutArray[2,2])/(AssetArray[1,2]-AssetArray[2,2])
  delta

end
