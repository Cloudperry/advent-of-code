import ../lib

proc parseBitArray(input: string): BitArray =
  result = newBitArray()
  for i, bit in input:
    result.add parseBool($bit)

let input = getInputLinesWithParser(3, parseBitArray)

var trueBitsAtPos = newSeq[int](input[0].len)
for bitArray in input:
  for i, bit in bitArray:
    if bit:
      trueBitsAtPos[i] += 1

var gammaRate = newBitArray(input[0].len)
for i in 0 .. trueBitsAtPos.high:
  gammaRate[i] = trueBitsAtPos[i] > input.len div 2
var epsilonRate = not gammaRate

echo parseBinInt($gammaRate) * parseBinInt($epsilonRate)
