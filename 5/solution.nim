import ../lib

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

proc markPoints(l: Line; p: var seq[tuple[p: Point, lineCount: int]]; xs, ys: int) =
  for x, y in l.points(xs, ys):
    var pointFound: bool
    for point in p.mitems:
      if point.p == (x, y): 
        pointFound = true
        point.lineCount += 1
    if not pointFound:
      p.add ((x, y), 1)

proc solvePart(part = 1.AocPart, inputFile = "") =
  var linesOnPoint: seq[tuple[p: Point, lineCount: int]] #Wish I knew of a better way to do sparse 2D seqs... Tried table inside table but couldn't make it work
  var pointsWithTwoOrMore: int
  let input = getInputLinesWithParser(5, 2021, parser = parseLine, inputFile = inputFile)
  if part == 1:
    for line in input:
      if line.x1 != line.x2 and line.y1 == line.y2:
        line.markPoints(linesOnPoint, sgn(line.x2 - line.x1), 0)
      elif line.y1 != line.y2 and line.x1 == line.x2:
        line.markPoints(linesOnPoint, 0, sgn(line.y2 - line.y1))
  else:
    for line in input:
      if line.x1 != line.x2 and line.y1 == line.y2:
        line.markPoints(linesOnPoint, sgn(line.x2 - line.x1), 0)
      elif line.y1 != line.y2 and line.x1 == line.x2:
        line.markPoints(linesOnPoint, 0, sgn(line.y2 - line.y1))
      else:
        line.markPoints(linesOnPoint, sgn(line.x2 - line.x1), sgn(line.y2 - line.y1))

  for point in linesOnPoint:
    if point.lineCount >= 2: pointsWithTwoOrMore += 1
  echo pointsWithTwoOrMore

if isMainModule: dispatch(solvePart)
