import algorithm, math
import ../common

let input = getInputAsInt()
const preambleSize = 25

var
  currI = preambleSize
  currN = input[currI]

proc preambleHasValidSum(preamble: seq[int], n: int): bool =
  if preamble.len != 0:
    for i1 in 0 .. preamble.high:
      for i2 in countdown(preamble.high, i1 + 1):
        #if preamble[i1] + preamble[i2] < n: break
        if preamble[i1] + preamble[i2] == n:
          result = true

var
  preambleCutTooBig, preambleValidSum = newSeqOfCap[int](preambleSize)
  sortedPreamble = input[currI - preambleSize ..< currI].sorted()
  invalidNumber: int

while true:
  preambleCutTooBig = sortedPreamble[0 ..< sortedPreamble.upperBound(
                                     currN - min(sortedPreamble))]
  if preambleCutTooBig.len == 0:
    invalidNumber = currN; break
  preambleValidSum = preambleCutTooBig[preambleCutTooBig.lowerBound(
                                       currN - max(preambleCutTooBig)) .. ^1]
  #echo preambleValidSumOnly
  if not preambleHasValidSum(preambleValidSum, currN):
    invalidNumber = currN; break
  let firstElm = input[currI - preambleSize]
  sortedPreamble.delete(sortedPreamble.find(firstElm))
  sortedPreamble.insert(currN, sortedPreamble.lowerBound(currN))
  currI += 1
  if currI > input.high: break
  currN = input[currI]

block setSizeLoop:
  for setSize in 2 .. input.len:
    var contigSet = input[0 ..< setSize]
    var i = setSize
    while true:
      if i > input.high: break
      let setSum = contigSet.sum
      if setSum > invalidNumber: break #Might be a bad assumption
      if setSum == invalidNumber:
        echo contigSet.min + contigSet.max
        break setSizeLoop
      contigSet.delete(0)
      contigSet.add(input[i])
      i += 1
