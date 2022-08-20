import sets, strscans
import ../common

proc runLine(program: seq[string], env: var tuple[acc, lineN: int]) =
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
      env.lineN += argument

let input = getInput()

var env: tuple[acc, lineN: int]
var linesRan: HashSet[int]
while true:
  if not linesRan.containsOrIncl(env.lineN):
    #echo "running line ", env.lineN
    runLine(input, env)
  else:
    echo env.acc
    #echo "line ", env.lineN, " is the first line to be executed twice"
    break
  if env.lineN > input.high: break
