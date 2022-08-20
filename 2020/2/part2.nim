import strutils
import ../common

let input = getInput()

var validPasswdCount: int
for line in input:
  var parts = line.split({'-', ':', ' '})
  parts.del(3) #Use del to remove empty string
  let
    (index1, index2) = (parts[0].parseInt() - 1, parts[1].parseInt() - 1)
    (letter, passwd) = (parts[2][0], parts[3])
  if passwd[index1] == letter xor passwd[index2] == letter:
    validPasswdCount += 1

echo validPasswdCount
