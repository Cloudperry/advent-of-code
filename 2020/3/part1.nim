import strformat, strutils
import ../common

let
  input = getInput()
  rowLen = input[0].len

var treesHit: int
for rowN, row in input:
  if rowN == 0: continue
  let xCoord = 3 * rowN mod rowLen
  #echo fmt"checking coordinate ({xCoord}, {rowN})"
  if row[xCoord] == '#':
    treesHit += 1
    #echo fmt"hit a tree at ({xCoord}, {rowN})"

echo treesHit
