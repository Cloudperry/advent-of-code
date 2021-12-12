import ../lib
import regex, cligen

type AgeGroups = array[9, int]

proc parseCsvInts(input: string): AgeGroups =
  var matches: RegexMatch
  if input.match(re"(?:(\d),*)+", matches):
    for lfAge in matches.group(0, input):
      result[lfAge.parseInt].inc

proc lanternFishSpawnSimCycle(lfAgeCounts: var AgeGroups) =
  var newLfAgeCounts: AgeGroups
  for lfAge in 0 .. 8:
    case lfAge #This whole thing could quite easily be rewritten to be branchless with wraparound arithmetic instead of lfAge + 1
    of 0..7:   #That code would require a special case for 6 only, but it would be unreadable to most people (or myself later) so I won't do it
      newLfAgeCounts[lfAge] = lfAgeCounts[lfAge + 1]
      if lfAge == 6: newLfAgeCounts[6] += lfAgeCounts[0]
    of 8:
      newLfAgeCounts[lfAge] = lfAgeCounts[0]
    else: discard
  lfAgeCounts = newLfAgeCounts

    
proc solvePart(part = 1.AocPart; inputFile = "") =
  var input = getInputWithParser(6, 2021, parseCsvInts, inputFile)
  if part == 1:
    for day in 1 .. 80:
      input.lanternFishSpawnSimCycle()
  else:
    for day in 1 .. 256:
      input.lanternFishSpawnSimCycle()
  echo input.sum

if isMainModule: dispatch(solvePart)
