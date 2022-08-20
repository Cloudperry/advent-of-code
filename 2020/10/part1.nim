import algorithm, tables
import ../common

var input = getInputAsInt()
input.insert(0, 0) #Add charging port
input.add(input.max + 3) #Add device adapter

input.sort()
var prevN = input[0]
var diffCounts: CountTable[int]
for n in input[1 .. ^1]:
  let diff = n - prevN
  diffCounts.inc(diff)
  prevN = n

echo diffCounts[1] * diffCounts[3]
