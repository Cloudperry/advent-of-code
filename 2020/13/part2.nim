import strutils, strscans, sequtils, strformat, tables
import ../common

let input = getInput()
let ids = input[1].split(',')

for i, value in ids:
  var id: int
  if value.scanf("$i", id):

