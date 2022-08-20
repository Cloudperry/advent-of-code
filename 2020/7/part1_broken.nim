import tables, sets, strutils, sequtils
import ../common

type
  Bag = ref object
    style: string
    case container: bool
    of true:
      requiredContent: seq[tuple[amount: int, bag: Bag]]
    of false:
      ##

proc `$`(bag: Bag): string =
  if bag.container:
    bag.style & " contains: " & $bag.requiredContent
  else:
    bag.style & " is empty"

let input = getInput()
var bags: Table[string, Bag]
for line in input:
  let 
    styleAndContent = line.split(" bags contain ")
    bagStyle = styleAndContent[0]
    contents = styleAndContent[1].split(", ").mapIt(it.split)
  if contents[0] == "no" and contents[1] == "other":
    bags[bagStyle] = Bag(style: bagStyle, container: false)
  else:
    if bagStyle notin bags or not bags[bagStyle].container:
      bags[bagStyle] = Bag(style: bagStyle, container: true)
    var i: int
    while i < contents.high:
      let (amount, innerBagStyle) = (contents[i], contents[i+1 .. i+2].join(" "))

      if innerBagStyle notin bags:
        bags[innerBagStyle] = Bag(style: innerBagStyle, container: false)
    bags[bagStyle].requiredContent.add((amount, bags[innerBagStyle]))

proc addInnerBagsRecursively(bag: Bag, bags: Table[string, Bag]) =
  for innerBag in bag.requiredContent.mitems:
    if not innerBag.bag.container and bags[innerBag.bag.style].container: 
      innerBag = (innerBag.amount, bags[innerBag.bag.style])
      addInnerBagsRecursively(innerBag.bag, bags)

for bag in bags.mvalues:
  if bag.container:
    addInnerBagsRecursively(bag, bags)

#echo bags

proc findBagsRecursively(bag: Bag, targetBagStyle: string, recursedBags: var seq[string]): HashSet[string] =
  recursedBags.add(bag.style)
  for innerBag in bag.requiredContent.mitems:
    if innerBag.bag.style == targetBagStyle:
      #echo bag
      result.incl(bag.style)
    if innerBag.bag.container: result.incl(findBagsRecursively(innerBag.bag, targetBagStyle, recursedBags))
  
var bagsThatContainShinyGoldBag: HashSet[string]
for bag in bags.mvalues:
  #echo bag.style
  if bag.container:
    var recursedBags: seq[string]
    bagsThatContainShinyGoldBag.incl(findBagsRecursively(bag, "shiny gold", recursedBags))
    let shinyGoldBagI = recursedBags.find("shiny gold")
    if shinyGoldBagI != -1:
      echo recursedBags[0 ..< shinyGoldBagI] 
      bagsThatContainShinyGoldBag.incl recursedBags[0 ..< shinyGoldBagI].toHashSet() 

echo bagsThatContainShinyGoldBag.len
  
