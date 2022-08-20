import ../lib
import cligen

type 
  Line = object
    x1, y1, x2, y2: int
  Point = tuple[x, y: int]

proc parseLine(input: string): Line =
  var x1, y1, x2, y2: int
  if input.scanf("$i,$i$s->$s$i,$i", x1, y1, x2, y2):
    result = Line(x1: x1, y1: y1, x2: x2, y2: y2)

iterator points(l: Line; xStep, yStep: int): Point =
  var (x, y) = (l.x1, l.y1)
  while x in min(l.x1, l.x2) .. max(l.x1, l.x2) and y in min(l.y1, l.y2) .. max(l.y1, l.y2):
    yield (x: x, y: y)
    x += xStep
    y += yStep

proc markPoints(l: Line; g: var Table[Point, uint8]; xs, ys: int) =
  for x, y in l.points(xs, ys):
    if (x, y) in g:
      g[(x, y)] += 1
    else:
      g[(x, y)] = 1

proc solvePart(part = 1.AocPart, inputFile = "") =
  var grid: Table[Point, uint8]
  var pointsWithTwoOrMore: int
  let input = getInputLinesWithParser(5, 2021, parser = parseLine, inputFile = inputFile)
  if part == 1:
    for line in input:
      if line.x1 != line.x2 and line.y1 == line.y2:
        line.markPoints(grid, sgn(line.x2 - line.x1), 0)
      elif line.y1 != line.y2 and line.x1 == line.x2:
        line.markPoints(grid, 0, sgn(line.y2 - line.y1))
  else:
    for line in input:
      if line.x1 != line.x2 and line.y1 == line.y2:
        line.markPoints(grid, sgn(line.x2 - line.x1), 0)
      elif line.y1 != line.y2 and line.x1 == line.x2:
        line.markPoints(grid, 0, sgn(line.y2 - line.y1))
      else:
        line.markPoints(grid, sgn(line.x2 - line.x1), sgn(line.y2 - line.y1))

  for point, lineCount in grid:
    if lineCount >= 2: pointsWithTwoOrMore += 1
  echo pointsWithTwoOrMore

if isMainModule: dispatch(solvePart)
