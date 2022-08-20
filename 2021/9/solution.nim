import ../lib
import cligen, terminal, os
from osProc import execCmd

type Point = tuple[x, y: int]

const pointsToCheck = [(x: 1, y:0), (x: 0, y: -1), (x: -1, y: 0), (x: 0, y: 1)]

proc clearScreen() = 
  when system.hostOS == "windows":
    eraseScreen()
  else:
    discard execCmd "clear"

proc parseHeightMapLine(input: string): seq[uint8] =
  for height in input:
    result.add ($height).parseInt.uint8

iterator adjacentPoints(heightMap: seq[seq[uint8]]; point: Point): tuple[p: Point; h: uint8] =
  for deltaPoint in pointsToCheck:
    let newPoint: Point = (point.x + deltaPoint.x, point.y + deltaPoint.y)
    if newPoint.y in 0 .. heightMap.high and newPoint.x in 0 .. heightMap[point.y].high:
      yield (newPoint, heightMap[newPoint.y][newPoint.x])

proc lowPoints(heightMap: seq[seq[uint8]]): seq[Point] =
  for rowN, row in heightMap:
    for colN, val in row.pairs:
      var isLowPoint = true
      for _, height in heightMap.adjacentPoints((colN, rowN)):
        if val >= height:
          isLowPoint = false
          break
      if isLowPoint:
        result.add (colN, rowN)

proc getBasinSize(heightMap: seq[seq[uint8]], point: Point, seenPoints: var HashSet[Point], visuals = false): int =
  if heightMap[point.y][point.x] < 9 and (point.x, point.y) notin seenPoints:
    if visuals:
      sleep(500)
      clearScreen()
      for rowN, row in heightMap:
        for colN, height in row:
          if (colN, rowN) in seenPoints:
            stdout.styledWrite(fgGreen, $height)
          else:
            stdout.write(height)
        stdout.write('\n')

    seenPoints.incl point
    result = 1
    let prevPointH = heightMap[point.y][point.x]
    for newPoint, height in heightMap.adjacentPoints(point):
      if height > prevPointH:
        result += heightMap.getBasinSize(newPoint, seenPoints, visuals)

proc solvePart(part = 1.AocPart, inputFile = "", part2Visuals = false) =
  let input = getInputLinesWithParser(9, 2021, parseHeightMapLine, inputFile)
  let lowPoints = input.lowPoints()
  if part == 1:
    var lowPointHeights: CountTable[uint8]
    var sum: int
    for point in input.lowPoints:
      lowPointHeights.inc(input[point.y][point.x])
    for height, count in lowPointHeights:
      sum += (height + 1).int * count
    echo sum
  else:
    var basinSizes: seq[int]
    var seenPoints: HashSet[Point]
    for point in lowPoints:
      basinSizes.add input.getBasinSize(point, seenPoints, part2Visuals)
    basinSizes.sort(Descending)
    echo basinSizes[0] * basinSizes[1] * basinSizes[2]

if isMainModule: dispatch(solvePart)
