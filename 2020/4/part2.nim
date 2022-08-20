#I hate validating things, so this program will do the minimum amount of validation needed to get a correct answer
import strutils, sets, sugar
import ../common

const
  allPassportFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl",
                    "pid", "cid"].toHashSet()
  requiredFields = allPassportFields.dup(excl("cid"))

var input = getInput()
if input[^1] != "": #Add empty line to end, because this parser checks passport validity on an empty line
  input.add("")

proc passportIsValid(passportFields: HashSet[string]): bool =
  passportFields == allPassportFields or passportFields == requiredFields

proc fieldIsValid(field, value: string): bool =
  if field == "byr" and value.parseInt() in 1920 .. 2002:
    return true
  elif field == "iyr" and value.parseInt() in 2010 .. 2020:
    return true
  elif field == "eyr" and value.parseInt() in 2020 .. 2030:
    return true
  elif field == "ecl" and value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]:
    return true
  elif field == "hcl" and value[0] == '#':
    var valid = true
    for char in value[1..^1]:
      if char notin HexDigits: valid = false
    if value.len != 7: valid = false
    return valid
  elif field == "hgt":
    if "cm" in value: #Next lines will error and crash if value has cm/in in it, but doesn't have a number before it
      return value.replace("cm", "").parseInt() in 150 .. 193
    elif "in" in value:
      return value.replace("in", "").parseInt() in 59 .. 76
  elif field == "pid":
    var valid = true
    for char in value:
      if char notin Digits: valid = false
    if value.len != 9: valid = false
    return valid
  elif field == "cid":
    return true

var validPassports: int
var currentPpValidFields: HashSet[string]
for line in input:
  if line != "":
    let fieldValuePairs = line.split()
    for fieldValuePair in fieldValuePairs:
      let
        parts = fieldValuePair.split(':')
        (field, value) = (parts[0], parts[1])
      if fieldIsValid(field, value):
        currentPpValidFields.incl(field)
  else:
    if passportIsValid(currentPpValidFields):
      validPassports += 1
    currentPpValidFields.init()

echo validPassports
