import strutils, math
import ../common

type
  Ferry = ref object
    position: tuple[x, y: int] #Neg. x is west, pos. x is east, neg. y is south and pos. y is north
    facing: int #Direction the ship is facing, when 0 degrees is east, 90 degrees is north and 270 degrees is south
  TurnDirection = enum
    right, left
  CardinalDirection = enum
    north, east, south, west

proc `$`(ferry: Ferry): string =
  if ferry.position.x >= 0:
    result.add("east " & $ferry.position.x & ',')
  else:
    result.add("west " & $ferry.position.x.abs & ',')
  if ferry.position.y >= 0:
    result.add(" north " & $ferry.position.y)
  else:
    result.add(" south " & $ferry.position.y.abs)

proc turn(ferry: Ferry, direction: TurnDirection, degrees: int) =
  if direction == left:
    ferry.facing += degrees
  else:
    ferry.facing -= degrees
  if ferry.facing < 0:
    ferry.facing += 360 #This only works if the ferry can't turn over 360 degrees in one instruction

proc moveToDirection(ferry: Ferry, direction: CardinalDirection, units: int) =
  if direction == north:
    ferry.position.y += units
  elif direction == east:
    ferry.position.x += units
  elif direction == south:
    ferry.position.y -= units
  else:
    ferry.position.x -= units

proc moveForward(ferry: Ferry, units: int) =
  ferry.position.y += (sin(ferry.facing.float.degToRad)).int * units
  ferry.position.x += (cos(ferry.facing.float.degToRad)).int * units

let input = getInput()
var ferry = Ferry()
for instruction in input:
  let (action, units) = (instruction[0], instruction[1 .. ^1].parseInt())
  if action == 'N':
    ferry.moveToDirection(north, units)
  elif action == 'E':
    ferry.moveToDirection(east, units)
  elif action == 'S':
    ferry.moveToDirection(south, units)
  elif action == 'W':
    ferry.moveToDirection(west, units)
  elif action == 'L':
    ferry.turn(left, units)
  elif action == 'R':
    ferry.turn(right, units)
  elif action == 'F':
    ferry.moveForward(units)
  echo ferry

echo ferry.position.x.abs + ferry.position.y.abs
