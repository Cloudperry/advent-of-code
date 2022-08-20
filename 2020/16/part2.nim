import strscans, strutils, sequtils, tables, sets, sugar
import ../common

let input = getInput()

var
  fieldValidRange: Table[string, tuple[first, second: Slice[int]]]
  ticketsSectionFound: bool
  nthFieldsOfTickets: seq[seq[int]]

for line in input:
  var
    r1Start, r1End, r2Start, r2End: int
    fieldName: string
  if line.scanf("$+: $i-$i or $i-$i", fieldName, r1Start, r1End, r2Start, r2End):
    fieldValidRange[fieldName] = (r1Start .. r1End, r2Start .. r2End)
  elif "nearby tickets:" in line:
    ticketsSectionFound = true
  elif ticketsSectionFound:
    let ticketNumbers = line.parseCsvInts()
    once:
      nthFieldsOfTickets = newSeqWith(ticketNumbers.len, newSeq[int]())
    for i, number in ticketNumbers:
      nthFieldsOfTickets[i].add(number)

var validFieldsForFieldN: Table[int, HashSet[string]]

for fieldN, fields in nthFieldsOfTickets:
  for fieldName, range in fieldValidRange:
    var fieldNValidForCurrField = true
    for number in fields:
      if number notin range[0] and number notin range[1]:
        #echo number, " on column", fieldN, " is invalid for ", fieldName, range
        fieldNValidForCurrField = false
    if fieldNValidForCurrField:
      echo "column ", fieldN, " is valid for ", fieldName
      if fieldN notin validFieldsForFieldN:
        validFieldsForFieldN[fieldN] = initHashSet[string]()
      validFieldsForFieldN[fieldN].incl(fieldName)

echo validFieldsForFieldN
