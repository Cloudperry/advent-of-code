import ../lib

var cols, rows: int
proc parseBitArray2D(input: string): BitArray2D =
  var lines = input.splitLines()
  lines.del(lines.find(""))
  (cols, rows) = (lines[0].len, lines.len)
  result = newBitArray2d(cols, rows)
  for row, line in lines:
    for col, bit in line:
      result[col, row] = parseBool($bit)

let input = getInputWithParser(3, 2021, parseBitArray2D)

var trueBitsAtPos = newSeq[int](cols)
for col in 0 .. cols - 1:
  for row in 0 .. rows - 1:
    trueBitsAtPos[col] += ord(input[col, row])

var validOxygenRatingLines = (0 .. rows - 1).toSeq.toHashSet
var validCo2RatingLines = validOxygenRatingLines
for col in 0 .. cols - 1:
  let keepOxygenBit = trueBitsAtPos[col] >= rows div 2
  let keepCo2Bit = trueBitsAtPos[col] <= rows div 2
  for row in 0 .. rows - 1:
    if validOxygenRatingLines.len > 1 and input[col, row] != keepOxygenBit:
      validOxygenRatingLines.excl row
    if validCo2RatingLines.len > 1 and input[col, row] != keepCo2Bit:
      validCo2RatingLines.excl row

let inputString = getInputLines(3, 2021) #Bitty is pretty bad for these kinds of tasks, maybe improve it or rewrite this solution by using strings?
echo parseBinInt(inputString[validOxygenRatingLines.pop]) * parseBinInt(inputString[validCo2RatingLines.pop])
