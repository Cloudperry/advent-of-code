import ../lib
import bitty
import os

var cols, rows: int
proc parseBitArray2D(input: string): BitArray2D =
  var lines = input.splitLines()
  (cols, rows) = (lines[0].len, lines.len)
  result = newBitArray2d(cols, rows)
  for row, line in lines:
    for col, bit in line:
      result[col, row] = parseBool($bit)

let inputFile =
  if paramCount() == 1:
    paramStr(1)
  else:
    ""

let input = getInputWithParser(3, 2021, parseBitArray2D, inputFile)
let inputString = getInputLines(3, 2021, inputFile) #Bitty is pretty bad for these kinds of tasks, maybe improve it or rewrite this solution by using strings?

#Broken solution with a bunch of debug code
#I will fix it soon
proc countTrueBits(col: int; countedRows: seq[int]): int =
  for row in 0 .. rows - 1:
    if row notin countedRows: continue
    result += ord(input[col, row])

var validOxygenRatingRows = (0 .. rows - 1).toSeq
var validCo2RatingRows = validOxygenRatingRows
var co2Row, oxyRow: int
for col in 0 .. cols - 1:
  echo "oxy"
  for row in validOxygenRatingRows.toSeq: echo inputString[row]
  echo "co2"
  for row in validCo2RatingRows.toSeq: echo inputString[row]
  let oxygenTrueBitsInCol = countTrueBits(col, validOxygenRatingRows)
  echo fmt"col {col} oxygen {oxygenTrueBitsInCol}/{validOxygenRatingRows.len}"
  let keepOxygenBit = oxygenTrueBitsInCol >= validOxygenRatingRows.len - oxygenTrueBitsInCol
  let co2TrueBitsInCol = countTrueBits(col, validCo2RatingRows)
  echo fmt"col {col} co2 {co2TrueBitsInCol}/{validCo2RatingRows.len}"
  let keepCo2Bit = co2TrueBitsInCol < validCo2RatingRows.len  - co2TrueBitsInCol
  echo fmt"keeping oxygen bits {keepOxygenBit} and co2 bits {keepCo2Bit} at {col}"
  while oxyRow in 0 .. validOxygenRatingRows.high:
    let row = validOxygenRatingRows[oxyRow]
    if validOxygenRatingRows.len > 1 and input[col, row] != keepOxygenBit:
      validOxygenRatingRows.del(oxyRow)
    oxyRow.inc;
  while co2Row in 0 .. validCo2RatingRows.high:
    let row = validCo2RatingRows[co2Row]
    if validCo2RatingRows.len > 1 and input[col, row] != keepCo2Bit:
      validCo2RatingRows.del(co2Row)
    co2Row.inc
  (oxyRow, co2Row) = (0, 0)

echo fmt"{inputString[validOxygenRatingRows.pop]}, {inputString[validCo2RatingRows.pop]}"
