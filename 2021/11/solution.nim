import ../lib 
import cligen
import options

type 
  Point = tuple[x, y: int]
  OctopusGrid = seq[seq[uint8]]

proc `$`(g: OctopusGrid): string =
  for row in g:
    for energy in row:
      result.add $energy & ' '
    result.add '\n'

const pointsToCheck = [(x: 1, y:0), (x: 1, y: -1), (x: 0, y: -1), (x: -1, y: -1), (x: -1, y: 0), (x: -1, y: 1), (x: 0, y: 1), (x: 1, y: 1)]

iterator pointAndEnergy(g: OctopusGrid): tuple[x, y: int; energy: uint8] =
  for y, row in g:
    for x, energy in row:
      yield (x, y, energy)

iterator adjacentPoints(octopuses: OctopusGrid; point: Point): tuple[direction: Point, newPoint: Point] =
  for deltaPoint in pointsToCheck:
    let newPoint: Point = (point.x + deltaPoint.x, point.y + deltaPoint.y)
    if newPoint.y in 0 .. octopuses.high and newPoint.x in 0 .. octopuses[point.y].high:
      yield (deltaPoint, newPoint)

proc parseOctopusEnergyLevels(input: string): seq[uint8] =
  for energy in input:
    result.add ($energy).parseInt.uint8

proc doOctopusFlashes(octopuses: var OctopusGrid, point: Point, visitedPoints: var HashSet[Point]): int =
  #echo fmt"Visited point {point}, energy: {octopuses[point.y][point.x]}"
  visitedPoints.incl point
  if octopuses[point.y][point.x] == 10:
    result = 1
    for direction, newPoint in octopuses.adjacentPoints(point):
      if octopuses[newPoint.y][newPoint.x] <= 9:
        octopuses[newPoint.y][newPoint.x].inc
        if newPoint notin visitedPoints:
          result += octopuses.doOctopusFlashes(newPoint, visitedPoints)
    octopuses[point.y][point.x] = 0

proc doOctopusSimStep(octopuses: var OctopusGrid): int =
  var newGrid = octopuses
  for x, y, energy in octopuses.pointAndEnergy():
    newGrid[y][x] = energy + 1
  echo fmt"Energy +1:{'\n'}{newGrid}"
  var visitedPoints: HashSet[Point]
  for x, y, energy in octopuses.pointAndEnergy():
    result += newGrid.doOctopusFlashes((x, y), visitedPoints)
  echo fmt"Flashes done:{'\n'}{newGrid}"
  octopuses = newGrid

proc solvePart(part = 1.AocPart, inputFile = "") =
  var input: OctopusGrid = getInputLinesWithParser(11, 2021, parseOctopusEnergyLevels, inputFile)
  if part == 1:
    var flashes: int
    for i in 1 .. 10:
      flashes += input.doOctopusSimStep()
    echo flashes
  else:
    discard

if isMainModule: dispatch(solvePart)
