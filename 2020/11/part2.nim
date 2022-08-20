import strutils
import ../common

type
  SeatMap = seq[string]

#proc `$`(seatMap: SeatMap): string =
#  for i, line in seatMap:
#    result.add(line)
#    if i < seatMap.high: result.add('\n')

proc countSeenChars(seatMap: SeatMap; charToFind, visionBlockChar: char;
                    col, row: int): int =
  for checkColDirection in -1 .. 1:
    for checkRowDirection in -1 .. 1:
      if (checkColDirection, checkRowDirection) != (0, 0):
        var (checkCol, checkRow) = (col, row)
        block doVisionCheck:
          while true:
            checkCol += checkColDirection
            checkRow += checkRowDirection
            if checkRow in 0 .. seatMap.high and checkCol in 0 .. seatMap[0].high:
              if seatMap[checkRow][checkCol] == charToFind:
                result += 1
                break doVisionCheck
              elif seatMap[checkRow][checkCol] == visionBlockChar:
                break doVisionCheck
            else:
              break

proc doIteration(seatMap: var SeatMap): bool =
  let prevSeatMap = seatMap
  for row, line in prevSeatMap:
    for col, cell in line:
      if cell == 'L':
        if countSeenChars(prevSeatMap, '#', 'L', col, row) == 0:
          seatMap[row][col] = '#'
      elif cell == '#':
        if countSeenChars(prevSeatMap, '#', 'L', col, row) >= 5:
          seatMap[row][col] = 'L'
  if seatMap == prevSeatMap: return true

var
  seatMap = getInput()

while true:
  #echo seatMap
  #discard stdin.readLine()
  if doIteration(seatMap):
    var occupiedSeats: int
    for line in seatMap:
      occupiedSeats += line.count('#')
    echo occupiedSeats
    break
