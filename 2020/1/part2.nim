import math
import ../common

let input = getInputAsInt()
let checksNeeded = binom(input.len, 3)

var checksDone: int
for i1, n1 in input:
  for i2, n2 in input[i1+1 .. ^1]:
    for n3 in input[i2+1 .. ^1]:
      checksDone += 1
      if n1 + n2 + n3 == 2020:
        echo n1 * n2 * n3
        echo checksDone, " pairs checked, ", checksNeeded, " checks necesary to cover all triples"
