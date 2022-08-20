#At first I tried to find a more elegant solution to part 2, than just swapping all the nops and jumps
#My solution is in part2.nim
import tables, sets, strscans, strutils
import ../common

proc runLine(program: seq[string], env: var tuple[acc, lineN: int]): tuple[lineRan,
                                                                     lineAfter: int] =
  var
    instruction: string
    argument: int
  if program[env.lineN].scanf("$+ $i", instruction, argument):
    #echo instruction, " ", argument
    if instruction == "nop":
      env.lineN += 1
    elif instruction == "acc":
      env.acc += argument
      env.lineN += 1
    elif instruction == "jmp":
      result.lineRan = env.lineN
      env.lineN += argument
      result.lineAfter = env.lineN

let input = getInput()

var jumps: Table[int, int]
var env: tuple[acc, lineN: int]
for i in 0 .. input.high:
  env.lineN = i
  let jump = runLine(input, env)
  if jump != (0, 0):
    jumps[jump[0]] = jump[1]

stdout.write("Where do you want to jump? ")
let findJumpTo = stdin.readLine.parseInt()

for lineRan, jumpedTo in jumps.pairs:
  if jumpedTo == findJumpTo: echo lineRan
