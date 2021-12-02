import strscans

type SubmarinePos = tuple[x, depth, aim: int]

var submarinePos: SubmarinePos
for line in lines("input.txt"):
  var command: string
  var value: int
  if scanf(line, "$w $i", command, value):
    case command:
      of "down":
        submarinePos.aim += value
      of "up":
        submarinePos.aim -= value
      of "forward":
        submarinePos.x += value
        submarinePos.depth += submarinePos.aim * value

echo submarinePos.x * submarinePos.depth
