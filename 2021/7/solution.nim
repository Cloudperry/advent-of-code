import ../lib
import regex, cligen

type Positions = CountTable[int16]

proc parseCsvPositions(input: string): Positions = #I will use nim's parsecsv next time and maybe add it to lib.nim
  var matches: RegexMatch
  if input.match(re"(?:(\d+),*)+", matches):
    for n in matches.group(0, input):
      result.inc(n.parseInt.int16)

proc getSumOfPositiveNums(n: int): int = n * (n + 1) div 2

proc getCostToMovePart1(p: Positions; newPos: int16): int =
  for pos, count in p:
    if pos != newPos: result += count * abs(newPos - pos)

proc getCostToMovePart2(p: Positions; newPos: int16): int =
  for pos, count in p:
    if pos != newPos: result += count * getSumOfPositiveNums((newPos - pos).abs)

proc solvePart(part = 1.AocPart, inputFile = "") =
  let input = getInputWithParser(7, 2021, parseCsvPositions, inputFile)
  var minPos, maxPos: int16
  for pos in input.keys:
    minPos = min(minPos, pos)
    maxPos = max(maxPos, pos)
  var cheapestPosCost = int.high
  if part == 1:
    for pos in minPos .. maxPos:
      cheapestPosCost = min(cheapestPosCost, input.getCostToMovePart1(pos))
  else:
    for pos in minPos .. maxPos:
      cheapestPosCost = min(cheapestPosCost, input.getCostToMovePart2(pos))
  
  echo cheapestPosCost

if isMainModule: dispatch(solvePart)
