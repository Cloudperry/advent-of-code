import algorithm, tables, math
import ../common

var input = getInputAsInt()
input.sort()
#Only parts of sorted input that can be changed, are sequences with consecutive numbers excluding the ones that are part of a 3 jolt jump
#Below is a table of how many permutations a sequence described above can have
const permutationsForSeqLen = {
  1: 2, 2: 4, 3: 7, 4: 8
}.toTable

var
  i, currentConsecutiveLen, currentConsecutiveStartI: int
  consecutiveSeqLengths: CountTable[int]

while i < input.high:
  proc addCurrentConsecutiveLen() =
    if currentConsecutiveStartI - 1 >= 0 and
    input[currentConsecutiveStartI] - input[currentConsecutiveStartI - 1] == 3:
      currentConsecutiveLen -= 1
    if currentConsecutiveLen > 0:
      consecutiveSeqLengths.inc(currentConsecutiveLen)
      #echo "found ", currentConsecutiveLen, " long sequence before ", i
    (currentConsecutiveLen, currentConsecutiveStartI) = (0, 0)

  i += 1
  let (n, prevN) = (input[i], input[i - 1])
  if n - prevN == 1:
    if currentConsecutiveStartI == 0:
      currentConsecutiveStartI = i - 1
    currentConsecutiveLen += 1
    if i == input.high:
      addCurrentConsecutiveLen()
  else:
    addCurrentConsecutiveLen()

var permutations = 1
for seqLen, count in consecutiveSeqLengths:
  permutations *= permutationsForSeqLen[seqLen] ^ count

echo permutations
