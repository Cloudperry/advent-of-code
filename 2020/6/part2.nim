import sets
import ../common

var input = getInput()
if input[^1] != "": input.add("") #Add empty line to end of input, so we can use empty lines to trigger count of positive answers in group

var yesCount: int
var currGroupAnsForPerson: seq[HashSet[char]]
var currGroupSharedYesAns: HashSet[char]
for line in input:
  if line != "":
    currGroupAnsForPerson.add(line.toHashSet())
  else:
    for personYesAnswers in currGroupAnsForPerson:
      currGroupSharedYesAns.incl(personYesAnswers)
    for personYesAnswers in currGroupAnsForPerson:
      currGroupSharedYesAns.excl(currGroupSharedYesAns -+- personYesAnswers)
    #echo currGroupSharedYesAns
    yesCount += currGroupSharedYesAns.len
    currGroupAnsForPerson.setLen(0)
    currGroupSharedYesAns.clear()

echo yesCount
