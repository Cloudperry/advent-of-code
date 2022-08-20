import strutils
import ../common

let input = getInput()

var validPasswdCount: int
for line in input:
  var parts = line.split({'-', ':', ' '})
  parts.del(3) #Use del to remove empty string
  let
    (minCount, maxCount) = (parts[0].parseInt(), parts[1].parseInt())
    (letter, passwd) = (parts[2], parts[3])
  if passwd.count(letter) in minCount..maxCount:
    validPasswdCount += 1

echo validPasswdCount
