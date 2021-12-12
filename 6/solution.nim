import ../lib
import regex, cligen

proc parseCsvInts(input: string): seq[uint64] =
  result = newSeq[uint64](9) #Idk why, but I needed uint64 to make it work
  var matches: RegexMatch
  if input.match(re"(?:(\d),*)+", matches):
    for lfAge in matches.group(0, input):
      result[lfAge.parseInt].inc

proc lanternFishSpawnSimCycle(lfAgeCounts: var seq[uint64]) =
  var newLfAges = newSeq[uint64](9)
  for lfAge in 0 .. 8:
    case lfAge #This whole thing could quite easily be rewritten to be branchless with wraparound arithmetic instead of lfAge + 1
    of 0..7:   #That code would require a special case for 6 only, but it would be unreadable to most people (or myself later) so I won't do it
      newLfAges[lfAge] = lfAgeCounts[lfAge + 1]
      if lfAge == 6: newLfAges[6] += lfAgeCounts[0]
    of 8:
      newLfAges[lfAge] = lfAgeCounts[0]
    else: discard
  lfAgeCounts = newLfAges

    
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
