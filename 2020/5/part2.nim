import algorithm
import ../common

let input = getInput()

var seatIDs: seq[int]
for line in input:
  var (rowPartSize, colPartSize) = (64, 4)
  var currentSeatRowBounds = 0 .. 127
  var currentSeatColBounds = 0 .. 8
  for char in line:
    if char == 'F':
      currentSeatRowBounds.b -= rowPartSize
      rowPartSize = rowPartSize div 2
    elif char == 'B':
      currentSeatRowBounds.a += rowPartSize
      rowPartSize = rowPartSize div 2
    elif char == 'L':
      currentSeatColBounds.b -= colPartSize
      colPartSize = colPartSize div 2
    elif char == 'R':
      currentSeatColBounds.a += colPartSize
      colPartSize = colPartSize div 2
  seatIDs.add(currentSeatRowBounds.a * 8 + currentSeatColBounds.a)

let sortedSeatIDs = seatIDs.sorted()
var prevSeatID: int
for seatID in sortedSeatIDs:
  if seatID > prevSeatID + 1 and prevSeatID != 0:
    echo prevSeatID + 1
  prevSeatID = seatID
