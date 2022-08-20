import strformat, strutils
import ../common

let
  input = getInput()
  rowLen = input[0].len

proc travel(slopeY, slopeX: int): int =
  var x, y: int
  while y in 0 .. input.high - 1:
    y += slopeY
    x += slopeX
    #echo fmt"checking coordinate ({xCoord}, {rowN})"
    if input[y][x mod rowLen] == '#':
      result += 1
      #echo fmt"hit a tree at ({xCoord}, {rowN})"

echo travel(1, 1) * travel(3, 1) * travel(5, 1) * travel(7, 1) * travel(1, 2)
