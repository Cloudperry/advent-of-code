import strscans, strutils, tables, sets
import ../common

type
  BagTable = Table[string, seq[tuple[amount: int, style: string]]]

proc parseBags(inputLines: seq[string]): BagTable =
  var
    bagStyle, innerBagStyle, contents: string
    amount: int
    parsedContents: seq[tuple[amount: int, style: string]]
  for line in inputLines:
    if line.scanf("$+ bags contain $+", bagStyle, contents):
      parsedContents.setLen(0)
      for bag in contents.split(", "):
        if bag.scanf("$i $+ bag", amount, innerBagStyle):
          parsedContents.add (amount, innerBagStyle)
      result[bagStyle] = parsedContents

proc checkBagsRecur(bagStyle: string, targetStyle: string, bags: BagTable,
                    bagsSeen: var HashSet[string]): HashSet[string] =
  if bagStyle == targetStyle and bagsSeen.len > 0:
    echo bagStyle, " bag found, returning ", bagsSeen
    return bagsSeen
  else:
    if bags[bagStyle].len > 0:
      stdout.write(bagStyle & " -> ")
      bagsSeen.incl(bagStyle)
      for innerBag in bags[bagStyle]:
        #[return!?]#
        result.incl checkBagsRecur(innerBag.style, targetStyle, bags, bagsSeen)
    else:
      echo ""
      #echo "clearing."
      bagsSeen.clear()

let input = getInput()
let bags = parseBags(input)
var possibleContainerBags, bagsSeenTemp: HashSet[string]
const targetBagStyle = "shiny gold"
for bagStyle in bags.keys:
  possibleContainerBags.incl checkBagsRecur(bagStyle, targetBagStyle, bags, bagsSeenTemp)

echo possibleContainerBags.len
