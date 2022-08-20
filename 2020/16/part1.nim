import strscans, strutils
import ../common

let input = getInput()

var
  validNumberRanges: seq[Slice[int]]
  ticketsSectionFound: bool
  ticketScanErrorRate: int

for line in input:
  var
    r1Start, r1End, r2Start, r2End: int
    fieldName: string
  if line.scanf("$+: $i-$i or $i-$i", fieldName, r1Start, r1End, r2Start, r2End):
    validNumberRanges.add(r1Start .. r1End)
    validNumberRanges.add(r2Start .. r2End)
  elif "nearby tickets:" in line:
    ticketsSectionFound = true
  elif ticketsSectionFound:
    let ticketNumbers = line.parseCsvInts()
    for number in ticketNumbers:
      var numberValidForSomeRange: bool
      for range in validNumberRanges:
        if number in range:
          numberValidForSomeRange = true
      if not numberValidForSomeRange:
        ticketScanErrorRate += number

echo ticketScanErrorRate
