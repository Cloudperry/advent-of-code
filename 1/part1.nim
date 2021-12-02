import strutils, strscans

var answer: int
var depth, prevDepth: int

for line in lines("input.txt"):
  if scanf(line, "$i", depth):
    if prevDepth != 0 and depth > prevDepth:
      answer += 1
    prevDepth = depth

echo answer
