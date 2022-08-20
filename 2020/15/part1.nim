import sequtils, strutils
import ../common

proc getPrevOccurrenceDist(s: seq, i: int): int =
  for currentI in countdown(i - 1, 0):
    let n = s[currentI]
    if n == s[i]:
      return i - currentI

var
  input = getInput()[0].split(',').mapIt(parseInt(it))
  i = input.high

while i <= input.high:
  if i == 2019: break
  let prevNCount = input.count(input[i])
  if prevNCount == 1:
    input.add(0)
  elif prevNCount > 1:
    input.add(getPrevOccurrenceDist(input, i))
  i += 1

echo(input[2019])
