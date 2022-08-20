import strutils, strscans, sequtils, tables, math
import ../common

let input = getInput()
let targetTime = input[0].parseInt()

proc getTimestampAfterTarget(id, target: int): int = id * (target / id).ceil.int

var busIdWithLeastWait, leastWaitTime: int
for value in input[1].split(','):
  var id: int
  if value.scanf("$i", id):
    let
      timestampAfterTarget = getTimestampAfterTarget(id, targetTime)
      waitTime = timestampAfterTarget - targetTime
    if leastWaitTime == 0:
      leastWaitTime = waitTime
    elif waitTime < leastWaitTime:
      leastWaitTime = waitTime
      busIdWithLeastWait = id

echo busIdWithLeastWait * leastWaitTime
