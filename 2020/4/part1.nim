import strutils, sets, sugar
import ../common

const
  allPassportFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl",
                    "pid", "cid"].toHashSet()
  requiredFields = allPassportFields.dup(excl("cid"))

var input = getInput()
if input[^1] != "": #Add empty line to end, because this parser checks passport validity on an empty line
  input.add("")

proc ppHasRequiredFields(passportFields: HashSet[string]): bool =
  passportFields == allPassportFields or passportFields == requiredFields

var validPassports: int
var currentPpFoundFields: HashSet[string]
for line in input:
  if line != "":
    let keyValPairs = line.split()
    for keyValPair in keyValPairs:
      currentPpFoundFields.incl(keyValPair.split(':')[0])
  else:
    if ppHasRequiredFields(currentPpFoundFields):
      validPassports += 1
    currentPpFoundFields.init()

echo validPassports
