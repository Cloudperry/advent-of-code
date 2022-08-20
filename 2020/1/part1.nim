import math
import ../common

let input = getInputAsInt()
let checksNeeded = binom(input.len, 2)

var checksDone: int
for i, n1 in input:
  for n2 in input[i+1 .. ^1]:
    checksDone += 1
    if n1 + n2 == 2020:
      echo n1 * n2
      echo checksDone, " pairs checked, ", checksNeeded, " checks necesary to cover all pairs"
