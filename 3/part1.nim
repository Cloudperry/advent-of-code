import ../lib
import bitty, os

proc parseBitArray(input: string): BitArray =
  result = newBitArray()
  for i, bit in input:
    result.add parseBool($bit)

let inputFile =
  if paramCount() == 1:
    paramStr(1)
  else:
    ""
let input = getInputWithParser(3, 2021, parseBitArray2D, inputFile)
let input = getInputLinesWithParser(3, 2021, parseBitArray)

var trueBitsAtPos = newSeq[int](input[0].len)
for bitArray in input:
  for i, bit in bitArray:
    trueBitsAtPos[i] += ord(bit)

var gammaRate = newBitArray(input[0].len)
for i in 0 .. trueBitsAtPos.high:
  gammaRate[i] = trueBitsAtPos[i] > input.len div 2
var epsilonRate = not gammaRate

echo parseBinInt($gammaRate) * parseBinInt($epsilonRate)
