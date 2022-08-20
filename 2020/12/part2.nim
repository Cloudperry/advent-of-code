import strutils
import ../common

type
  Ferry = ref object
    waypoint: tuple[x, y: int]
    position: tuple[x, y: int] #Neg. x is west, pos. x is east, neg. y is south and pos. y is north
  TurnDirection = enum
    right, left
  CardinalDirection = enum
    north, east, south, west

proc newFerry(): Ferry =
  result = Ferry()
  result.waypoint = (10, 1)
#[
proc `$`(position: tuple[x, y: int]): string =
  if position.x >= 0:
    result.add("east " & $position.x & ',')
  else:
    result.add("west " & $position.x.abs & ',')
  if position.y >= 0:
    result.add(" north " & $position.y)
  else:
    result.add(" south " & $position.y.abs)

proc `$`(ferry: Ferry): string =
  result.add("ferry at pos: ")
  result.add($ferry.position)
  result.add("\nwaypoint at pos: ")
  result.add($ferry.waypoint)
]#
proc turnWaypoint(ferry: Ferry; direction: TurnDirection; degrees: int) =
  proc turnRight90() =
    swap(ferry.waypoint.x, ferry.waypoint.y)
    ferry.waypoint.y *= -1
  proc turnLeft90() =
    swap(ferry.waypoint.x, ferry.waypoint.y)
    ferry.waypoint.x *= -1
  proc turn180() =
    ferry.waypoint.x *= -1
    ferry.waypoint.y *= -1
  if degrees in {270, 180}:
    turn180()
  if degrees in {90, 270} and direction == left:
    turnLeft90()
  elif degrees in {90, 270} and direction == right:
    turnRight90()

proc moveWaypointToDirection(ferry: Ferry; direction: CardinalDirection; units: int) =
  if direction == north:
    ferry.waypoint.y += units
  elif direction == east:
    ferry.waypoint.x += units
  elif direction == south:
    ferry.waypoint.y -= units
  else:
    ferry.waypoint.x -= units

proc moveForward(ferry: Ferry; units: int) =
  ferry.position.x += ferry.waypoint.x * units
  ferry.position.y += ferry.waypoint.y * units

let input = getInput()
var ferry = newFerry()
for instruction in input:
  #echo ferry
  let (action, units) = (instruction[0], instruction[1 .. ^1].parseInt())
  if action == 'N':
    ferry.moveWaypointToDirection(north, units)
  elif action == 'E':
    ferry.moveWaypointToDirection(east, units)
  elif action == 'S':
    ferry.moveWaypointToDirection(south, units)
  elif action == 'W':
    ferry.moveWaypointToDirection(west, units)
  elif action == 'L':
    ferry.turnWaypoint(left, units)
  elif action == 'R':
    ferry.turnWaypoint(right, units)
  elif action == 'F':
    ferry.moveForward(units)

echo ferry.position.x.abs + ferry.position.y.abs
