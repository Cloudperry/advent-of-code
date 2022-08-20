import strutils, strscans, math
import ../common

let input = getInput()

var
  memory: array[uint16.high, int] #In my input I only saw memory addresses smaller than uint16 and values smaller than uint32
  currentMask: string
for line in input:
  var address, value: int
  discard line.scanf("mask = $+", currentMask)
  if line.scanf("mem[$i] = $i", address, value):
    var maskedValue: string
    for i, bitChar in value.toBin(36):
      if currentMask[i] != 'X' and bitChar != currentMask[i]:
        maskedValue &= currentMask[i]
      else:
        maskedValue &= bitChar
    memory[address.uint16] = maskedValue.parseBinInt()

echo sum(memory)
