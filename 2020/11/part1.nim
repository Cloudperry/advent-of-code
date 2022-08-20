import strutils
import ../common

type
  SeatMap = seq[string]

#proc `$`(seatMap: SeatMap): string =
#  for i, line in seatMap:
#    result.add(line)
#    if i < seatMap.high: result.add('\n')

proc countAdjacentChars(seatMap: SeatMap; character: char; col, row: int): int =
  for checkCol in -1 .. 1:
    for checkRow in -1 .. 1:
      if (checkCol, checkRow) != (0, 0) and row + checkRow in 0 ..
      seatMap.high and col + checkCol in 0 .. seatMap[0].high:
        if seatMap[row + checkRow][col + checkCol] == character: result += 1

proc doIteration(seatMap: var SeatMap): bool =
  let prevSeatMap = seatMap
  for row, line in prevSeatMap:
    for col, cell in line:
      if cell == 'L':
        if countAdjacentChars(prevSeatMap, '#', col, row) == 0:
          seatMap[row][col] = '#'
      elif cell == '#':
        if countAdjacentChars(prevSeatMap, '#', col, row) >= 4:
          seatMap[row][col] = 'L'
  if seatMap == prevSeatMap: return true

var
  seatMap = getInput()

while true:
  #echo seatMap
  if doIteration(seatMap):
    var occupiedSeats: int
    for line in seatMap:
      occupiedSeats += line.count('#')
    echo occupiedSeats
    break
