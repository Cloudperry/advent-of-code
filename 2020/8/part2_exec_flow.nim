#At first I tried to find a more elegant solution to part 2, than just swapping all the nops and jumps
#My solution is in part2.nim
import sets, strscans
import ../common

proc runLine(program: seq[string], env: var tuple[acc, lineN: int]): tuple[lineRan,
                                                                     jumpedTo: int] =
  var
    instruction: string
    argument: int
  if program[env.lineN].scanf("$+ $i", instruction, argument):
    result.lineRan = env.lineN
    #echo instruction, " ", argument
    if instruction == "nop":
      env.lineN += 1
    elif instruction == "acc":
      env.acc += argument
      env.lineN += 1
    elif instruction == "jmp":
      env.lineN += argument
    result.jumpedTo = env.lineN

let input = getInput()

var env: tuple[acc, lineN: int]
var linesRan: HashSet[int]
var execFlow: seq[tuple[lineRan, jumpedTo: int]]
while true:
  if not linesRan.containsOrIncl(env.lineN):
    #echo "running line ", env.lineN
    let lineData = runLine(input, env)
    if abs(lineData.lineRan - lineData.jumpedTo) > 1:
      execFlow.add(lineData)
  else:
    for jump in execFlow:
      echo jump.lineRan, " -> ", jump.jumpedTo
    #echo "line ", env.lineN, " is the first line to be executed twice"
    break
  if env.lineN > input.high: break
