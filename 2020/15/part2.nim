import sequtils, strutils, tables
import ../common

const solveLength = 30000000

let input = getInput()[0].split(',').mapIt(parseInt(it))

var
  lastIOfNumber: Table[int, int]
  i = input.high
  n = input[^1]

for i, n in input[0 .. ^2]:
  lastIOfNumber[n] = i

while i < solveLength - 1:
  let prevN = n
  if n in lastIOfNumber:
    n = i - lastIOfNumber[n]
  else:
    n = 0
  lastIOfNumber[prevN] = i
  i += 1

echo n
