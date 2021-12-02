import strscans

type SubmarinePos = tuple[x: int; depth: int]

var submarinePos: SubmarinePos
for line in lines("input.txt"):
  var command: string
  var value: int
  if scanf(line, "$w $i", command, value):
    case command:
      of "forward":
        submarinePos.x += value
      of "down":
        submarinePos.depth += value
      of "up":
        submarinePos.depth -= value

echo submarinePos.x * submarinePos.depth
