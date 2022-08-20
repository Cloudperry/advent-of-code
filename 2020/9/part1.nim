import algorithm
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
        if preamble[i1] + preamble[i2] == n:
          result = true

var sortedPreamble, preambleCutTooBig, preambleValidSum = newSeqOfCap[int](preambleSize)
while true:
  sortedPreamble = input[currI - preambleSize ..< currI].sorted()
  #echo sortedPreamble
  preambleCutTooBig = sortedPreamble[0 ..< sortedPreamble.upperBound(
                                     currN - min(sortedPreamble))]
  if preambleCutTooBig.len == 0:
    echo currN; break
  preambleValidSum = preambleCutTooBig[preambleCutTooBig.lowerBound(
                                       currN - max(preambleCutTooBig)) .. ^1]
  #echo preambleValidSumOnly
  if not preambleHasValidSum(preambleValidSum, currN):
    echo currN; break
  currI += 1
  if currI > input.high: break
  currN = input[currI]
