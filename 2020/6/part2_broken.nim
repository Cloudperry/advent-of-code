import sets
import ../common

var input = getInput()
if input[^1] != "": input.add("") #Add empty line to end of input, so we can use empty lines to trigger count of positive answers

var sharedYesCount: int
var currGroupSharedYesAns, currPersonYesAns, prevPersonYesAns: HashSet[char]
for line in input:
  if line != "":
    if currPersonYesAns.len > 0: prevPersonYesAns = currPersonYesAns
    currPersonYesAns.init()
    currPersonYesAns.incl(line.toHashSet())
    currGroupSharedYesAns.incl(currPersonYesAns * prevPersonYesAns)
    currGroupSharedYesAns.excl(currPersonYesAns -+- prevPersonYesAns)
    #echo "current: ", currPersonYesAns, "previous: ", prevPersonYesAns,
    #     "group: ", currGroupSharedYesAns
  else:
    if currPersonYesAns.len > 0 and prevPersonYesAns.len == 0:
      currGroupSharedYesAns = currPersonYesAns
    #echo currGroupSharedYesAns
    sharedYesCount += currGroupSharedYesAns.len
    currPersonYesAns.clear(); prevPersonYesAns.clear()
    currGroupSharedYesAns.clear()

echo sharedYesCount
