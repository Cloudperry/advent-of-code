import ../lib
import regex, cligen

type Signals = tuple[signals: seq[string], outputs: seq[string]]

proc parseOutputUniqueDigits(input: string): Signals  =
  var matches: RegexMatch
  for line in input.splitLines:
    if line.match(re"(?:([abcdefg]{2,7})\s*)+ \| (?:([abcdefg]{2,7})\s*)+", matches):
      result.signals.add matches.group(0, line)
      result.outputs.add matches.group(1, line)

proc solvePart(part = 1.AocPart, inputFile = "") = #I'm going to add a neat way of running both parts with the parsed input soon 
  let input = getInputWithParser(8, 2021, parseOutputUniqueDigits, inputFile) 
  if part == 1:
    echo input.outputs.countIt(it.len in {2, 3, 4, 7}) #Counts the number of unique digit signals in all of the outputs
  else:
    discard

if isMainModule: dispatch(solvePart)
