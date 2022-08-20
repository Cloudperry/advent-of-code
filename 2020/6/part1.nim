import strutils, sets
import ../common

var input = getInput()
if input[^1] != "": input.add("") #Add empty line to end of input, so we can use empty lines to trigger count of positive answers

var yesCount: int
var currGroupYesAnsChars: HashSet[char]
for line in input:
  if line != "":
    currGroupYesAnsChars.incl(line.toHashSet())
  else:
    yesCount += currGroupYesAnsChars.len
    currGroupYesAnsChars.init()

echo yesCount
