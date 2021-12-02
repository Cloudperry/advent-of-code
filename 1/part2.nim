import strscans, math

var input: seq[int]

for line in lines("input.txt"):
  var depth: int
  if scanf(line, "$i", depth):
    input.add depth

iterator triples[T](s: seq[T]): seq[T] =
  for i in 0 .. s.high - 2:
    yield s[i .. i+2]

var prevSum, answer: int
for triple in input.triples:
  let sum = triple.sum
  if prevSum != 0 and sum > prevSum:
    answer += 1
  prevSum = sum

echo answer
